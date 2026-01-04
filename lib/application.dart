import 'package:barter_app/router/app_router.dart';
import 'package:barter_app/screens/chat_screen/cubit/chat_cubit.dart';
import 'package:barter_app/screens/chats_list_screen/cubit/chats_badge_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/chat_panel_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/map_operations_cubit.dart';
import 'package:barter_app/screens/map_screen/cubit/map_screen_api_cubit.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/chat_notification_service.dart';
import 'package:barter_app/services/firebase_service.dart';
import 'package:barter_app/theme/app_theme.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../l10n/app_localizations.dart';
import 'configure_dependencies.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> with WidgetsBindingObserver {
  ChatNotificationService? _chatNotificationService;
  late ChatsBadgeCubit _chatsBadgeCubit;

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
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
  }

  /// Navigate to chat screen with specific user using go_router
  void _navigateToChat(String userId) {
    print('🔔 Navigating to chat with user: $userId');
    AppRouter.navigateToChat(userId);
  }

  Future<void> _initializeServices() async {
    // Initialize chat notification service
    try {
      _chatNotificationService = getIt<ChatNotificationService>();
      await _chatNotificationService!.initialize();

      // Set up navigation handler for notification taps
      _chatNotificationService!.onNotificationTap = (userId) {
        _navigateToChat(userId);
      };

      print('✅ Chat notification service initialized');
    } catch (e) {
      print('❌ Failed to initialize chat notification service: $e');
    }
  }

  @override
  void dispose() {
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
                recipientUserId: '');
          },
        ),
        BlocProvider<ChatPanelCubit>(
          create: (context) => ChatPanelCubit(),
        ),
        BlocProvider<ChatsBadgeCubit>(
          create: (context) {
            _chatsBadgeCubit = ChatsBadgeCubit();
            // Register with FirebaseService for FCM updates
            FirebaseService().setChatsBadgeCubit(_chatsBadgeCubit);
            return _chatsBadgeCubit;
          },
        ),
        BlocProvider<NotificationsCubit>(
          create: (context) => getIt<NotificationsCubit>()..loadMatchHistory(),
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
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, materialAppChild) {
                // Get responsive text scale factor based on device size
                final deviceSize = ResponsiveBreakpoints.getDeviceSize(context);
                double textScaleFactor = 1.0;

                switch (deviceSize) {
                  case DeviceSize.compact:
                    textScaleFactor = 1.0; // Normal size for phones
                    break;
                  case DeviceSize.medium:
                    textScaleFactor = 1.05; // 5% larger for tablets in portrait
                    break;
                  case DeviceSize.expanded:
                    textScaleFactor =
                    1.1; // 10% larger for tablets in landscape
                    break;
                  case DeviceSize.large:
                    textScaleFactor = 1.15; // 15% larger for desktops
                    break;
                  case DeviceSize.extraLarge:
                    textScaleFactor = 1.2; // 20% larger for ultra-wide
                    break;
                }

                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(textScaleFactor)),
                  child: materialAppChild!,
                );
              }
          );
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {

    } else if (state == AppLifecycleState.paused) {

    }
  }

}