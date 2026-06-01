import 'dart:async' show unawaited;

import 'package:barter_app/services/device_validation_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

import 'application.dart';
import 'flavor_config.dart';
import 'screens/initialize_screen/initialize_screen.dart';
import 'services/messaging/firebase_service.dart' as local;
import 'utils/debug_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'configure_dependencies.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

// The main entry point of the Flutter application.
void main() async {
  logDebug('🚀🚀🚀 MAIN() STARTED 🚀🚀🚀');
  WidgetsFlutterBinding.ensureInitialized();
  logDebug('✅ WidgetsFlutterBinding initialized');

  // Get flavor from --dart-define=FLAVOR (defaults to dev)
  final flavor = FlavorConfig.flavor;

  // Load environment variables based on flavor
  logDebug('⏳ Loading environment variables from: ${flavor.envFileName}');
  await dotenv.load(fileName: flavor.envFileName);
  logDebug('✅ Environment variables loaded');

  FlutterError.onError = (FlutterErrorDetails details) {
    print('🔴 FLUTTER ERROR: ${details.exception}');
    print('Stack: ${details.stack}');
    FlutterError.presentError(details);
  };

  DeviceValidationResult? deviceValidationResult;
  if (!kDebugMode) {
    deviceValidationResult = await DeviceValidationService.validateDevice();
  }

  // TODO eventually, in release version, run security tests
  //if (!kDebugMode) {
  //  await SecurityTestHelper.runAllTests();
  //}

  logDebug('⏳ Configuring dependencies...');
  await configureDependencies();
  logDebug('✅ Dependencies configured');

  // Initialize Firebase only on non-web platforms
  // Web uses WebSocket-based messaging instead of FCM
  if (!kIsWeb) {
    logDebug('⏳ Initializing Firebase...');
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      logDebug('✅ Firebase initialized in main()');
    } catch (e) {
      logDebug('⚠️ Firebase already initialized (probably by background handler): $e');
    }
  } else {
    logDebug('🔔 Skipping Firebase initialization on web (using WebSocket messaging)');
  }

  logDebug('⏳ Running Application widget...');
  runApp(
    _GuardedApp(
      deviceValidationResult: deviceValidationResult,
    ),
  );
  logDebug('✅ Application widget started');

  // Defer non-critical FCM/service setup until after first frame.
  if (!kIsWeb && deviceValidationResult?.isValid == true) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logDebug('⏳ Initializing FirebaseService after first frame...');
      unawaited(local.FirebaseService().initialize());
    });
  }
}

/// The root widget of the application.
class _GuardedApp extends StatelessWidget {
  final DeviceValidationResult? deviceValidationResult;

  const _GuardedApp({
    required this.deviceValidationResult,
  });

  @override
  Widget build(BuildContext context) {
    final result = deviceValidationResult;

    if (result != null && !result.isValid) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _InvalidDeviceScreen(reason: result.reason),
      );
    }

    return const Application();
  }
}

class _InvalidDeviceScreen extends StatefulWidget {
  final String reason;

  const _InvalidDeviceScreen({required this.reason});

  @override
  State<_InvalidDeviceScreen> createState() => _InvalidDeviceScreenState();
}

class _InvalidDeviceScreenState extends State<_InvalidDeviceScreen> {
  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dialogShown) return;
    _dialogShown = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Device validation failed'),
          content: Text(widget.reason),
          actions: [
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Close app'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(),
    );
  }
}

class BarterApp extends StatelessWidget {
  const BarterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context)?.appTitle ?? 'Bartering App',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Defines the primary color swatch for the app
        useMaterial3: true, // Opt-in for Material 3 design system
      ),
      home: const InitializeScreen(),
    );
  }
}
