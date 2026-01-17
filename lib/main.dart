import 'package:barter_app/application.dart';
import 'package:barter_app/screens/initialize_screen/initialize_screen.dart';
import 'package:barter_app/services/messaging/firebase_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'configure_dependencies.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'services/security_test_helper.dart';

// The main entry point of the Flutter application.
void main() async {
  logDebug('🚀🚀🚀 MAIN() STARTED 🚀🚀🚀');
  WidgetsFlutterBinding.ensureInitialized();
  logDebug('✅ WidgetsFlutterBinding initialized');

  // Run security tests
  //if (!kDebugMode) {
  //  await SecurityTestHelper.runAllTests();
  //}

  logDebug('⏳ Configuring dependencies...');
  await configureDependencies();
  logDebug('✅ Dependencies configured');

  // Initialize Firebase (safe to call multiple times)
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
      title: AppLocalizations.of(context)?.appTitle ?? 'Barter App',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Defines the primary color swatch for the app
        useMaterial3: true, // Opt-in for Material 3 design system
      ),
      home: const InitializeScreen(),
    );
  }
}

