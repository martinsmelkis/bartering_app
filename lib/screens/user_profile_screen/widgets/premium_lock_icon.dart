import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class PremiumLockIcon extends StatelessWidget {
  final bool isPremiumActive;
  final VoidCallback onTap;

  const PremiumLockIcon({
    super.key,
    required this.isPremiumActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.4),
        child: SizedBox(
          width: isPremiumActive ? 28.8 : 24,
          height: isPremiumActive ? 28.8 : 24,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.35),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Icon(
                    isPremiumActive ? Icons.stars_sharp : Icons.lock,
                    size: isPremiumActive ? 16.8 : 14,
                    color: isPremiumActive ? Colors.green : AppColors.primary,
                  ),
                ),
                if (isPremiumActive)
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.35),
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
