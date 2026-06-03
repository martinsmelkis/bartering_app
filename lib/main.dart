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
    logDebug('🔴 FLUTTER ERROR: ${details.exception}');
    logDebug('Stack: ${details.stack}');
    FlutterError.presentError(details);
  };

  // Paint an immediate first frame before any release-only checks, DI, crypto,
  // database, or Firebase work. This prevents App Review from seeing a blank
  // native launch screen if a startup task is slow or fails.
  runApp(const _LaunchBootstrapApp());

  DeviceValidationResult? deviceValidationResult;
  if (!kDebugMode) {
    // Do not let local device heuristics block the first Flutter frame. App
    // Review often runs on brand-new hardware/OS builds before plugins fully
    // recognize them; a validation exception here would otherwise look like a
    // blank launch screen.
    try {
      deviceValidationResult = await DeviceValidationService.validateDevice()
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      logDebug('⚠️ Device validation skipped during launch: $e');
      deviceValidationResult = const DeviceValidationResult(
        isValid: true,
        isPhysicalDevice: true,
        suspicionScore: 0,
        reason: 'Device validation timed out during launch',
        details: {'validationSkipped': true},
      );
    }
  }

  // TODO eventually, in release version, run security tests
  //if (!kDebugMode) {
  //  await SecurityTestHelper.runAllTests();
  //}

  logDebug('⏳ Configuring dependencies...');
  try {
    await configureDependencies().timeout(const Duration(seconds: 12));
    logDebug('✅ Dependencies configured');
  } catch (e, stackTrace) {
    logDebugError('Failed to configure dependencies during launch', e);
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: e,
        stack: stackTrace,
        library: 'app startup',
        context: ErrorDescription('while configuring dependencies'),
      ),
    );
    runApp(_StartupErrorApp(errorMessage: e.toString()));
    return;
  }

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
      logDebug(
        '⚠️ Firebase already initialized (probably by background handler): $e',
      );
    }
  } else {
    logDebug(
      '🔔 Skipping Firebase initialization on web (using WebSocket messaging)',
    );
  }

  logDebug('⏳ Running Application widget...');
  runApp(_GuardedApp(deviceValidationResult: deviceValidationResult));
  logDebug('✅ Application widget started');

  // Defer non-critical FCM/service setup until after first frame.
  if (!kIsWeb && deviceValidationResult?.isValid == true) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logDebug('⏳ Initializing FirebaseService after first frame...');
      unawaited(local.FirebaseService().initialize());
    });
  }
}

class _LaunchBootstrapApp extends StatelessWidget {
  const _LaunchBootstrapApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _StartupErrorApp extends StatelessWidget {
  final String errorMessage;

  const _StartupErrorApp({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'We could not start the app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The root widget of the application.
class _GuardedApp extends StatelessWidget {
  final DeviceValidationResult? deviceValidationResult;

  const _GuardedApp({required this.deviceValidationResult});

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Unable to start app on this device',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.reason,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
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
        primarySwatch:
            Colors.orange, // Defines the primary color swatch for the app
        useMaterial3: true, // Opt-in for Material 3 design system
      ),
      home: const InitializeScreen(),
    );
  }
}
