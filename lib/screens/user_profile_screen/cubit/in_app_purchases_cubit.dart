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
    20: _CoinPackConfig(
      androidProductId: 'android_coins_20',
      iosProductId: '20_coins_ios',
      amountMinor: 111,
    ),
    50: _CoinPackConfig(
      androidProductId: 'android_coins_50',
      iosProductId: 'coins_50_ios',
      amountMinor: 222,
    ),
    200: _CoinPackConfig(
      androidProductId: 'android_coins_200',
      iosProductId: 'coins_200_ios',
      amountMinor: 555,
    ),
  };

  final String appUserId;
  final String revenueCatApiKey;
  final String premiumEntitlementId;
  final String? premiumAndroidProductId;
  final String? premiumIosProductId;
  final String? coins20AndroidProductId;
  final String? coins20IosProductId;
  final String? coins50AndroidProductId;
  final String? coins50IosProductId;
  final String? coins200AndroidProductId;
  final String? coins200IosProductId;
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
    this.premiumAndroidProductId,
    this.premiumIosProductId,
    this.coins20AndroidProductId,
    this.coins20IosProductId,
    this.coins50AndroidProductId,
    this.coins50IosProductId,
    this.coins200AndroidProductId,
    this.coins200IosProductId,
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
        emit(state.copyWith(isInitializing: false));
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

      await loadOfferings(showUserFacingError: false);
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

  Future<void> loadOfferings({bool showUserFacingError = true}) async {
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
        errorMessage: showUserFacingError
            ? '${localized.failedToLoadOfferings}: ${_purchaseErrorMessage(e)}'
            : null,
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
        await loadOfferings(showUserFacingError: false);
        packages = state.availablePackages;
      }

      if (packages.isNotEmpty) {
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

        await _syncPremiumAfterPurchase(
          productId: packages.first.storeProduct.identifier,
          premiumActive: premiumActive,
        );

        emit(state.copyWith(
          isPurchasing: false,
          isPremium: premiumActive,
          statusMessage: premiumActive
              ? localized.premiumActivatedSuccessfully
              : localized.purchaseCompletedEntitlementNotActiveYet,
        ));
        return;
      }

      final premiumProduct = await _loadStoreProduct(
        _premiumProductIdsForCurrentPlatform,
        productCategory: ProductCategory.nonSubscription,
      );
      if (premiumProduct == null) {
        _debugLogErrorState(
          'purchase_premium_no_packages_or_product_available',
          'No offerings packages or direct premium product found. '
              'productIds=${_premiumProductIdsForCurrentPlatform.join(',')}',
        );
        _logPurchaseError(
          'no_packages_or_product_available',
          'No offerings packages or direct premium product found',
        );
        emit(state.copyWith(
          isPurchasing: false,
          errorMessage: localized.noPremiumPackagesAvailable,
        ));
        return;
      }

      await Purchases.purchase(
        PurchaseParams.storeProduct(premiumProduct),
      );

      final customerInfo = await Purchases.getCustomerInfo();
      final premiumActive = _isPremiumActive(customerInfo);
      await _syncPremiumAfterPurchase(
        productId: premiumProduct.identifier,
        premiumActive: premiumActive,
      );

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
        errorMessage: '${localized.purchaseFailed}: ${_purchaseErrorMessage(e)}',
      ));
    } catch (e, st) {
      _debugLogErrorState('purchase_premium_unexpected_exception', e, st);
      _logPurchaseError('unexpected_exception', e, st);
      emit(state.copyWith(
        isPurchasing: false,
        errorMessage: '${localized.purchaseFailed}: ${_purchaseErrorMessage(e)}',
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

      final productIds = _coinProductIdsForCurrentPlatform(coinAmount, config);
      final coinProduct = await _loadStoreProduct(
        productIds,
        productCategory: ProductCategory.nonSubscription,
      );

      if (coinProduct == null) {
        _debugLogErrorState(
          'purchase_coins_product_not_found',
          'No product matched any of ${productIds.join(',')}',
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
              'rc_${coinProduct.identifier}_${DateTime.now().millisecondsSinceEpoch}',
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
        errorMessage: '${localized.purchaseFailed}: ${_purchaseErrorMessage(e)}',
      ));
    } catch (e, st) {
      _debugLogErrorState('purchase_coins_unexpected_exception', e, st);
      emit(state.copyWith(
        isPurchasing: false,
        errorMessage: '${localized.purchaseFailed}: ${_purchaseErrorMessage(e)}',
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

  List<String> get _premiumProductIdsForCurrentPlatform {
    final configuredProductId = defaultTargetPlatform == TargetPlatform.iOS
        ? premiumIosProductId
        : premiumAndroidProductId;

    return _normalizedProductIds([
      configuredProductId,
      if (defaultTargetPlatform == TargetPlatform.iOS) ...[
        'premium_ios',
        'ios_premium',
        'bartering_app_premium_ios',
      ] else ...[
        'premium',
        'android_premium',
        'premium_lifetime_user_android',
      ],
    ]);
  }

  List<String> _coinProductIdsForCurrentPlatform(
    int coinAmount,
    _CoinPackConfig fallbackConfig,
  ) {
    final configuredProductId = switch (coinAmount) {
      20 => defaultTargetPlatform == TargetPlatform.iOS
          ? coins20IosProductId
          : coins20AndroidProductId,
      50 => defaultTargetPlatform == TargetPlatform.iOS
          ? coins50IosProductId
          : coins50AndroidProductId,
      200 => defaultTargetPlatform == TargetPlatform.iOS
          ? coins200IosProductId
          : coins200AndroidProductId,
      _ => null,
    };

    final legacyProductId = fallbackConfig.productIdForCurrentPlatform;
    final platformPrefix = defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';

    return _normalizedProductIds([
      configuredProductId,
      legacyProductId,
      '${platformPrefix}_coins_$coinAmount',
      'coins_${coinAmount}_$platformPrefix',
      '${coinAmount}_coins_$platformPrefix',
      'coins_$coinAmount',
    ]);
  }

  Future<StoreProduct?> _loadStoreProduct(
    List<String> productIds, {
    ProductCategory productCategory = ProductCategory.subscription,
  }) async {
    if (productIds.isEmpty) return null;

    final products = await Purchases.getProducts(
      productIds,
      productCategory: productCategory,
    );
    for (final productId in productIds) {
      final product = products.where((product) => product.identifier == productId).firstOrNull;
      if (product != null) return product;
    }

    return products.firstOrNull;
  }

  List<String> _normalizedProductIds(Iterable<String?> productIds) {
    final normalizedProductIds = <String>[];
    for (final productId in productIds) {
      final normalizedProductId = _nonBlankOrNull(productId);
      if (normalizedProductId == null || normalizedProductIds.contains(normalizedProductId)) {
        continue;
      }
      normalizedProductIds.add(normalizedProductId);
    }
    return normalizedProductIds;
  }

  Future<void> _syncPremiumAfterPurchase({
    required String productId,
    required bool premiumActive,
  }) async {
    try {
      await apiClient.syncPremiumNow();
    } catch (e, st) {
      _debugLogErrorState('sync_premium_after_purchase_failed', e, st);
    }

    if (premiumActive) return;

    try {
      await apiClient.purchasePremiumLifetime(
        PurchasePremiumLifetimeRequest(
          userId: appUserId,
          currency: 'EUR',
          amountMinor: 0,
          externalRef: 'rc_${productId}_${DateTime.now().millisecondsSinceEpoch}',
          metadataJson: jsonEncode({
            'source': 'revenuecat_native',
            'productId': productId,
          }),
        ),
      );
    } catch (e, st) {
      _debugLogErrorState('record_premium_after_purchase_failed', e, st);
    }
  }

  String _purchaseErrorMessage(Object error) {
    if (error is PlatformException) {
      final message = error.message;
      final details = error.details;
      if (details is Map && details['readableErrorCode'] == 'ConfigurationError') {
        return 'Store products are not configured for this app build yet.';
      }
      if (message != null && message.trim().isNotEmpty) {
        return message;
      }
      return 'Store purchase failed with code ${error.code}.';
    }

    return error.toString();
  }

  String? _nonBlankOrNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
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
  final String androidProductId;
  final String iosProductId;
  final int amountMinor;

  const _CoinPackConfig({
    required this.androidProductId,
    required this.iosProductId,
    required this.amountMinor,
  });

  String get productIdForCurrentPlatform =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? iosProductId
          : androidProductId;
}
