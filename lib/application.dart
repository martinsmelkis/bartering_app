import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:barter_app/router/app_router.dart';
import 'package:barter_app/screens/chat_screen/cubit/chat_cubit.dart';
import 'package:barter_app/screens/chats_list_screen/cubit/chats_badge_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/chat_panel_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/poi_panel_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/settings_panel_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/profile_panel_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/map_operations_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/map_screen_api_cubit.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/screens/user_profile_screen/cubit/nested_panel_cubit.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/messaging/chat_notification_service.dart';
import 'package:barter_app/services/messaging/firebase_service.dart';
import 'package:barter_app/services/settings_service.dart';
import 'package:barter_app/theme/app_theme.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../l10n/app_localizations.dart';
import 'configure_dependencies.dart';

// Global ValueNotifier for locale changes
final localeNotifier = ValueNotifier<Locale?>(null);

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> with WidgetsBindingObserver {
  ChatNotificationService? _chatNotificationService;
  late ChatsBadgeCubit _chatsBadgeCubit;

  // It is assumed that all messages contain a data field with the key 'type'
  setupInteractedMessage() async {
    // Skip FCM message setup on web - uses WebSocket instead
    if (kIsWeb) {
      logDebug('🔔 Skipping FCM message handlers on web (using WebSocket messaging)');
      return;
    }

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background using a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'new_message') {
      AppRouter.navigateToChat(message.data['senderId']);
    }
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
    _loadSavedLocale();
    
    // Listen to locale changes
    localeNotifier.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() {
    if (mounted) {
      setState(() {
        // Trigger rebuild when locale changes
      });
    }
  }

  Future<void> _loadSavedLocale() async {
    final settingsService = getIt<SettingsService>();
    final languageCode = await settingsService.getPreferredLanguage();
    
    if (languageCode != null && languageCode.isNotEmpty) {
      localeNotifier.value = Locale(languageCode);
      logDebug('Loaded saved locale: $languageCode');
    }
  }

  /// Navigate to chat screen with specific user using go_router
  void _navigateToChat(String userId) {
    logDebug('🔔 Navigating to chat with user: $userId');
    AppRouter.navigateToChat(userId);
  }

  _initializeServices() async {
    // Skip chat notification service initialization on web
    // Web uses WebSocket-based messaging instead of local notifications
    if (kIsWeb) {
      logDebug('🔔 Skipping chat notification service on web (using WebSocket messaging)');
      return;
    }

    // Initialize chat notification service
    try {
      _chatNotificationService = getIt<ChatNotificationService>();
      await _chatNotificationService!.initialize();

      // Set up navigation handler for notification taps
      _chatNotificationService!.onNotificationTap = (userId) {
        _navigateToChat(userId);
      };

      logDebug('✅ Chat notification service initialized');
    } catch (e) {
      logDebugError('Failed to initialize chat notification service', e);
    }
  }

  @override
  void dispose() {
    localeNotifier.removeListener(_onLocaleChanged);
    WidgetsBinding.instance.removeObserver(this);
    _chatNotificationService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ApiClient poiApiService = ApiClient.create();

    return MultiBlocProvider(
      providers: [
        BlocProvider<PoiCubit>(
          create: (context) => PoiCubit(poiApiService),
        ),
        BlocProvider<MapOperationsCubit>(
          create: (context) => MapOperationsCubit(),
        ),
        BlocProvider<ChatCubit>(
          create: (context) {
            return ChatCubit(
                currentUserId: '',
                currentUserName: '',
                recipientUserId: '');
          },
        ),
        BlocProvider<ChatPanelCubit>(
          create: (context) => ChatPanelCubit(),
        ),
        BlocProvider<PoiPanelCubit>(
          create: (context) => PoiPanelCubit(),
        ),
        BlocProvider<SettingsPanelCubit>(
          create: (context) => SettingsPanelCubit(),
        ),
        BlocProvider<ProfilePanelCubit>(
          create: (context) => ProfilePanelCubit(),
        ),
        BlocProvider<NestedPanelCubit>(
          create: (context) => NestedPanelCubit(),
        ),
        BlocProvider<ChatsBadgeCubit>(
          create: (context) {
            _chatsBadgeCubit = ChatsBadgeCubit();
            // Register with FirebaseService for FCM updates
            if (!kIsWeb) {
              FirebaseService().setChatsBadgeCubit(_chatsBadgeCubit);
            }
            return _chatsBadgeCubit;
          },
        ),
        BlocProvider<NotificationsCubit>(
          create: (context) => getIt<NotificationsCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
              routerConfig: AppRouter.router,
              title: 'Barter App',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              locale: localeNotifier.value,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, materialAppChild) {
                // Use LayoutBuilder to avoid MediaQuery dependency storm on resize
                return LayoutBuilder(
                  builder: (context, constraints) {
                    // Get responsive text scale factor based on device width
                    final screenWidth = constraints.maxWidth;
                    double textScaleFactor = 1.0;

                    if (screenWidth >= 1600) {
                      textScaleFactor = 1.2; // 20% larger for ultra-wide
                    } else if (screenWidth >= 1200) {
                      textScaleFactor = 1.15; // 15% larger for desktops
                    } else if (screenWidth >= 840) {
                      textScaleFactor = 1.1; // 10% larger for tablets in landscape
                    } else if (screenWidth >= 600) {
                      textScaleFactor = 1.05; // 5% larger for tablets in portrait
                    } else {
                      textScaleFactor = 1.0; // Normal size for phones
                    }

                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(textScaleFactor)),
                      child: materialAppChild!,
                    );
                  },
                );
              }
          );
        },
      ),
    );
  }

}
