import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/interests_screen/cubit/interests_cubit.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user/parsed_attribute_data.dart';
import '../../utils/attribute_style_helper.dart';
import '../../utils/text_utils.dart';

class InterestsScreen extends StatelessWidget {
  bool? isInitialOnboarding = true;
  InterestsScreen({super.key, this.isInitialOnboarding});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InterestsCubit(ApiClient.create(), getIt<UserRepository>()),
      child: InterestsView(isInitialOnboarding: isInitialOnboarding),
    );
  }
}

class InterestsView extends StatefulWidget {
  bool? isInitialOnboarding = true;
  InterestsView({super.key, this.isInitialOnboarding});

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 
                  AppLocalizations.of(context)!.anUnknownErrorOccurred),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        } else if (state.status == InterestsStatus.success) {
          if (this.widget.isInitialOnboarding == false) {
            // Not in onboarding, pop back to caller (UserProfileScreen will handle navigation)
            if (context.canPop()) {
              context.pop();
            }
          } else {
            // Save the full ParsedAttributeData with all metadata
            List<ParsedAttributeData> finalList = List.empty(growable: true);
            state.offersKeyList?.forEach((e) =>
                finalList.add(
                    ParsedAttributeData(uiStyleHint: e.uiStyleHint, relevancyScore: e.relevancyScore,
                        attribute: TextUtils.getTranslatedOrNormalizedAttribute(e.attribute, context)))
            );
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
                body: BlocBuilder<InterestsCubit, InterestsState>(
                  builder: (context, innerState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pre-defined interests
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: state.allInterests.map((interest) {
                              final isSelected =
                              state.selectedInterests.contains(interest);
                              final chipColor = AttributeStyleHelper
                                  .getColorForStyleHint(
                                interest.uiStyleHint,
                                isSelected: isSelected,
                              );
                              final textColor = AttributeStyleHelper
                                  .getTextColor(
                                interest.uiStyleHint,
                                isSelected: isSelected,
                              );

                              return ChoiceChip(
                                label: Text(TextUtils.getTranslatedOrNormalizedAttribute(interest.attribute, context)),
                                selected: isSelected,
                                onSelected: (selected) {
                                  context
                                      .read<InterestsCubit>()
                                      .toggleInterest(interest);
                                },
                                selectedColor: Colors.blue,
                                backgroundColor: chipColor,
                                checkmarkColor: Colors.white,
                                side: BorderSide(
                                  color: AttributeStyleHelper.getBorderColor(
                                      interest.uiStyleHint),
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
                                  TextUtils.getTranslatedOrNormalizedAttribute(_customKeywordController.text, context));
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Submit button - stays at bottom
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final locale = Localizations.localeOf(context);
                        context
                            .read<InterestsCubit>()
                            .submitInterests(locale.languageCode);
                      },
                      child: Text(l10n.save),
                    ),
                  ),
                ],
              ),
            );
          },
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