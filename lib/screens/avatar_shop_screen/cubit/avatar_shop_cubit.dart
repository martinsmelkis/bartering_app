import 'dart:convert';

import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/models/wallet/wallet_models.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/avatar_icon_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'avatar_shop_state.dart';

class AvatarShopCubit extends Cubit<AvatarShopState> {
  static const int avatarPriceCoins = 100;
  static const int avatarCount = 29;

  final ApiClient _apiClient;
  final UserRepository _userRepository;

  AvatarShopCubit({
    required ApiClient apiClient,
    required UserRepository userRepository,
  })  : _apiClient = apiClient,
        _userRepository = userRepository,
        super(const AvatarShopState());

  List<String> get avatarAssetPaths =>
      List.generate(avatarCount, (index) => 'assets/icons/avatars/path${index + 1}.svg');

  String iconIdForAssetPath(String assetPath) => AvatarIconUtils.iconIdFromAssetPath(assetPath);

  bool isOwnedAvatar(String assetPath) =>
      state.ownedIconIds.contains(iconIdForAssetPath(assetPath));

  bool isEquippedAvatar(String assetPath) =>
      state.equippedIconId == iconIdForAssetPath(assetPath);

  Future<void> loadData() async {
    emit(
      state.copyWith(
        status: AvatarShopStatus.loading,
        clearError: true,
        clearInfo: true,
        clearSuccess: true,
      ),
    );

    try {
      final userId = await _userRepository.getUserId();
      if (userId == null || userId.isEmpty) {
        throw Exception('missing_user_id');
      }

      final result = await Future.wait<dynamic>([
        _apiClient.getWallet(),
        _apiClient.getProfileInfo(userId),
        _apiClient.getAvatarIconOwnershipStatus(),
        _loadAllAvatarSvgs(),
      ]);

      final ownership = result[2] as AvatarIconOwnershipStatusResponse;
      final profile = result[1] as UserProfileData;

      emit(
        state.copyWith(
          status: AvatarShopStatus.loaded,
          userId: userId,
          wallet: result[0] as WalletResponse,
          profile: profile,
          avatarSvgByAssetPath: result[3] as Map<String, String>,
          ownedIconIds: ownership.purchasedIconIds.toSet(),
          equippedIconId: ownership.activeAvatarIconId ?? profile.profileAvatarIconId,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AvatarShopStatus.error,
          errorMessage: 'load_failed::$e',
        ),
      );
    }
  }

  Future<Map<String, String>> _loadAllAvatarSvgs() async {
    final svgByPath = Map<String, String>.from(state.avatarSvgByAssetPath);
    for (final path in avatarAssetPaths) {
      if (svgByPath.containsKey(path)) continue;
      final svg = await rootBundle.loadString(path);
      svgByPath[path] = svg.trim();
    }
    return svgByPath;
  }

  String? _normalizedCurrentAvatar() {
    final raw = state.profile?.profileAvatarIcon?.trim();
    if (raw == null || raw.isEmpty) return null;

    if (raw.contains('<svg')) return raw;

    if (raw.startsWith('data:image/svg+xml;base64,')) {
      final encoded = raw.split(',').last;
      return utf8.decode(base64Decode(encoded), allowMalformed: true).trim();
    }

    return null;
  }

  bool isCurrentAvatar(String assetPath) {
    if (isEquippedAvatar(assetPath)) return true;

    final selected = state.avatarSvgByAssetPath[assetPath]?.trim();
    final current = _normalizedCurrentAvatar()?.trim();
    return selected != null && current != null && selected == current;
  }

  Future<void> buyAndApplyAvatar(String assetPath) async {
    if (state.isPurchasing) return;

    final userId = state.userId;
    final profile = state.profile;
    final avatarSvg = state.avatarSvgByAssetPath[assetPath];

    if (userId == null || profile == null || avatarSvg == null) {
      emit(state.copyWith(infoMessage: 'unable_to_process_purchase'));
      return;
    }

    final iconId = iconIdForAssetPath(assetPath);

    if (isEquippedAvatar(assetPath)) {
      emit(state.copyWith(infoMessage: 'avatar_already_selected'));
      return;
    }

    emit(
      state.copyWith(
        isPurchasing: true,
        processingAsset: assetPath,
        clearError: true,
        clearInfo: true,
        clearSuccess: true,
      ),
    );

    try {
      final wasOwnedBefore = isOwnedAvatar(assetPath);
      var refreshedWallet = state.wallet;
      var ownedIconIds = state.ownedIconIds;

      if (!wasOwnedBefore) {
        if (state.availableCoins < avatarPriceCoins) {
          emit(
            state.copyWith(
              isPurchasing: false,
              processingAsset: null,
              infoMessage: 'not_enough_coins',
            ),
          );
          return;
        }

        final purchaseResponse = await _apiClient.purchaseAvatarIcon(
          PurchaseAvatarIconRequest(
            userId: userId,
            iconId: iconId,
            costCoins: avatarPriceCoins,
            externalRef: 'avatar_shop_${userId}_${DateTime.now().millisecondsSinceEpoch}',
            metadataJson: jsonEncode({
              'source': 'avatar_shop',
              'avatarAssetPath': assetPath,
              'iconId': iconId,
            }),
          ),
        );

        if (!purchaseResponse.success) {
          throw Exception(
            purchaseResponse.message.isNotEmpty
                ? purchaseResponse.message
                : 'avatar_purchase_failed',
          );
        }

        refreshedWallet = await _apiClient.getWallet();
        ownedIconIds = {...ownedIconIds, iconId};
      }

      final equipResponse = await _apiClient.equipAvatarIcon(
        EquipAvatarIconRequest(
          userId: userId,
          iconId: iconId,
        ),
      );

      if (!equipResponse.success) {
        throw Exception(
          equipResponse.message.isNotEmpty
              ? equipResponse.message
              : 'avatar_equip_failed',
        );
      }

      final updatedProfile = profile.copyWith(
        profileAvatarIcon: avatarSvg,
        profileAvatarIconId: iconId,
      );
      //await _apiClient.updateProfileInfo(updatedProfile);
      _userRepository.invalidateCachedProfileInfo();
      _userRepository.setCachedProfileInfo(updatedProfile);

      emit(
        state.copyWith(
          isPurchasing: false,
          processingAsset: null,
          profile: updatedProfile,
          wallet: refreshedWallet,
          ownedIconIds: ownedIconIds,
          equippedIconId: iconId,
          successMessage: wasOwnedBefore
              ? 'avatar_equip_success'
              : 'avatar_purchase_success',
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isPurchasing: false,
          processingAsset: null,
          errorMessage: 'purchase_failed::$e',
        ),
      );
    }
  }

  void clearTransientMessages() {
    emit(state.copyWith(clearError: true, clearInfo: true, clearSuccess: true));
  }
}
