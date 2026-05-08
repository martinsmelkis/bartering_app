import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/settings_service.dart';
import 'package:barter_app/widgets/selectable_attribute_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '../../../configure_dependencies.dart';
import '../cubit/map_screen_api_cubit.dart';

/// A horizontally scrollable list of selectable attribute bubbles
/// showing cached interest and offering suggestion keywords.
/// Placed under the search textfield on the map screen.
class SuggestionKeywordsList extends StatefulWidget {
  final PoiCubit poiCubit;
  final double horizontalPadding;

  const SuggestionKeywordsList({
    super.key,
    required this.poiCubit,
    this.horizontalPadding = 16.0,
  });

  @override
  State<SuggestionKeywordsList> createState() => _SuggestionKeywordsListState();
}

class _SuggestionKeywordsListState extends State<SuggestionKeywordsList> {
  final UserRepository _userRepository = getIt<UserRepository>();
  List<ParsedAttributeData> _suggestions = [];
  Set<String> _selectedAttributes = {};
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSuggestions() async {
    try {
      // First, try to get server-suggested keywords (from AI matching)
      final suggestedInterests = await _userRepository.getSuggestedInterests();
      final suggestedOfferings = await _userRepository.getSuggestedOfferings();

      if ((suggestedInterests != null && suggestedInterests.isNotEmpty) ||
          (suggestedOfferings != null && suggestedOfferings.isNotEmpty)) {
        // Use server-suggested keywords (from AI matching)
        final allSuggestions = <ParsedAttributeData>[];
        if (suggestedInterests != null) {
          allSuggestions.addAll(suggestedInterests.take(15));
        }
        if (suggestedOfferings != null) {
          allSuggestions.addAll(suggestedOfferings.take(15));
        }

        // Remove duplicates by attribute key and take top 10
        final uniqueSuggestions = <String, ParsedAttributeData>{};
        for (final attr in allSuggestions) {
          final key = attr.effectiveAttributeKey;
          if (!uniqueSuggestions.containsKey(key)) {
            uniqueSuggestions[key] = attr;
          }
        }

        setState(() {
          _suggestions = uniqueSuggestions.values.take(30).toList();
          _isLoading = false;
        });
        return;
      }

      // Fallback: Get user's own interests and offerings from storage
      final interests = await _userRepository.getInterests(loadFromStorage: true);
      final offerings = await _userRepository.getOfferings(loadFromStorage: true);

      // Combine and limit to top suggestions
      final allAttributes = <ParsedAttributeData>[];
      
      if (interests != null) {
        allAttributes.addAll(interests.take(15));
      }
      if (offerings != null) {
        allAttributes.addAll(offerings.take(15));
      }

      // Remove duplicates by attribute key and take top 10
      final uniqueAttributes = <String, ParsedAttributeData>{};
      for (final attr in allAttributes) {
        final key = attr.effectiveAttributeKey;
        if (!uniqueAttributes.containsKey(key)) {
          uniqueAttributes[key] = attr;
        }
      }

      setState(() {
        _suggestions = uniqueAttributes.values.take(30).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
    }
  }

  void _onAttributeSelected(String attributeKey, bool selected) async {
    setState(() {
      if (selected) {
        // Unselect all other attributes - only one can be selected at a time
        _selectedAttributes.clear();
        _selectedAttributes.add(attributeKey);
      } else {
        _selectedAttributes.remove(attributeKey);
      }
    });

    // Perform keyword search when an attribute is selected
    // Run without await to prevent blocking the selection animation
    if (selected) {
      _performKeywordSearch(attributeKey);
    }
  }

  Future<void> _performKeywordSearch(String keyword) async {
    // Defer all heavy work until after the current frame renders
    // This prevents the animation from freezing
    await Future.delayed(Duration.zero);
    
    if (!mounted) return;
    
    try {
      // Get search settings from the cubit or use defaults
      final settingsService = getIt<SettingsService>();
      final radiusKm = await settingsService.getKeywordSearchRadius();
      final weight = await settingsService.getKeywordSearchWeight();

      if (!mounted) return;
      
      // Call the keyword search API via the poiCubit
      await widget.poiCubit.getProfilesByKeyword(
        keyword,
        radiusMeters: radiusKm * 1000, // Convert km to meters
        weight: weight,
      );
    } catch (e) {
      // Error handling - the cubit will emit error state
      debugPrint('Error performing keyword search: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    if (_suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return PointerInterceptor(
      child: Container(
        height: 58,
        color: Colors.transparent,
        child: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              // Handle mouse wheel scrolling
              final scrollDelta = event.scrollDelta.dy;
              // Manually scroll the list view
              final currentOffset = _scrollController.offset;
              final newOffset = (currentOffset + scrollDelta).clamp(
                0.0,
                _scrollController.position.maxScrollExtent,
              );
              _scrollController.jumpTo(newOffset);
            }
          },
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding, vertical: 8),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _suggestions[index];
              final isSelected = _selectedAttributes.contains(suggestion.effectiveAttributeKey);

              return Padding(
                padding: EdgeInsets.only(right: kIsWeb ? 4 : 8),
                child: SelectableAttributeBubble(
                  attribute: suggestion,
                  isSelected: isSelected,
                  onSelected: (selected) => _onAttributeSelected(
                    suggestion.effectiveAttributeKey,
                    selected,
                  ),
                  scaleFactor: kIsWeb ? 1.1 : 1.05,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
