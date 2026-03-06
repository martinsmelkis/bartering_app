import 'package:flutter/foundation.dart' show kIsWeb;

import 'application.dart';
import 'flavor_config.dart';
import 'screens/initialize_screen/initialize_screen.dart';
import 'services/messaging/firebase_service.dart';
import 'utils/debug_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'configure_dependencies.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'services/security_test_helper.dart';

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
    
    // Initialize Firebase and FCM
    logDebug('⏳ Initializing FirebaseService...');
    await FirebaseService().initialize();
    logDebug('✅ FirebaseService initialized');
  } else {
    logDebug('🔔 Skipping Firebase/FCM initialization on web (using WebSocket messaging)');
  }

  logDebug('⏳ Running Application widget...');
  runApp(const Application());
  logDebug('✅ Application widget started');
}

/// The root widget of the application.
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
