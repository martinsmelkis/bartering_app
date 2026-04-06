import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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

  static bool _isConfigured = false;

  InAppPurchasesCubit({
    required this.appUserId,
    required this.revenueCatApiKey,
    this.premiumEntitlementId = 'premium_user',
  }) : super(const InAppPurchasesState());

  Future<void> initialize() async {
    emit(state.copyWith(
      isInitializing: true,
      clearError: true,
      clearStatus: true,
    ));

    if (revenueCatApiKey.isEmpty) {
      emit(state.copyWith(
        isInitializing: false,
        errorMessage: 'RevenueCat API key is missing.',
      ));
      return;
    }

    try {
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
        errorMessage: 'Failed to initialize purchases: $e',
      ));
    } finally {
      emit(state.copyWith(isInitializing: false));
    }
  }

  Future<void> loadOfferings() async {
    emit(state.copyWith(isLoadingOfferings: true, clearError: true));

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
        errorMessage: 'Failed to load offerings: $e',
      ));
    }
  }

  Future<void> purchasePremium() async {
    emit(state.copyWith(isPurchasing: true, clearError: true, clearStatus: true));

    try {
      var packages = state.availablePackages;
      if (packages.isEmpty) {
        await loadOfferings();
        packages = state.availablePackages;
      }

      if (packages.isEmpty) {
        emit(state.copyWith(
          isPurchasing: false,
          errorMessage: 'No premium packages available right now.',
        ));
        return;
      }

      final targetPackage = _selectPreferredPackage(packages);
      final purchaseParams = PurchaseParams.package(targetPackage);
      final purchaseResult = await Purchases.purchase(purchaseParams);

      final premiumActive = _isPremiumActiveFromResult(purchaseResult);

      emit(state.copyWith(
        isPurchasing: false,
        isPremium: premiumActive,
        statusMessage: premiumActive
            ? 'Premium activated successfully.'
            : 'Purchase completed, but entitlement not active yet.',
      ));
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        emit(state.copyWith(
          isPurchasing: false,
          statusMessage: 'Purchase cancelled.',
        ));
        return;
      }

      emit(state.copyWith(
        isPurchasing: false,
        errorMessage: 'Purchase failed: ${e.message ?? e.code}',
      ));
    } catch (e) {
      emit(state.copyWith(
        isPurchasing: false,
        errorMessage: 'Purchase failed: $e',
      ));
    }
  }

  Future<void> restorePurchases() async {
    emit(state.copyWith(isRestoring: true, clearError: true, clearStatus: true));

    try {
      final customerInfo = await Purchases.restorePurchases();
      final premiumActive = _isPremiumActive(customerInfo);

      emit(state.copyWith(
        isRestoring: false,
        isPremium: premiumActive,
        statusMessage: premiumActive
            ? 'Premium restored successfully.'
            : 'No active Premium purchases found to restore.',
      ));
    } catch (e) {
      emit(state.copyWith(
        isRestoring: false,
        errorMessage: 'Restore failed: $e',
      ));
    }
  }

  Future<void> refreshPremiumStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      emit(state.copyWith(isPremium: _isPremiumActive(customerInfo)));
    } catch (e) {
      debugPrint('Failed to refresh premium status: $e');
    }
  }

  Package _selectPreferredPackage(List<Package> packages) {
    for (final type in [
      PackageType.annual,
      PackageType.monthly,
      PackageType.lifetime,
      PackageType.weekly,
    ]) {
      final match = packages.where((p) => p.packageType == type);
      if (match.isNotEmpty) return match.first;
    }

    return packages.first;
  }

  bool _isPremiumActive(CustomerInfo customerInfo) {
    return customerInfo.entitlements.active.containsKey(premiumEntitlementId);
  }

  bool _isPremiumActiveFromResult(PurchaseResult purchaseResult) {
    return _isPremiumActive(purchaseResult.customerInfo);
  }
}
