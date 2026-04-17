import 'package:barter_app/services/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppPurchasesTexts {
  final String revenueCatApiKeyMissing;
  final String failedToInitializePurchases;
  final String failedToLoadOfferings;
  final String noPremiumPackagesAvailable;
  final String premiumActivatedSuccessfully;
  final String purchaseCompletedEntitlementNotActiveYet;
  final String purchaseCancelled;
  final String purchaseFailed;
  final String premiumRestoredSuccessfully;
  final String noActivePremiumPurchasesToRestore;
  final String restoreFailed;

  const InAppPurchasesTexts({
    required this.revenueCatApiKeyMissing,
    required this.failedToInitializePurchases,
    required this.failedToLoadOfferings,
    required this.noPremiumPackagesAvailable,
    required this.premiumActivatedSuccessfully,
    required this.purchaseCompletedEntitlementNotActiveYet,
    required this.purchaseCancelled,
    required this.purchaseFailed,
    required this.premiumRestoredSuccessfully,
    required this.noActivePremiumPurchasesToRestore,
    required this.restoreFailed,
  });
}

class InAppPurchasesState {
  final bool isInitializing;
  final bool isLoadingOfferings;
  final bool isPurchasing;
  final bool isRestoring;
  final bool isPremium;
  final List<Package> availablePackages;
  final String? errorMessage;
  final String? statusMessage;

  const InAppPurchasesState({
    this.isInitializing = false,
    this.isLoadingOfferings = false,
    this.isPurchasing = false,
    this.isRestoring = false,
    this.isPremium = false,
    this.availablePackages = const [],
    this.errorMessage,
    this.statusMessage,
  });

  InAppPurchasesState copyWith({
    bool? isInitializing,
    bool? isLoadingOfferings,
    bool? isPurchasing,
    bool? isRestoring,
    bool? isPremium,
    List<Package>? availablePackages,
    String? errorMessage,
    String? statusMessage,
    bool clearError = false,
    bool clearStatus = false,
  }) {
    return InAppPurchasesState(
      isInitializing: isInitializing ?? this.isInitializing,
      isLoadingOfferings: isLoadingOfferings ?? this.isLoadingOfferings,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      isRestoring: isRestoring ?? this.isRestoring,
      isPremium: isPremium ?? this.isPremium,
      availablePackages: availablePackages ?? this.availablePackages,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      statusMessage: clearStatus ? null : (statusMessage ?? this.statusMessage),
    );
  }
}

class InAppPurchasesCubit extends Cubit<InAppPurchasesState> {
  final String appUserId;
  final String revenueCatApiKey;
  final String premiumEntitlementId;
  final InAppPurchasesTexts Function() texts;
  final ApiClient apiClient;
  final String webPurchaseLinkBaseUrl;

  static bool _isConfigured = false;

  InAppPurchasesCubit({
    required this.appUserId,
    required this.revenueCatApiKey,
    required this.texts,
    required this.apiClient,
    required this.webPurchaseLinkBaseUrl,
    this.premiumEntitlementId = 'Bartering App Premium',
  }) : super(const InAppPurchasesState());

  Future<void> initialize() async {
    emit(state.copyWith(
      isInitializing: true,
      clearError: true,
      clearStatus: true,
    ));

    final localized = texts();

    try {
      if (kIsWeb) {
        await refreshPremiumStatus();
        return;
      }

      if (revenueCatApiKey.isEmpty) {
        emit(state.copyWith(
          isInitializing: false,
          errorMessage: localized.revenueCatApiKeyMissing,
        ));
        return;
      }

      if (!_isConfigured) {
        await Purchases.setLogLevel(LogLevel.warn);
        final configuration = PurchasesConfiguration(revenueCatApiKey)
          ..appUserID = appUserId;
        await Purchases.configure(configuration);
        _isConfigured = true;
      } else {
        await Purchases.logIn(appUserId);
      }

      await loadOfferings();
      await refreshPremiumStatus();
    } catch (e) {
      emit(state.copyWith(
        errorMessage: '${localized.failedToInitializePurchases}: $e',
      ));
    } finally {
      emit(state.copyWith(isInitializing: false));
    }
  }

  Future<void> loadOfferings() async {
    if (kIsWeb) {
      emit(state.copyWith(isLoadingOfferings: false, availablePackages: const []));
      return;
    }

    emit(state.copyWith(isLoadingOfferings: true, clearError: true));

    final localized = texts();

    try {
      final offerings = await Purchases.getOfferings();
      final packages = offerings.current?.availablePackages ?? <Package>[];
      emit(state.copyWith(
        isLoadingOfferings: false,
        availablePackages: packages,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingOfferings: false,
        errorMessage: '${localized.failedToLoadOfferings}: $e',
      ));
    }
  }

