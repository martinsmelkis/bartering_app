import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/user_repository.dart';
import '../../services/api_client.dart';
import '../../utils/attribute_style_helper.dart';
import '../../utils/text_utils.dart';
import '../../widgets/responsive_center_container.dart';
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
        // Dismiss any existing dialog first
        //Navigator.of(context).popUntil((route) => route is! PageRoute || route.isFirst);

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
              final spacing = isLargeScreen ? 12.0 : 4.0;
              final runSpacing = isLargeScreen ? 12.0 : 4.0;
              
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info text
                    Center(
                      child: Text(
                        l10n.selectTheOffersThatYouCanProvide,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                          fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) * 1.1,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: const Offset(1, 1),
                              blurRadius: 1,
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
                        final chipColor = AttributeStyleHelper
                            .getColorForStyleHint(
                          offer.uiStyleHint,
                          isSelected: isSelected,
                        );
                        final textColor = AttributeStyleHelper
                            .getTextColor(
                          offer.uiStyleHint,
                          isSelected: isSelected,
                        );

                        return ChoiceChip(
                          label: Text(offer.attribute),
                          selected: isSelected,
                          onSelected: (selected) {
                            context
                                .read<OffersCubit>()
                                .toggleInterest(offer);
                          },
                          selectedColor: Colors.blue,
                          backgroundColor: chipColor,
                          checkmarkColor: Colors.white,
                          side: BorderSide(
                            color: AttributeStyleHelper.getBorderColor(
                                offer.uiStyleHint),
                            width: isSelected ? 2.0 : 1.0,
                          ),
                          labelStyle: TextStyle(
                            color: textColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
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
                                TextUtils.getTranslatedOrNormalizedAttribute(_customKeywordController.text, context));
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
                      spacing: 8.0,
                      runSpacing: 4.0,
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