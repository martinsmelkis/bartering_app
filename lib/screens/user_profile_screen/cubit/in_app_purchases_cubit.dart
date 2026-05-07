import 'dart:convert';

import 'package:barter_app/models/wallet/wallet_models.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/settings_service.dart';
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
  static const Map<int, _CoinPackConfig> _coinPackConfigs = {
    20: _CoinPackConfig(productId: 'android_coins_20', amountMinor: 111),
    50: _CoinPackConfig(productId: 'android_coins_50', amountMinor: 222),
    200: _CoinPackConfig(productId: 'android_coins_200', amountMinor: 555),
  };

  final String appUserId;
  final String revenueCatApiKey;
  final String premiumEntitlementId;
  final InAppPurchasesTexts Function() texts;
  final ApiClient apiClient;
  final String webPurchaseLinkBaseUrl;
  final String webCoins20PurchaseLinkBaseUrl;
  final String webCoins50PurchaseLinkBaseUrl;
  final String webCoins200PurchaseLinkBaseUrl;

  static bool _isConfigured = false;

  InAppPurchasesCubit({
    required this.appUserId,
    required this.revenueCatApiKey,
    required this.texts,
    required this.apiClient,
    required this.webPurchaseLinkBaseUrl,
    required this.webCoins20PurchaseLinkBaseUrl,
    required this.webCoins50PurchaseLinkBaseUrl,
    required this.webCoins200PurchaseLinkBaseUrl,
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
        _debugLogErrorState(
          'initialize_missing_api_key',
          localized.revenueCatApiKeyMissing,
        );
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
    } catch (e, st) {
      _debugLogErrorState('initialize_exception', e, st);
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

      if (packages.isEmpty) {
        _debugLogErrorState(
          'load_offerings_empty_packages',
          'No packages in current offering. '
              'currentOffering=${offerings.current?.identifier ?? 'null'}, '
              'allOfferingKeys=${offerings.all.keys.join(',')}',
        );
      }

      emit(state.copyWith(
        isLoadingOfferings: false,
        availablePackages: packages,
      ));
    } catch (e, st) {
      _debugLogErrorState('load_offerings_exception', e, st);
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
        _debugLogErrorState(
          'purchase_premium_no_packages_available',
          'No packages found after loading offerings',
        );
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

      _debugLogErrorState(
        'purchase_premium_platform_exception',
        'code=${e.code}, message=${e.message ?? 'n/a'}, details=${e.details ?? 'n/a'}',
        st,
      );
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
      _debugLogErrorState('purchase_premium_unexpected_exception', e, st);
      _logPurchaseError('unexpected_exception', e, st);
      emit(state.copyWith(
        isPurchasing: false,
        errorMessage: '${localized.purchaseFailed}: $e',
      ));
    }
  }

  Future<void> purchase20Coins() => _purchaseCoinPack(20);

  Future<void> purchase50Coins() => _purchaseCoinPack(50);

  Future<void> purchase200Coins() => _purchaseCoinPack(200);

  Future<void> _purchaseCoinPack(int coinAmount) async {
    emit(state.copyWith(isPurchasing: true, clearError: true, clearStatus: true));

    final localized = texts();
    final config = _coinPackConfigs[coinAmount];

    if (config == null) {
      emit(state.copyWith(
        isPurchasing: false,
        errorMessage: 'Coin pack $coinAmount is not configured yet.',
      ));
      return;
    }

    try {
      if (kIsWeb) {
        final webCoinsPurchaseLinkBaseUrl = _webCoinsPurchaseLinkBaseUrlByAmount(
          coinAmount,
        );

        if (webCoinsPurchaseLinkBaseUrl == null) {
          emit(state.copyWith(
            isPurchasing: false,
            errorMessage: 'Coin pack $coinAmount is not available on web yet.',
          ));
          return;
        }

        if (webCoinsPurchaseLinkBaseUrl.trim().isEmpty) {
          _logPurchaseError(
            'coins${coinAmount}_web_config_missing',
            'web coins link base URL is empty for amount=$coinAmount',
          );
          emit(state.copyWith(
            isPurchasing: false,
            errorMessage:
                '${localized.purchaseFailed}: missing web coins purchase URL configuration',
          ));
          return;
        }

        final settingsService = SettingsService();
        await settingsService.setPendingPurchase(true);

        final webCoinsPurchaseLink = _buildWebCoinsPurchaseLink(
          webCoinsPurchaseLinkBaseUrl,
        );
        final launched = await launchUrl(
          webCoinsPurchaseLink,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_self',
        );

        if (!launched) {
          _logPurchaseError(
            'coins${coinAmount}_web_launch_failed',
            'Could not launch $webCoinsPurchaseLink',
          );
          await settingsService.clearPendingPurchase();
        }

        emit(state.copyWith(
          isPurchasing: false,
          statusMessage: launched
              ? localized.purchaseCompletedEntitlementNotActiveYet
              : null,
          errorMessage: launched
              ? null
              : '${localized.purchaseFailed}: unable to open coins purchase page',
        ));
        return;
      }

      final products = await Purchases.getProducts([config.productId]);
      final coinProduct = products.firstOrNull;

      if (coinProduct == null) {
        _debugLogErrorState(
          'purchase_coins_product_not_found',
          'No product matched ${config.productId}',
        );
        emit(state.copyWith(
          isPurchasing: false,
          errorMessage: '$coinAmount-coin product is not configured yet.',
        ));
        return;
      }

      await Purchases.purchase(
        PurchaseParams.storeProduct(coinProduct),
      );

      final purchaseResponse = await apiClient.purchaseCoinPack(
        PurchaseCoinPackRequest(
          userId: appUserId,
          coinAmount: coinAmount,
          currency: 'EUR',
          amountMinor: config.amountMinor,
          externalRef:
              'rc_${config.productId}_${DateTime.now().millisecondsSinceEpoch}',
          metadataJson: jsonEncode({
            'source': 'revenuecat_draft',
            'productId': coinProduct.identifier,
          }),
        ),
      );

      emit(state.copyWith(
        isPurchasing: false,
        statusMessage: purchaseResponse.message.isNotEmpty
            ? purchaseResponse.message
            : '$coinAmount coins purchase completed.',
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

      _debugLogErrorState(
        'purchase_coins_platform_exception',
        'code=${e.code}, message=${e.message ?? 'n/a'}, details=${e.details ?? 'n/a'}',
        st,
      );
      emit(state.copyWith(
        isPurchasing: false,
        errorMessage:
            '${localized.purchaseFailed}: code=${e.code}, message=${e.message ?? 'n/a'}',
      ));
    } catch (e, st) {
      _debugLogErrorState('purchase_coins_unexpected_exception', e, st);
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
    } catch (e, st) {
      _debugLogErrorState('restore_purchases_exception', e, st);
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
    } catch (e, st) {
      _debugLogErrorState('refresh_premium_status_exception', e, st);
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

  String? _webCoinsPurchaseLinkBaseUrlByAmount(int coinAmount) {
    switch (coinAmount) {
      case 20:
        return webCoins20PurchaseLinkBaseUrl;
      case 50:
        return webCoins50PurchaseLinkBaseUrl;
      case 200:
        return webCoins200PurchaseLinkBaseUrl;
      default:
        return null;
    }
  }

  Uri _buildWebCoinsPurchaseLink(String baseUrl) {
    final normalizedBase = baseUrl.trim();
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

  void _debugLogErrorState(String context, Object error, [StackTrace? st]) {
    if (!kDebugMode) return;

    debugPrint('[IAP][debug][$context] $error');
    debugPrint(
      '[IAP][debug][$context][state] '
      'isInitializing=${state.isInitializing}, '
      'isLoadingOfferings=${state.isLoadingOfferings}, '
      'isPurchasing=${state.isPurchasing}, '
      'isRestoring=${state.isRestoring}, '
      'isPremium=${state.isPremium}, '
      'availablePackages=${state.availablePackages.length}, '
      'hasError=${state.errorMessage != null}, '
      'hasStatus=${state.statusMessage != null}',
    );

    if (st != null) {
      debugPrint('[IAP][debug][$context][stack] $st');
    }
  }
}

class _CoinPackConfig {
  final String productId;
  final int amountMinor;

  const _CoinPackConfig({
    required this.productId,
    required this.amountMinor,
  });
}
