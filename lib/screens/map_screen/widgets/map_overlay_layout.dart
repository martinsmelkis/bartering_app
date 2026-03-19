// lib/screens/map_screen/widgets/map_overlay_layout.dart
// Stack-based overlay architecture - independent panels that don't rebuild together

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:barter_app/models/map/point_of_interest.dart';
import 'package:barter_app/screens/map_screen/cubit/poi_panel_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/chat_panel_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/settings_panel_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/profile_panel_cubit.dart';
import 'package:barter_app/screens/map_screen/widgets/poi_details_bottom_sheet.dart';
import 'package:barter_app/screens/map_screen/widgets/search_results_list_view.dart';
import 'package:barter_app/screens/user_profile_screen/user_profile_screen.dart';
import 'package:barter_app/screens/settings_screen/settings_screen.dart';
import 'package:barter_app/screens/chat_screen/chat_screen.dart';
import 'package:barter_app/screens/chats_list_screen/chats_list_screen.dart';
import 'package:barter_app/screens/chat_screen/widgets/chat_panel_header.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/screens/user_profile_screen/cubit/nested_panel_cubit.dart';
import 'package:barter_app/screens/notifications_screen/notifications_screen.dart';
import 'package:barter_app/screens/match_history_screen/match_history_screen.dart';
import 'package:barter_app/screens/manage_postings_screen/manage_postings_screen.dart';
import 'package:barter_app/l10n/app_localizations.dart';

/// Stack-based overlay layout for map screen
/// Each panel is an independent overlay that manages its own visibility
/// This prevents nested BlocBuilder cascade rebuilds
/// 
/// Layout structure:
/// - Left side: Profile/Settings panel (when open) - pushes map content right
/// - Center: Map content - shrinks to fit available space between panels
/// - Right side: Search Results + POI/Chat panels (when open) - overlay on top
class MapOverlayLayout extends StatelessWidget {
  final Widget mapContent;

  // Search results state - passed from map screen
  final bool showSearchResultsList;
  final List<PointOfInterest> searchResults;
  final int searchResultsKey;
  final VoidCallback onCloseSearchResults;
  final Function(PointOfInterest) onSearchPoiTap;
  final Function(PointOfInterest) onSearchChatTap;

  const MapOverlayLayout({
    super.key,
    required this.mapContent,
    this.showSearchResultsList = false,
    this.searchResults = const [],
    this.searchResultsKey = 0,
    required this.onCloseSearchResults,
    required this.onSearchPoiTap,
    required this.onSearchChatTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = !ResponsiveBreakpoints.canShowSideBySide(context);
    final hasSearchResults = showSearchResultsList && searchResults.isNotEmpty;
    
    // On small screens with search results, use overlay approach (no right panel in Row)
    // The overlay is rendered in the map content itself
    if (isSmallScreen && hasSearchResults) {
      return Row(
        children: [
          // LEFT SIDE: Map with optional left panel (fills entire width)
          Expanded(
            child: _MainContentWithLeftPanel(
              mapContent: mapContent,
            ),
          ),
          // No right panel - search results are shown as overlay in map content
        ],
      );
    }
    
    return Row(
      children: [
        // LEFT SIDE: Map with optional left panel (Profile/Settings)
        // Map fills remaining space but stops at right panel edge
        Expanded(
          child: _MainContentWithLeftPanel(
            mapContent: mapContent,
          ),
        ),

        // RIGHT SIDE: Search Results + POI/Chat panels
        // Fixed width, always visible when content exists
        _RightPanelsContent(
          showSearchResultsList: showSearchResultsList,
          searchResults: searchResults,
          searchResultsKey: searchResultsKey,
          onCloseSearchResults: onCloseSearchResults,
          onSearchPoiTap: onSearchPoiTap,
          onSearchChatTap: onSearchChatTap,
        ),
      ],
    );
  }
}

/// Main content area with left panel awareness
/// Uses Row layout: [LeftPanel (if open)] | [Map Content (fills remaining)]
/// This ensures the map starts at the right edge of the left panel when open
/// 
/// Also handles nested panels (notifications, match history, postings) that open
/// to the right of the profile panel - expands the left panel area to accommodate them
class _MainContentWithLeftPanel extends StatelessWidget {
  final Widget mapContent;

