part of 'avatar_shop_cubit.dart';

enum AvatarShopStatus { initial, loading, loaded, error }

class AvatarShopState extends Equatable {
  final AvatarShopStatus status;
  final bool isPurchasing;
  final String? processingAsset;
  final String? userId;
  final UserProfileData? profile;
  final WalletResponse? wallet;
  final Map<String, String> avatarSvgByAssetPath;
  final Set<String> ownedIconIds;
  final String? equippedIconId;
  final String? errorMessage;
  final String? infoMessage;
  final String? successMessage;

  const AvatarShopState({
    this.status = AvatarShopStatus.initial,
    this.isPurchasing = false,
    this.processingAsset,
    this.userId,
    this.profile,
    this.wallet,
    this.avatarSvgByAssetPath = const {},
    this.ownedIconIds = const <String>{},
    this.equippedIconId,
    this.errorMessage,
    this.infoMessage,
    this.successMessage,
  });

  int get availableCoins => wallet?.availableBalance ?? 0;

  AvatarShopState copyWith({
    AvatarShopStatus? status,
    bool? isPurchasing,
    String? processingAsset,
    String? userId,
    UserProfileData? profile,
    WalletResponse? wallet,
    Map<String, String>? avatarSvgByAssetPath,
    Set<String>? ownedIconIds,
    String? equippedIconId,
    String? errorMessage,
    String? infoMessage,
    String? successMessage,
    bool clearError = false,
    bool clearInfo = false,
    bool clearSuccess = false,
  }) {
    return AvatarShopState(
      status: status ?? this.status,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      processingAsset: processingAsset,
      userId: userId ?? this.userId,
      profile: profile ?? this.profile,
      wallet: wallet ?? this.wallet,
      avatarSvgByAssetPath: avatarSvgByAssetPath ?? this.avatarSvgByAssetPath,
      ownedIconIds: ownedIconIds ?? this.ownedIconIds,
      equippedIconId: equippedIconId ?? this.equippedIconId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        isPurchasing,
        processingAsset,
        userId,
        profile,
        wallet,
        avatarSvgByAssetPath,
        ownedIconIds,
        equippedIconId,
        errorMessage,
        infoMessage,
        successMessage,
      ];
}
