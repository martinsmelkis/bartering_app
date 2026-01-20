import 'dart:math';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/map_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../utils/text_utils.dart';
import '../../utils/debug_utils.dart';
import '../../widgets/dialogs/error_dialog.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../interests_screen/interests_screen.dart';
import 'cubit/onboarding_cubit.dart';

// --- Data Models for the new Onboarding Screen ---

class OnboardingCategory {
  final String titleKey; // The key for the localization string
  final Color color;
  final List<IconData> icons;

  const OnboardingCategory({
    required this.titleKey,
    required this.color,
    required this.icons,
  });
}

// --- Main Screen Widget ---

class OnboardingScreen extends StatefulWidget {
  bool? isInitialOnboarding = true;
  OnboardingScreen({super.key, this.isInitialOnboarding});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final List<OnboardingCategory> _categories;
  final Map<String, double> _answers = {};
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _categories = _initializeCategories();
    _loadSavedKeywords();
  }

  Future<void> _loadSavedKeywords() async {
    try {
      final userRepository = getIt<UserRepository>();
      final savedKeywords = await userRepository.getProfileKeywordDataMap();

      if (savedKeywords != null && savedKeywords.isNotEmpty) {
        logDebug('@@@@@@@@@ Loaded saved keywords: $savedKeywords');
        setState(() {
          var idx = 0;
          // Convert saved values (0.0-1.0) to slider range (0-100) and store in _answers
          for (var entry in savedKeywords.entries) {
            var key = _categories[idx].titleKey;
            _answers[key] = entry.value;
            idx++;
          }
          _isLoadingData = false;
        });
      } else {
        logDebug('@@@@@@@@@ No saved keywords found, using defaults');
        setState(() {
          _isLoadingData = false;
        });
      }
    } catch (e) {
      logDebugError('Error loading saved keywords', e);
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  List<OnboardingCategory> _initializeCategories() {
    return [
      OnboardingCategory(titleKey: 'category_green', color: Colors.green.shade400, icons: [Icons.eco, Icons.park, Icons.pets, Icons.forest]),
      OnboardingCategory(titleKey: 'category_red', color: Colors.red.shade400, icons: [Icons.sports_soccer, Icons.directions_run, Icons.party_mode, Icons.build]),
      OnboardingCategory(titleKey: 'category_blue', color: Colors.blue.shade400, icons: [Icons.business, Icons.attach_money, Icons.work, Icons.handshake]),
      OnboardingCategory(titleKey: 'category_purple', color: Colors.purple.shade400, icons: [Icons.palette, Icons.self_improvement, Icons.music_note, Icons.book]),
      OnboardingCategory(titleKey: 'category_yellow', color: Colors.yellow.shade700, icons: [Icons.chat, Icons.forum, Icons.alternate_email, Icons.event]),
      OnboardingCategory(titleKey: 'category_orange', color: Colors.orange.shade600, icons: [Icons.volunteer_activism, Icons.healing, Icons.support_agent, Icons.construction]),
      OnboardingCategory(titleKey: 'category_teal', color: Colors.teal.shade400, icons: [Icons.computer, Icons.school, Icons.lightbulb, Icons.biotech]),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) {
        final cubit = getIt<OnboardingCubit>();
        final List<OnboardingQuestion> initialQuestions = [
          OnboardingQuestion(
            id: 2,
            text: l10n!.category_green,
            answer: _answers['category_green'] ?? 0.5,
          ),
          OnboardingQuestion(
            id: 3,
            text: l10n.category_red,
            answer: _answers['category_red'] ?? 0.5,
          ),
          OnboardingQuestion(
            id: 4,
            text: l10n.category_blue,
            answer: _answers['category_blue'] ?? 0.5,
          ),
          OnboardingQuestion(
            id: 5,
            text: l10n.category_purple,
            answer: _answers['category_purple'] ?? 0.5,
          ),
          OnboardingQuestion(
            id: 1,
            text: l10n.category_yellow,
            answer: _answers['category_yellow'] ?? 0.5,
          ),
          OnboardingQuestion(
            id: 6,
            text: l10n.category_orange,
            answer: _answers['category_orange'] ?? 0.5,
          ),
          OnboardingQuestion(
            id: 7,
            text: l10n.category_teal,
            answer: _answers['category_teal'] ?? 0.5,
          ),
        ];
        cubit.initQuestions(initialQuestions);
        return cubit;
      },
      child: BlocListener<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state.status == OnboardingStatus.submitting) {
              // Dismiss any existing dialog first
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).popUntil((route) =>
                route.settings.name != null || route.isFirst);
              }
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return ProgressDialog(
                      message: AppLocalizations.of(context)!.submitting);
                },
              );
            } else if (state.status == OnboardingStatus.error) {
              // Dismiss progress dialog
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    title: AppLocalizations.of(context)!.error,
                    content: state.errorMessage ??
                        AppLocalizations.of(context)!.anUnknownErrorOccurred,
                  );
                },
              );
            } else if (state.status == OnboardingStatus.success) {
              // Save the full ParsedAttributeData with all metadata
              List<ParsedAttributeData> finalList = List.empty(growable: true);
              state.interestsKeyList?.forEach((e) =>
                  finalList.add(
                      ParsedAttributeData(uiStyleHint: e.uiStyleHint,
                          relevancyScore: e.relevancyScore,
                          attribute: TextUtils
                              .getTranslatedOrNormalizedAttribute(
                              e.attribute, context)))
              );
              context.read<OnboardingCubit>().updateInterestsList(finalList);

              // Use a post-frame callback to ensure dialog is dismissed before navigation
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) =>
                      widget.isInitialOnboarding == true ? InterestsScreen()
                          : MapScreenV2()),
                  );
                }
              });
            }
          },
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return Scaffold(
                    body: SafeArea(
                      child: Column(
                        children: [
                          // Title section
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
                            child: Text(
                              'Share your interests to find the best matches with others!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.orange.shade900,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Colors.orange.shade200,
                                    offset: const Offset(1.5, 1.5),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                final category = _categories[index];
                                // Convert stored value (0.0-1.0) to slider range (0-100)
                                final savedValue = _answers[category.titleKey];
                                final sliderValue = savedValue != null
                                    ? savedValue * 100
                                    : 50.0;

                                return _CategoryCard(
                                  category: category,
                                  initialValue: sliderValue,
                                  onChanged: (value) {
                                    setState(() {
                                      state.questions[index].answer = value / 100;
                                      _answers[category.titleKey] = value / 100;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  logDebug("Onboarding V2 Complete: $_answers");
                                  final locale = Localizations.localeOf(context);
                                  context.read<OnboardingCubit>().completeOnboarding(
                                      locale.languageCode);
                                },
                                icon: const Icon(Icons.check),
                                label: Text(AppLocalizations.of(context)!.finishOnboarding),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              )
      )
    );
  }

}

// --- Widget for a single category card in the ListView ---
class _CategoryCard extends StatefulWidget {
  final OnboardingCategory category;
  final double initialValue;
  final ValueChanged<double> onChanged;

  const _CategoryCard({
    required this.category,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categoryText = _getCategoryText(l10n, widget.category.titleKey);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: widget.category.color.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category icons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.category.icons.map((icon) {
                  return Icon(
                    icon,
                    size: 25.6, // 32 * 0.8 = 25.6
                    color: Colors.white.withValues(alpha: 0.9),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Category title
              Text(
                categoryText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              // Slider
              Slider(
                value: _currentValue,
                min: 0,
                max: 100,
                divisions: 100,
                label: _currentValue.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _currentValue = value;
                  });
                  widget.onChanged(value);
                },
                activeColor: AppColors.background,
                inactiveColor: AppColors.background.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryText(AppLocalizations l10n, String key) {
    switch (key) {
      case 'category_green':
        return l10n.category_green;
      case 'category_red':
        return l10n.category_red;
      case 'category_blue':
        return l10n.category_blue;
      case 'category_purple':
        return l10n.category_purple;
      case 'category_yellow':
        return l10n.category_yellow;
      case 'category_orange':
        return l10n.category_orange;
      case 'category_teal':
        return l10n.category_teal;
      default:
        return '';
    }
  }
}
