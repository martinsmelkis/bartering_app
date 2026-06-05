import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/interests_screen/cubit/interests_cubit.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user/parsed_attribute_data.dart';
import '../../widgets/responsive_center_container.dart';
import '../../widgets/selectable_attribute_bubble.dart';

class InterestsScreen extends StatelessWidget {
  final bool? isInitialOnboarding;
  InterestsScreen({super.key, this.isInitialOnboarding = true});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InterestsCubit(ApiClient.create(), getIt<UserRepository>()),
      child: InterestsView(isInitialOnboarding: isInitialOnboarding),
    );
  }
}

class InterestsView extends StatefulWidget {
  final bool? isInitialOnboarding;
  InterestsView({super.key, this.isInitialOnboarding = true});

  @override
  State<InterestsView> createState() => _InterestsViewState();
}

class _InterestsViewState extends State<InterestsView> {
  final _customKeywordController = TextEditingController();

  @override
  void dispose() {
    _customKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<InterestsCubit, InterestsState>(
      listener: (context, state) async {
        if (state.status == InterestsStatus.error) {
          // Check if it's the validation error and use localized message
          String errorMessage = state.errorMessage ?? 
              AppLocalizations.of(context)!.anUnknownErrorOccurred;
          
          if (state.errorMessage?.contains('Please select at least one interest') == true) {
            errorMessage = AppLocalizations.of(context)!.pleaseSelectAtLeastOneInterest;
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        } else if (state.status == InterestsStatus.success) {
          if (this.widget.isInitialOnboarding == false) {
            // Not in onboarding, return to previous screen
            logDebug('@@@@@@@@ Interests submitted successfully - returning to previous screen');
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(true);
            } else {
              // Fallback in rare cases where there is no previous route
              context.go('/map');
            }
          } else {
            // Save the full ParsedAttributeData with all metadata
            List<ParsedAttributeData> finalList = List.empty(growable: true);
            state.offersKeyList?.forEach((e) {
                // Use e.attributeKey if available (from API), otherwise derive from e.attribute
                final key = e.effectiveAttributeKey;
                // Use the API-provided display name (e.attribute) as-is for display
                // AttributeBubble will use effectiveAttributeKey for translation lookup
                finalList.add(
                    ParsedAttributeData(
                        attributeKey: key,
                        uiStyleHint: e.uiStyleHint,
                        relevancyScore: e.relevancyScore,
                        attribute: e.attribute, // Use API's localized display name directly
                    )
                );
            });
            context.read<InterestsCubit>().updateOffersList(finalList);
            // In onboarding, continue to offers screen
            context.pushReplacement('/offers');
          }
        }
      },
      child: BlocBuilder<InterestsCubit, InterestsState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text(l10n.selectYourInterests),
                ),
                body: ResponsiveCenterContainer(
                  maxWidth: 700.0,
                  child: BlocBuilder<InterestsCubit, InterestsState>(
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
                                Icons.arrow_downward,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.selectTheInterestsThatMatchYourPreferences,
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
                      children: state.allInterests.map((interest) {
                        final isSelected =
                        state.selectedInterests.contains(interest);

                        return SelectableAttributeBubble(
                          attribute: interest,
                          isSelected: isSelected,
                          scaleFactor: 1.15,
                          onSelected: (selected) {
                            context
                                .read<InterestsCubit>()
                                .toggleInterest(interest);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    // Custom keyword input
                    TextField(
                      controller: _customKeywordController,
                      decoration: InputDecoration(
                        labelText: l10n.addYourOwnKeywords,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            context
                                .read<InterestsCubit>()
                                .addCustomKeyword(
                            _customKeywordController.text.trim());
                            _customKeywordController.clear();
                          },
                        ),
                      ),
                      onSubmitted: (value) {
                        context
                            .read<InterestsCubit>()
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
                                .read<InterestsCubit>()
                                .removeCustomKeyword(keyword);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Submit button
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewPadding.bottom,
                      ),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            final locale = Localizations.localeOf(context);
                            context
                                .read<InterestsCubit>()
                                .submitInterests(locale.languageCode, true);
                          },
                          child: Text(l10n.continueButton),
                        ),
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
              if (state.status == InterestsStatus.loading)
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
                              AppLocalizations.of(context)!.submitting,
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
      ),
    );
  }

}