  Future<void> purchasePremium() async {
    emit(state.copyWith(isPurchasing: true, clearError: true, clearStatus: true));

    final localized = texts();

    try {
      if (kIsWeb) {
        if (webPurchaseLinkBaseUrl.trim().isEmpty) {
          _logPurchaseError('web_config_missing', 'webPurchaseLinkBaseUrl is empty');
          emit(state.copyWith(
            isPurchasing: false,
            errorMessage:
                '${localized.purchaseFailed}: missing web purchase URL configuration',
          ));
          return;
        }

        final webPurchaseLink = _buildWebPurchaseLink();
        final launched = await launchUrl(
          webPurchaseLink,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_self',
        );

        if (!launched) {
          _logPurchaseError('web_launch_failed', 'Could not launch $webPurchaseLink');
        }

        emit(state.copyWith(
          isPurchasing: false,
          statusMessage: launched
              ? localized.purchaseCompletedEntitlementNotActiveYet
              : null,
          errorMessage: launched
              ? null
              : '${localized.purchaseFailed}: unable to open purchase page',
        ));
        return;
      }

      var packages = state.availablePackages;
      if (packages.isEmpty) {
        await loadOfferings();
        packages = state.availablePackages;
      }

      if (packages.isEmpty) {
        _logPurchaseError(
          'no_packages_available',
          'No packages found after loading offerings',
        );
        emit(state.copyWith(
          isPurchasing: false,
          errorMessage: localized.noPremiumPackagesAvailable,
        ));
        return;
      }

      final paywallResult = await RevenueCatUI.presentPaywallIfNeeded(
        premiumEntitlementId,
      );

      final customerInfo = await Purchases.getCustomerInfo();
      final premiumActive = _isPremiumActive(customerInfo);

      if (paywallResult == PaywallResult.cancelled) {
        emit(state.copyWith(
          isPurchasing: false,
          statusMessage: localized.purchaseCancelled,
          isPremium: premiumActive,
        ));
        return;
      }

      emit(state.copyWith(
        isPurchasing: false,
        isPremium: premiumActive,
        statusMessage: premiumActive
            ? localized.premiumActivatedSuccessfully
            : localized.purchaseCompletedEntitlementNotActiveYet,
      ));
    } on PlatformException catch (e, st) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        emit(state.copyWith(
          isPurchasing: false,
          statusMessage: localized.purchaseCancelled,
        ));
        return;
      }

      _logPurchaseError(
        'platform_exception',
        'code=${e.code}, message=${e.message ?? 'n/a'}, details=${e.details ?? 'n/a'}',
        st,
      );
      emit(state.copyWith(
        isPurchasing: false,
        errorMessage:
            '${localized.purchaseFailed}: code=${e.code}, message=${e.message ?? 'n/a'}',
      ));
    } catch (e, st) {
      _logPurchaseError('unexpected_exception', e, st);
      emit(state.copyWith(
        isPurchasing: false,
        errorMessage: '${localized.purchaseFailed}: $e',
      ));
    }
  }

  Future<void> restorePurchases() async {
    emit(state.copyWith(isRestoring: true, clearError: true, clearStatus: true));

    final localized = texts();

    try {
      final customerInfo = await Purchases.restorePurchases();
      final premiumActive = _isPremiumActive(customerInfo);

      emit(state.copyWith(
        isRestoring: false,
        isPremium: premiumActive,
        statusMessage: premiumActive
            ? localized.premiumRestoredSuccessfully
            : localized.noActivePremiumPurchasesToRestore,
      ));
    } catch (e) {
      emit(state.copyWith(
        isRestoring: false,
        errorMessage: '${localized.restoreFailed}: $e',
      ));
    }
  }

  Future<void> refreshPremiumStatus() async {
    try {
      if (kIsWeb) {
        final premiumStatus = await apiClient.getPremiumStatus();
        emit(state.copyWith(isPremium: premiumStatus.isPremium));
        return;
      }

      final customerInfo = await Purchases.getCustomerInfo();
      emit(state.copyWith(isPremium: _isPremiumActive(customerInfo)));
    } catch (e) {
      debugPrint('Failed to refresh premium status: $e');
    }
  }

  Uri _buildWebPurchaseLink() {
    final normalizedBase = webPurchaseLinkBaseUrl.trim();
    final baseUri = Uri.parse(normalizedBase);
    final cleanPath = baseUri.path.endsWith('/')
        ? baseUri.path.substring(0, baseUri.path.length - 1)
        : baseUri.path;

    return baseUri.replace(path: '$cleanPath/$appUserId');
  }

  bool _isPremiumActive(CustomerInfo customerInfo) {
    return customerInfo.entitlements.active.containsKey(premiumEntitlementId);
  }

  void _logPurchaseError(String context, Object error, [StackTrace? st]) {
    debugPrint('[IAP][purchasePremium][$context] $error');
    if (st != null) {
      debugPrint('[IAP][purchasePremium][$context][stack] $st');
    }
  }

}
