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
  final PageController _pageController = PageController();
  final Map<String, double> _answers = {};
  int _currentPage = 0;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _categories = _initializeCategories();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
    _loadSavedKeywords();
  }

  Future<void> _loadSavedKeywords() async {
    try {
      final userRepository = getIt<UserRepository>();
      final savedKeywords = await userRepository.getProfileKeywordDataMap();

      if (savedKeywords != null && savedKeywords.isNotEmpty) {
        print('@@@@@@@@@ Loaded saved keywords: $savedKeywords');
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
        print('@@@@@@@@@ No saved keywords found, using defaults');
        setState(() {
          _isLoadingData = false;
        });
      }
    } catch (e) {
      print('@@@@@@@@@ Error loading saved keywords: $e');
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
    _pageController.dispose();
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

    final isLastPage = _currentPage == _categories.length - 1;
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
                    body: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            // Convert stored value (0.0-1.0) to slider range (0-100)
                            final savedValue = _answers[category.titleKey];
                            final sliderValue = savedValue != null
                                ? savedValue * 100
                                : 50.0;

                            return _CategoryPage(
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
                        // --- Page Indicator Dots ---
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _categories.length,
                                  (index) => buildDot(index, context),
                            ),
                          ),
                        ),
                        // --- Next Page Button ---
                        if (!isLastPage)
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(
                                  Icons.arrow_forward_ios, color: AppColors.background),
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                    floatingActionButton: isLastPage
                        ? FloatingActionButton.extended(
                      onPressed: () {
                        print("Onboarding V2 Complete: $_answers");
                        final locale = Localizations.localeOf(context);
                        context.read<OnboardingCubit>().completeOnboarding(
                            locale.languageCode);
                      },
                      label: Text(AppLocalizations.of(context)!.finishOnboarding),
                      icon: const Icon(Icons.check),
                      backgroundColor: AppColors.background,
                    )
                        : null,
                    floatingActionButtonLocation: FloatingActionButtonLocation
                        .endFloat,
                  );
                }
              )
      )
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.background : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// --- Widget for a single page in the PageView ---
class _CategoryPage extends StatefulWidget {
  final OnboardingCategory category;
  final double initialValue;
  final ValueChanged<double> onChanged;

  const _CategoryPage({
    required this.category,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<_CategoryPage> {
  late double _currentValue;
  List<Widget> _backgroundIcons = [];
  bool _iconsInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iconsInitialized) {
      _backgroundIcons = _generateRandomIcons(context);
      _iconsInitialized = true;
    }
  }

  List<Widget> _generateRandomIcons(BuildContext context) {
    final random = Random();
    return List.generate(10, (index) {
      final iconData = widget.category.icons[random.nextInt(widget.category.icons.length)];
      final size = random.nextDouble() * 40 + 20; // Random size between 20 and 60
      final isTop = random.nextBool(); // Place above or below slider

      return Positioned(
        top: isTop ? random.nextDouble() * (MediaQuery.of(context).size.height * 0.3) : null,
        bottom: !isTop ? random.nextDouble() * (MediaQuery.of(context).size.height * 0.3) : null,
        left: random.nextDouble() * (MediaQuery.of(context).size.width - size),
        child: Icon(
          iconData,
          size: size,
          color: AppColors.background.withValues(alpha: 0.5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // A simple way to map key to getter, requires a mapper or manual switch
    final categoryText = _getCategoryText(l10n, widget.category.titleKey);

    return Container(
      color: widget.category.color.withValues(alpha: 0.8),
      child: Stack(
        children: [
          ..._backgroundIcons, // Sprinkle icons in the background
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    categoryText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, color: Colors.grey.shade900, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 40),
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
                  const SizedBox(height: 10),
                  Text(
                    l10n.onboardingScreenQuestion,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade900),
                  )
                ],
              ),
            ),
          ),
        ],
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
