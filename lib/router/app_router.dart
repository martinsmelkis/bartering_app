import 'package:barter_app/screens/chat_screen/chat_screen.dart';
import 'package:barter_app/screens/chats_list_screen/chats_list_screen.dart';
import 'package:barter_app/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:barter_app/screens/initialize_screen/initialize_screen.dart';
import 'package:barter_app/screens/interests_screen/interests_screen.dart';
import 'package:barter_app/screens/map_screen/map_screen.dart';
import 'package:barter_app/screens/match_history_screen/match_history_screen.dart';
import 'package:barter_app/screens/notifications_screen/notifications_screen.dart';
import 'package:barter_app/screens/offers_screen/offers_screen.dart';
import 'package:barter_app/screens/onboarding_screen/onboarding_screen.dart';
import 'package:barter_app/screens/pin_input_screen/pin_verification_screen.dart';
import 'package:barter_app/screens/settings_screen/settings_screen.dart';
import 'package:barter_app/screens/user_profile_screen/create_posting_screen.dart';
import 'package:barter_app/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Global key for accessing the router from anywhere
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// App router configuration using go_router
class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/initialize',
    routes: [
      // Initialize/Splash Screen
      GoRoute(
        path: '/initialize',
        name: 'initialize',
        builder: (context, state) => const InitializeScreen(),
      ),

      // Welcome Screen
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Onboarding Screen
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) {
          final isInitial = state.uri.queryParameters['isInitialOnboarding'] == 'true';
          return OnboardingScreen(isInitialOnboarding: isInitial);
        },
      ),

      // Forgot Password Screen
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),

      // PIN Verification Screen
      GoRoute(
        path: '/verify-pin',
        name: 'verify-pin',
        builder: (context, state) => const PinVerificationScreen(),
      ),

      // Interests Screen
      GoRoute(
        path: '/interests',
        name: 'interests',
        builder: (context, state) => InterestsScreen(),
      ),

      // Offers Screen
      GoRoute(
        path: '/offers',
        name: 'offers',
        builder: (context, state) => OffersScreen(),
      ),

      // Map Screen (Main Screen)
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) => const MapScreenV2(),
      ),

      // Home (redirect to map)
      GoRoute(
        path: '/',
        name: 'home',
        redirect: (context, state) => '/map',
      ),

      // Chat Screen with specific user
      GoRoute(
        path: '/chat/:userId',
        name: 'chat',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return ChatScreen(poiId: userId);
        },
      ),

      // Chats List Screen
      GoRoute(
        path: '/chats',
        name: 'chats',
        builder: (context, state) => const ChatsListScreen(
          showAppBar: true,
        ),
      ),

      // Create Posting Screen
      GoRoute(
        path: '/create-posting',
        name: 'create-posting',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CreatePostingScreen(
            isOffer: extra?['isOffer'],
            existingPosting: extra?['existingPosting'],
          );
        },
      ),

      // Manage Postings Screen (requires userId - redirect to map for now)
      GoRoute(
        path: '/manage-postings',
        name: 'manage-postings',
        redirect: (context, state) => '/map',
      ),

      // Match History Screen
      GoRoute(
        path: '/match-history',
        name: 'match-history',
        builder: (context, state) => const MatchHistoryScreen(),
      ),

      // Match Details Screen (with specific match ID)
      // For now, redirect to match history - can be enhanced later
      GoRoute(
        path: '/match/:matchId',
        name: 'match-details',
        redirect: (context, state) => '/match-history',
      ),

      // Posting Details Screen (with specific posting ID)
      // For now, redirect to map - can be enhanced later
      GoRoute(
        path: '/posting/:postingId',
        name: 'posting-details',
        redirect: (context, state) => '/map',
      ),

      // Notifications Screen
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Settings Screen
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/map'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );

  /// Check if router is ready (has a location)
  static bool get isReady {
    try {
      final location = router.routerDelegate.currentConfiguration.uri.toString();
      return location.isNotEmpty && location != '/initialize';
    } catch (e) {
      return false;
    }
  }

  /// Navigate to chat with specific user
  static void navigateToChat(String userId) {
    print('🧭 AppRouter.navigateToChat called for userId: $userId');
    print('🧭 Current router location: ${router.routerDelegate.currentConfiguration.uri}');
    router.go('/chat/$userId');
  }

  /// Navigate to match details
  static void navigateToMatch(String matchId) {
    print('🧭 AppRouter.navigateToMatch called for matchId: $matchId');
    print('🧭 Current router location: ${router.routerDelegate.currentConfiguration.uri}');
    router.go('/match/$matchId');
  }

  /// Navigate to posting details
  static void navigateToPosting(String postingId) {
    print('🧭 AppRouter.navigateToPosting called for postingId: $postingId');
    print('🧭 Current router location: ${router.routerDelegate.currentConfiguration.uri}');
    router.go('/posting/$postingId');
  }

  /// Navigate to home/map
  static void navigateToHome() {
    print('🧭 AppRouter.navigateToHome called');
    print('🧭 Current router location: ${router.routerDelegate.currentConfiguration.uri}');
    router.go('/map');
  }

  /// Navigate to notifications
  static void navigateToNotifications() {
    router.go('/notifications');
  }

  /// Navigate to chats list
  static void navigateToChats() {
    router.go('/chats');
  }

  /// Navigate to settings
  static void navigateToSettings() {
    router.go('/settings');
  }
}
