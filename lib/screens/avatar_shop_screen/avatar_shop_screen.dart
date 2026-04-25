import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/avatar_shop_screen/cubit/avatar_shop_cubit.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarShopScreen extends StatelessWidget {
  const AvatarShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvatarShopCubit(
        apiClient: getIt<ApiClient>(),
        userRepository: getIt<UserRepository>(),
      )..loadData(),
      child: const _AvatarShopView(),
    );
  }
}

class _AvatarShopView extends StatelessWidget {
  const _AvatarShopView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AvatarShopCubit, AvatarShopState>(
      listener: (context, state) {
        final cubit = context.read<AvatarShopCubit>();

        if (state.successMessage != null) {
          final text = state.successMessage == 'avatar_equip_success'
              ? l10n.avatarShopSelected
              : l10n.avatarShopPurchaseSuccess;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(text),
              backgroundColor: Colors.green,
            ),
          );
          cubit.clearTransientMessages();
          return;
        }

        if (state.infoMessage != null) {
          final text = switch (state.infoMessage) {
            'unable_to_process_purchase' => l10n.avatarShopUnableToProcessPurchase,
            'avatar_already_selected' => l10n.avatarShopAvatarAlreadySelected,
            _ when state.infoMessage!.startsWith('not_enough_coins::') =>
              l10n.avatarShopNotEnoughCoins(int.tryParse(state.infoMessage!.split('::').last) ?? AvatarShopCubit.avatarPriceCoins),
            'not_enough_coins' => l10n.avatarShopNotEnoughCoins(AvatarShopCubit.avatarPriceCoins),
            _ => state.infoMessage!,
          };
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
          cubit.clearTransientMessages();
          return;
        }

        if (state.errorMessage != null && state.status != AvatarShopStatus.error) {
          final text = state.errorMessage!.startsWith('purchase_failed::')
              ? l10n.avatarShopPurchaseFailed(
                  state.errorMessage!.replaceFirst('purchase_failed::', ''),
                )
              : state.errorMessage!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(text),
              backgroundColor: Colors.red,
            ),
          );
          cubit.clearTransientMessages();
        }
      },
      builder: (context, state) {
        final cubit = context.read<AvatarShopCubit>();
        final canRefresh = state.status != AvatarShopStatus.loading && !state.isPurchasing;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.avatarShopTitle),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: canRefresh ? cubit.loadData : null,
                icon: const Icon(Icons.refresh),
                tooltip: l10n.avatarShopRefresh,
              ),
            ],
          ),
          body: _buildBody(context, state, cubit, l10n),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AvatarShopState state,
    AvatarShopCubit cubit,
    AppLocalizations l10n,
  ) {
    if (state.status == AvatarShopStatus.loading || state.status == AvatarShopStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == AvatarShopStatus.error) {
      final errorText = state.errorMessage != null
          ? l10n.avatarShopLoadFailed(state.errorMessage!.replaceFirst('load_failed::', ''))
          : l10n.avatarShopLoadFailed(l10n.error);

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: cubit.loadData,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  l10n.avatarShopBalance(state.availableCoins.toString()),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              Text(l10n.avatarShopEachAvatarPrice(AvatarShopCubit.avatarPriceCoins.toString())),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.avatarShopDescription,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  (constraints.maxWidth / 180).floor().clamp(3, 6);
              final standardAssets = cubit.standardAvatarAssetPaths;
              final premiumAssets = cubit.premiumAvatarAssetPaths;

              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _buildSectionHeader(
                    title: 'Standard Icons',
                    subtitle: '${AvatarShopCubit.avatarPriceCoins} coins each',
                  ),
                  _buildAvatarGrid(
                    context,
                    state,
                    cubit,
                    l10n,
                    standardAssets,
                    crossAxisCount,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader(
                    title: 'Premium Icons',
                    subtitle: '${AvatarShopCubit.premiumAvatarPriceCoins} coins each',
                  ),
                  _buildAvatarGrid(
                    context,
                    state,
                    cubit,
                    l10n,
                    premiumAssets,
                    crossAxisCount,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarGrid(
    BuildContext context,
    AvatarShopState state,
    AvatarShopCubit cubit,
    AppLocalizations l10n,
    List<String> assetPaths,
    int crossAxisCount,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemCount: assetPaths.length,
      itemBuilder: (context, index) {
        final assetPath = assetPaths[index];
        final svgContent = state.avatarSvgByAssetPath[assetPath];
        final isCurrent = cubit.isCurrentAvatar(assetPath);
        final isOwned = cubit.isOwnedAvatar(assetPath);
        final isProcessing = state.processingAsset == assetPath;
        final avatarPrice = cubit.avatarPriceForAssetPath(assetPath);
        final canAfford = state.availableCoins >= avatarPrice;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: svgContent == null
                        ? const Center(child: CircularProgressIndicator())
                        : SvgPicture.string(svgContent),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (isCurrent || isProcessing || state.isPurchasing || (!isOwned && !canAfford))
                        ? null
                        : () => cubit.buyAndApplyAvatar(assetPath),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrent ? Colors.green : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: isProcessing
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isCurrent
                                ? l10n.avatarShopSelected
                                : (isOwned
                                    ? l10n.avatarShopEquip
                                    : (canAfford
                                        ? l10n.avatarShopBuyButton(avatarPrice.toString())
                                        : l10n.avatarShopNeedCoins(avatarPrice.toString()))),
                            style: const TextStyle(fontSize: 12),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
