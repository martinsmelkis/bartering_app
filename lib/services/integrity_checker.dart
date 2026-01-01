import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class IntegrityChecker {
  // Your official release signing certificate SHA-256 fingerprint
  // Get this from your keystore: keytool -list -v -keystore your-release-key.jks
  static const String EXPECTED_SIGNATURE = "6D:2E:DF:6D:F9:AD:1A:30:CE:79:A3:83:02:C7:D1:16:3B:BB:7D:47:66:5A:1D:F5:22:48:18:A5:C2:93:55:01";

  /// Checks if the app signature matches the expected production signature
  /// Returns true if valid, false if tampered/re-signed
  static Future<bool> verifyAppSignature() async {
    if (kIsWeb) return true; // Skip on web
    if (!Platform.isAndroid) return true; // iOS has different protections

    try {
      // Use MethodChannel to get package signature from Android
      const platform = MethodChannel('org.barter.barterapp.barter_app/integrity');
      final String? signature = await platform.invokeMethod('getSignature');

      if (signature == null) {
        print('❌ Unable to retrieve app signature');
        return false;
      }

      // In debug mode, allow debug signatures
      if (kDebugMode) {
        print('⚠️ Debug mode: Skipping signature verification');
        return true;
      }

      // In release mode, verify signature
      final isValid = signature == EXPECTED_SIGNATURE;

      if (!isValid) {
        print('❌ Invalid app signature detected!');
        print('   Expected: $EXPECTED_SIGNATURE');
        print('   Got:      $signature');
      }

      return isValid;
    } catch (e) {
      print('❌ Error checking app signature: $e');
      return false;
    }
  }

  /// Verifies the app is installed from official sources (Google Play Store)
  static Future<bool> verifyInstallSource() async {
    if (kIsWeb) return true;
    if (!Platform.isAndroid) return true;

    try {
      const platform = MethodChannel('org.barter.barterapp.barter_app/integrity');
      final String? installer = await platform.invokeMethod('getInstallSource');

      // Allow installation from official sources
      const allowedInstallers = [
        'com.android.vending', // Google Play Store
        // 'com.amazon.venezia', // Amazon Appstore (if you publish there)
      ];

      if (kDebugMode) {
        print('⚠️ Debug mode: Install source = $installer (allowed)');
        return true;
      }

      final isValid = installer != null &&
          allowedInstallers.contains(installer);

      if (!isValid) {
        print('❌ App installed from unauthorized source: $installer');
      }

      return isValid;
    } catch (e) {
      print('❌ Error checking install source: $e');
      return false;
    }
  }

  /// Checks for signs of rooted/jailbroken device
  static Future<bool> checkDeviceSecurity() async {
    if (kIsWeb) return true;
    if (!Platform.isAndroid) return true; // Simplified for this example

    try {
      const platform = MethodChannel('org.barter.barterapp.barter_app/integrity');
      final bool? isRooted = await platform.invokeMethod('isDeviceRooted');

      if (isRooted == true) {
        print('⚠️ Warning: Device appears to be rooted');
        // Don't necessarily block rooted devices, but be aware
        // Some legitimate users root their phones
      }

      return true; // Allow for now, but log the warning
    } catch (e) {
      print('⚠️ Unable to check root status: $e');
      return true;
    }
  }
}
