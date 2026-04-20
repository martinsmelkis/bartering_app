import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../utils/debug_utils.dart';
import '../../widgets/responsive_center_container.dart';
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
  bool _cubitInitialized = false;
  late final OnboardingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _categories = _initializeCategories();
    _cubit = getIt<OnboardingCubit>();
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
      OnboardingCategory(titleKey: 'category_blue', color: Colors.blue.shade400, icons: [Icons.business, Icons.euro, Icons.work, Icons.handshake]),
      OnboardingCategory(titleKey: 'category_purple', color: Colors.purple.shade400, icons: [Icons.palette, Icons.self_improvement, Icons.music_note, Icons.book]),
      OnboardingCategory(titleKey: 'category_yellow', color: Colors.yellow.shade700, icons: [Icons.chat, Icons.forum, Icons.alternate_email, Icons.event]),
      OnboardingCategory(titleKey: 'category_orange', color: Colors.orange.shade600, icons: [Icons.volunteer_activism, Icons.healing, Icons.support_agent, Icons.construction]),
      OnboardingCategory(titleKey: 'category_teal', color: Colors.teal.shade400, icons: [Icons.computer, Icons.school, Icons.lightbulb, Icons.biotech]),
    ];
  }

  @override
  void dispose() {
    _cubitInitialized = false;
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

    // Initialize cubit only once to avoid multiple state emissions during rebuilds
    if (!_cubitInitialized) {
      debugPrint('@@@@@@@@@@@ Initializing cubit for the first time');

      // Reset cubit to initial state to ensure clean slate
      debugPrint('@@@@@@@@@@@ Resetting cubit to initial state');
      _cubit.reset();

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
      _cubit.initQuestions(initialQuestions);

      debugPrint('@@@@@@@@@@@ Current cubit state after init: ${_cubit.state.status}');

      _cubitInitialized = true;
    }

    return BlocProvider.value(
        value: _cubit,
        child: BlocConsumer<OnboardingCubit, OnboardingState>(
          bloc: _cubit,
          listenWhen: (previous, current) {
            final shouldListen = previous.status != current.status;
            debugPrint('@@@@@@@@@@@ BlocConsumer listenWhen called!');
            debugPrint('@@@@@@@@@@@ Previous: ${previous.status}, Current: ${current.status}, Should listen: $shouldListen');
            return shouldListen;
          },
          buildWhen: (previous, current) {
            debugPrint('@@@@@@@@@@@ BlocConsumer buildWhen - previous: ${previous.status}, current: ${current.status}');
            return previous.status != current.status || previous.questions != current.questions;
          },
          listener: (context, state) {
            debugPrint('@@@@@@@@@@@ OnboardingScreen BlocConsumer listener - Status: ${state.status}');
            if (state.status == OnboardingStatus.error) {
              debugPrint('@@@@@@@@@@@ Handling error status');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ??
                      AppLocalizations.of(context)!.anUnknownErrorOccurred),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 5),
                ),
              );
            } else if (state.status == OnboardingStatus.success) {
              debugPrint('@@@@@@@@@@@ Handling success status');
              // Save the full ParsedAttributeData with all metadata
              List<ParsedAttributeData> finalList = List.empty(growable: true);
              state.interestsKeyList?.forEach((e) {
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
              context.read<OnboardingCubit>().updateInterestsList(finalList);

              // Use a post-frame callback to ensure clean navigation
              WidgetsBinding.instance.addPostFrameCallback((_) {
                debugPrint('@@@@@@@@@@@ Post-frame callback executing');
                if (context.mounted) {
                  if (widget.isInitialOnboarding == true) {
                    debugPrint('@@@@@@@@@@@ Navigating to InterestsScreen');
                    // Initial onboarding: navigate to interests screen using go_router
                    context.pushReplacement('/interests');
                  } else {
                    debugPrint('@@@@@@@@@@@ Editing mode - popping back to caller');
                    // Editing mode: pop back to previous screen (works for both mobile and web)
                    // On web, this returns to the profile panel on map screen
                    // On mobile, this returns to the profile screen
                    context.pop();
                  }
                } else {
                  debugPrint('@@@@@@@@@@@ Context not mounted, cannot navigate');
                }
              });
            }
          },
          builder: (context, state) {
            debugPrint('@@@@@@@@@@@ BlocConsumer builder called - Status: ${state.status}');
            return Stack(
              children: [
                Scaffold(
                  body: SafeArea(
                    child: ResponsiveCenterContainer(
                      maxWidth: 700.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title section
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
                            child: Text(
                              l10n!.shareYourInterestsToFindBestMatches,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange.shade600,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    color: Colors.white70,
                                    offset: const Offset(1.5, 1.5),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Category cards
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 60.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: _categories.asMap().entries.map((entry) {
                                final index = entry.key;
                                final category = entry.value;
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
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Loading overlay when submitting
                if (state.status == OnboardingStatus.submitting)
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    top: false,
                    minimum: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 200.w,
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
                  ),
                ),
              ],
            );
          },
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
          padding: const EdgeInsets.all(16.0),
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