  const _MainContentWithLeftPanel({
    required this.mapContent,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePanelCubit, ProfilePanelState>(
      buildWhen: (prev, curr) => prev.isOpen != curr.isOpen,
      builder: (context, profileState) {
        return BlocBuilder<SettingsPanelCubit, SettingsPanelState>(
          buildWhen: (prev, curr) => prev.isOpen != curr.isOpen,
          builder: (context, settingsState) {
            return BlocBuilder<NestedPanelCubit, NestedPanelState>(
              buildWhen: (prev, curr) => prev.isOpen != curr.isOpen || prev.panelType != curr.panelType,
              builder: (context, nestedState) {
                final isLeftPanelOpen = profileState.isOpen || settingsState.isOpen;
                final hasNestedPanel = nestedState.isOpen && profileState.isOpen;
                final bothPanelsOpen = profileState.isOpen && settingsState.isOpen;
                
                // Calculate total left panel width:
                // - Keep this in sync with `_ProfilePanelContent` width logic
                //   to avoid reserving extra blank area on the right.
                final baseWidth = context.leftPanelWidth;
                final settingsWidth = context.settingsPanelWidth * 0.6;
                final nestedWidth = (baseWidth * 0.82).clamp(0.0, 400.0);
                const maxProfileWithNestedWidth = 800.0;

                double totalLeftWidth;
                if (bothPanelsOpen) {
                  // Profile + Settings side by side
                  totalLeftWidth = baseWidth + settingsWidth;
                } else if (hasNestedPanel) {
                  // Profile + nested panel (match `_ProfilePanelContent` cap)
                  totalLeftWidth =
                      (baseWidth + nestedWidth).clamp(0.0, maxProfileWithNestedWidth);
                } else if (settingsState.isOpen) {
                  // Settings only
                  totalLeftWidth = settingsWidth;
                } else {
                  // Profile only
                  totalLeftWidth = baseWidth;
                }

                return Row(
                  children: [
                    // Left panel area - expands when nested panel is open or both panels are open
                    if (isLeftPanelOpen)
                      SizedBox(
                        width: totalLeftWidth,
                        child: bothPanelsOpen
                          // Both Profile and Settings open - show side by side
                          ? Row(
                              children: [
                                SizedBox(
                                  width: baseWidth,
                                  child: _ProfilePanelContent(
                                    state: profileState,
                                    nestedState: hasNestedPanel ? nestedState : null,
                                  ),
                                ),
                                SizedBox(
                                  width: settingsWidth,
                                  child: _SettingsPanelContent(state: settingsState),
                                ),
                              ],
                            )
                          : profileState.isOpen
                            ? _ProfilePanelContent(
                                state: profileState,
                                nestedState: hasNestedPanel ? nestedState : null,
                              )
                            : settingsState.isOpen
                              ? _SettingsPanelContent(state: settingsState)
                              : const SizedBox.shrink(),
                      ),
                    // Map content fills remaining space
                    // When panel is open, map starts at right edge of panel
                    // When panel is closed, map fills entire width
                    Expanded(
                      child: mapContent,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Right side panels content (Search Results + POI/Chat)
/// Stacked vertically - Search Results (60%) and POI/Chat (40%)
/// Positioned at right side of screen, overlays on top of map
class _RightPanelsContent extends StatelessWidget {
  final bool showSearchResultsList;
  final List<PointOfInterest> searchResults;
  final int searchResultsKey;
  final VoidCallback onCloseSearchResults;
  final Function(PointOfInterest) onSearchPoiTap;
  final Function(PointOfInterest) onSearchChatTap;

  const _RightPanelsContent({
    required this.showSearchResultsList,
    required this.searchResults,
    required this.searchResultsKey,
    required this.onCloseSearchResults,
    required this.onSearchPoiTap,
    required this.onSearchChatTap,
  });

  @override
  Widget build(BuildContext context) {
    // Check if there's any content to show in the right panel
    final hasSearchResults = showSearchResultsList && searchResults.isNotEmpty;
    
    return BlocBuilder<ChatPanelCubit, ChatPanelState>(
      buildWhen: (prev, curr) => 
          prev.isOpen != curr.isOpen || 
          prev.view != curr.view ||
          prev.selectedPoiId != curr.selectedPoiId,
      builder: (context, chatState) {
        return BlocBuilder<PoiPanelCubit, PoiPanelState>(
          buildWhen: (prev, curr) => 
              prev.isOpen != curr.isOpen ||
              prev.selectedPoi?.profile.userId != curr.selectedPoi?.profile.userId,
          builder: (context, poiState) {
            // Check if POI or Chat panel is actually showing content
            final hasChat = chatState.isOpen;
            final hasPoi = poiState.isOpen && poiState.selectedPoi != null;
            final hasBottomPanel = hasChat || hasPoi;
            
            // Check specific combinations for dynamic flex
            final bothPoiAndChatOpen = hasPoi && hasChat && 
                chatState.selectedPoiId == poiState.selectedPoi?.profile.userId;
            
            // If nothing to show, return empty SizedBox (no width)
            if (!hasSearchResults && !hasBottomPanel) {
              return const SizedBox.shrink();
            }
            
            // Dynamic flex: when both POI and Chat are open, give more space to bottom panel
            // since it needs to accommodate both panels stacked vertically
            final searchFlex = hasSearchResults 
                ? (bothPoiAndChatOpen ? 35 : 50)  // Less space for search when both open
                : 60;
            final bottomFlex = hasSearchResults 
                ? (bothPoiAndChatOpen ? 65 : 50)  // More space for POI+Chat when both open
                : 40;
            
            return SizedBox(
              width: context.rightPanelWidth,
              child: Column(
                children: [
                  // Search Results - takes remaining space
                  Expanded(
                    flex: searchFlex,
                    child: _SearchResultsOverlay(
                      showSearchResultsList: showSearchResultsList,
                      searchResults: searchResults,
                      searchResultsKey: searchResultsKey,
                      onCloseSearchResults: onCloseSearchResults,
                      onSearchPoiTap: onSearchPoiTap,
                      onSearchChatTap: onSearchChatTap,
                    ),
                  ),
                  // POI + Chat Panel - only takes space when content is shown
                  if (hasBottomPanel)
                    Expanded(
                      flex: bottomFlex,
                      child: const _PoiChatPanelOverlay(),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Profile Panel Content - shown on left side with optional nested panel
/// This creates a unified layout without nested Row overflow
class _ProfilePanelContent extends StatelessWidget {
  final ProfilePanelState state;
  final NestedPanelState? nestedState;

  const _ProfilePanelContent({
    required this.state,
    this.nestedState,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasNestedPanel = nestedState?.isOpen == true;
    
    // Calculate widths that fit within the parent container
    // The parent caps total width at 800px, so we need to respect that
    final baseWidth = context.leftPanelWidth;
    final nestedWidth = (baseWidth * 0.82).clamp(0.0, 400.0);
    final maxTotalWidth = 800.0;
    
    // Cap profile width to ensure nested panel fits when open
    final profileWidth = hasNestedPanel
        ? (maxTotalWidth - nestedWidth).clamp(300.0, baseWidth)
        : baseWidth;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile content - fixed width (capped when nested panel is open)
          SizedBox(
            width: profileWidth,
            child: Column(
              children: [
                // Header
                _LeftPanelHeader(
                  title: l10n.profilePanelTitle,
                  onClose: () => context.read<ProfilePanelCubit>().closeProfile(),
                ),
                // Content - takes all remaining space
                Expanded(
                  child: UserProfileScreen(
                    userId: state.userId!,
                    userName: state.userName!,
                    interests: state.interests,
                    offerings: state.offerings,
                    showAppBar: false,
                    skipNestedPanelLayout: true // External layout handles nested panel
                  ),
                ),
              ],
            ),
          ),
          // Nested panel (if open) - to the right of profile
          if (hasNestedPanel)
            _NestedPanelContent(
              nestedState: nestedState!,
              onClose: () => context.read<NestedPanelCubit>().closePanel(),
            ),
        ],
      ),
    );
  }
}

/// Nested panel content for profile panel
class _NestedPanelContent extends StatelessWidget {
  final NestedPanelState nestedState;
  final VoidCallback onClose;

  const _NestedPanelContent({
    required this.nestedState,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Nested panel width - 82% of profile panel width, capped to prevent overflow
    final double baseWidth = context.leftPanelWidth;
    final double nestedWidth = (baseWidth * 0.82).clamp(0.0, 400.0);

    String panelTitle;
    Widget panelContent;

    switch (nestedState.panelType) {
      case NestedPanelType.notifications:
        panelTitle = l10n.notificationPreferences;
        panelContent = const NotificationsScreen(showAppBar: false);
        break;
      case NestedPanelType.matchHistory:
        panelTitle = l10n.matchHistory;
        panelContent = const MatchHistoryScreen(showAppBar: false);
        break;
      case NestedPanelType.managePostings:
        panelTitle = l10n.managePostings;
        panelContent = ManagePostingsScreen(
          userId: nestedState.userId ?? '',
          showAppBar: false,
        );
        break;
      case NestedPanelType.none:
        return const SizedBox.shrink();
    }

    return Container(
      width: nestedWidth,
      color: AppColors.background,
      child: Column(
        children: [
          // Nested panel header
          _NestedPanelHeader(
            title: panelTitle,
            onClose: onClose,
          ),
          // Nested panel content
          Expanded(child: panelContent),
        ],
      ),
    );
  }
}

/// Header for nested panel
class _NestedPanelHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const _NestedPanelHeader({
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 16),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

/// Settings Panel Content - shown on left side
class _SettingsPanelContent extends StatelessWidget {
  final SettingsPanelState state;

  const _SettingsPanelContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _LeftPanelHeader(
            title: l10n.settingsTitle,
            onClose: () => context.read<SettingsPanelCubit>().closeSettings(),
          ),
          // Content - takes all remaining space
          const Expanded(
            child: SettingsScreen(
              showAppBar: false,
            ),
          ),
        ],
      ),
    );
  }
}

/// Search Results Overlay - Shows search results (full height of right panel)
/// Takes full height when POI/chat panel is closed, 60% when open
/// Wrapped with PointerInterceptor to prevent map interactions
class _SearchResultsOverlay extends StatelessWidget {
  final bool showSearchResultsList;
  final List<PointOfInterest> searchResults;
  final int searchResultsKey;
  final VoidCallback onCloseSearchResults;
  final Function(PointOfInterest) onSearchPoiTap;
  final Function(PointOfInterest) onSearchChatTap;

  const _SearchResultsOverlay({
    required this.showSearchResultsList,
    required this.searchResults,
    required this.searchResultsKey,
    required this.onCloseSearchResults,
    required this.onSearchPoiTap,
    required this.onSearchChatTap,
  });

  @override
  Widget build(BuildContext context) {
    // If no search results to show, return empty
    if (!showSearchResultsList || searchResults.isEmpty) {
      return const SizedBox.shrink();
    }

    // Wrap with PointerInterceptor to prevent map interactions when scrolling
    return PointerInterceptor(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(-2, 0),
              ),
            ],
          ),
          child: SearchResultsListView(
            key: ValueKey(searchResultsKey),
            pois: searchResults,
            isLargeScreen: true,
            onClose: onCloseSearchResults,
            onPoiTap: onSearchPoiTap,
            onChatTap: onSearchChatTap,
          ),
        ),
      ),
    );
  }
}

/// POI + Chat Combined Panel Overlay
/// Shows POI details and/or chat in the bottom section
/// When chat opens, it replaces the POI details panel in the same space
class _PoiChatPanelOverlay extends StatelessWidget {
  const _PoiChatPanelOverlay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoiPanelCubit, PoiPanelState>(
      buildWhen: (prev, curr) =>
        prev.isOpen != curr.isOpen ||
        prev.selectedPoi?.profile.userId != curr.selectedPoi?.profile.userId,
      builder: (context, poiState) {
        return BlocBuilder<ChatPanelCubit, ChatPanelState>(
          buildWhen: (prev, curr) =>
            prev.view != curr.view ||
            prev.selectedPoiId != curr.selectedPoiId ||
            prev.isOpen != curr.isOpen,
          builder: (context, chatState) {
            final poi = poiState.selectedPoi;
            final hasPoi = poiState.isOpen && poi != null;
            // hasChat should be true when any chat view is open (list or individual)
            final hasChat = chatState.isOpen;

            // Nothing to show
            if (!hasPoi && !hasChat) {
              return const SizedBox.shrink();
            }

            // Case 1: Both POI and Chat for same user
            // Show them split - POI details on top, chat below (20% bigger than before)
            // Ratio: 70% POI / 48% Chat (118 total for proper flex calculation)
            if (hasPoi && hasChat && chatState.selectedPoiId == poi.profile.userId) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // POI Details - 70% height
                    Expanded(
                      flex: 70,
                      child: PoiDetailsBottomSheet(
                        poi: poi,
                        isLargeScreen: true,
                        onClose: () => context.read<PoiPanelCubit>().closePanel(),
                        onChatButtonPressed: () {}, // Chat already open below
                        showChatButton: false,
                      ),
                    ),
                    // Divider
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    // Chat panel
                    Expanded(
                      flex: 75,
                      child: Column(
                        children: [
                          ChatPanelHeader(
                            chatPoiName: chatState.selectedPoiName,
                            chatPoiId: chatState.selectedPoiId!,
                            onClose: () => context.read<ChatPanelCubit>().closePanel(),
                          ),
                          Expanded(
                            child: ChatScreen(
                              poiId: chatState.selectedPoiId!,
                              poiName: chatState.selectedPoiName,
                              poi: poi,
                              showAppBar: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Case 2: Chat is open but for DIFFERENT user than POI
            // Close the CHAT (for old user) and show only POI details (for new user)
            if (hasPoi && hasChat && chatState.selectedPoiId != poi.profile.userId) {
              // Auto-close chat panel since a different POI was selected
              // This allows the new POI details to be shown
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ChatPanelCubit>().closePanel();
              });

              // Show only POI details for the newly selected user
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: PoiDetailsBottomSheet(
                  poi: poi,
                  isLargeScreen: true,
                  onClose: () => context.read<PoiPanelCubit>().closePanel(),
                  onChatButtonPressed: () {
                    // Open chat for this new POI
                    context.read<ChatPanelCubit>().openChat(
                      poi.profile.userId,
                      poi.profile.name,
                      poi: poi,
                    );
                  },
                ),
              );
            }

            // Case 3: Only POI is open (no chat)
            if (hasPoi) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: PoiDetailsBottomSheet(
                  poi: poi,
                  isLargeScreen: true,
                  onClose: () => context.read<PoiPanelCubit>().closePanel(),
                  onChatButtonPressed: () {
                    context.read<ChatPanelCubit>().openChat(
                      poi.profile.userId,
                      poi.profile.name,
                      poi: poi,
                    );
                  },
                ),
              );
            }

            // Case 4: Only Chat is open (no POI)
            if (hasChat) {
              // Chats List or Individual Chat
              if (chatState.isChatsListOpen) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(-2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _RightPanelHeader(
                        title: AppLocalizations.of(context)!.chats,
                        onClose: () => context.read<ChatPanelCubit>().closePanel(),
                      ),
                      Expanded(
                        child: ChatsListScreen(
                          showAppBar: false,
                          onChatSelected: (selectedPoi) {
                            // Open individual chat
                            context.read<ChatPanelCubit>().openChat(
                              selectedPoi.profile.userId,
                              selectedPoi.profile.name,
                              poi: selectedPoi,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Individual chat (not linked to POI)
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ChatPanelHeader(
                      chatPoiName: chatState.selectedPoiName,
                      chatPoiId: chatState.selectedPoiId!,
                      onClose: () => context.read<ChatPanelCubit>().closePanel(),
                    ),
                    Expanded(
                      child: ChatScreen(
                        poiId: chatState.selectedPoiId!,
                        poiName: chatState.selectedPoiName,
                        poi: chatState.selectedPoi,
                        showAppBar: false,
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

/// Header for left side panels (Profile, Settings)
class _LeftPanelHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const _LeftPanelHeader({
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

/// Header for right side panels (POI, Chat, Chats List)
class _RightPanelHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const _RightPanelHeader({
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
