import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/user_repository.dart';
import '../../services/api_client.dart';
import '../../utils/text_utils.dart';
import '../../widgets/responsive_center_container.dart';
import '../../widgets/selectable_attribute_bubble.dart';
import 'cubit/offers_cubit.dart';

class OffersScreen extends StatelessWidget {
  bool? isInitialOnboarding = true;
  OffersScreen({super.key, this.isInitialOnboarding});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OffersCubit(ApiClient.create(), getIt<UserRepository>()),
      child: OffersScreenWidget(isInitialOnboarding: isInitialOnboarding),
    );
  }
}

class OffersScreenWidget extends StatefulWidget {
  bool? isInitialOnboarding = true;
  OffersScreenWidget({super.key, this.isInitialOnboarding});

  @override
  State<OffersScreenWidget> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreenWidget> {

  final _customKeywordController = TextEditingController();

  @override
  void dispose() {
    _customKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;
    var _offersCubit = context.read<OffersCubit>();

    return BlocListener<OffersCubit, OffersState>(
      listener: (context, state) async {
        if (state.status == OffersStatus.error) {
          // Check if it's the validation error and use localized message
          String errorMessage = state.errorMessage ?? 
              AppLocalizations.of(context)!.anUnknownErrorOccurred;
          
          if (state.errorMessage?.contains('Please select at least one offer') == true) {
            errorMessage = AppLocalizations.of(context)!.pleaseSelectAtLeastOneOffer;
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        } else if (state.status == OffersStatus.success) {
          if (this.widget.isInitialOnboarding == false) {
            // Not in onboarding, pop back to caller (UserProfileScreen will handle navigation)
            if (context.canPop()) {
              context.pop();
            }
          } else {
            // In onboarding, continue to location picker
            context.pushReplacement('/location-picker');
          }
        }

      },
      child: BlocBuilder<OffersCubit, OffersState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text(l10n.selectYourOffers),
                ),
                body: ResponsiveCenterContainer(
                  maxWidth: 700.0,
                  child: BlocBuilder<OffersCubit, OffersState>(
                    builder: (context, innerState) {
              // Determine spacing based on screen width
              final screenWidth = MediaQuery.of(context).size.width;
              final isLargeScreen = screenWidth >= 600;
              final spacing = isLargeScreen ? 8.0 : 4.0;
              final runSpacing = isLargeScreen ? 8.0 : (kIsWeb ? 4.0 : 0.0);
              
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info text
                    Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Icon(
                                Icons.arrow_upward,
                                size: 20,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.selectTheOffersThatYouCanProvide,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.black.withValues(alpha: 0.8),
                                  fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 12) * 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: isLargeScreen ? 16 : 12),
                    Wrap(
                      spacing: spacing,
                      runSpacing: runSpacing,
                      children: state.allOffers.map((offer) {
                        final isSelected = state.selectedOffers.contains(
                            offer);

                        return SelectableAttributeBubble(
                          attribute: offer,
                          isSelected: isSelected,
                          scaleFactor: 1.15,
                          onSelected: (selected) {
                            context
                                .read<OffersCubit>()
                                .toggleInterest(offer);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Custom keyword input
                    TextField(
                      controller: _customKeywordController,
                      decoration: InputDecoration(
                        labelText: l10n.addYourOwnKeywords,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            context
                                .read<OffersCubit>()
                                .addCustomKeyword(
                                _customKeywordController.text.trim());
                            _customKeywordController.clear();
                          },
                        ),
                      ),
                      onSubmitted: (value) {
                        context
                            .read<OffersCubit>()
                            .addCustomKeyword(value);
                        _customKeywordController.clear();
                      },
                    ),
                    const SizedBox(height: 16),
                    // Custom keywords list
                    Wrap(
                      spacing: spacing,
                      runSpacing: runSpacing,
                      children: state.customKeywords.map((keyword) {
                        return Chip(
                          label: Text(keyword),
                          onDeleted: () {
                            context
                                .read<OffersCubit>()
                                .removeCustomKeyword(keyword);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Submit button
                    Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final locale = Localizations.localeOf(context);
                        _offersCubit.submitOffers(locale.languageCode);
                      },
                      child: Text(l10n.continueButton),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
                  ),
                ),
              // Loading overlay when submitting
              if (state.status == OffersStatus.loading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.submittingOffers,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      )
    );
  }

}