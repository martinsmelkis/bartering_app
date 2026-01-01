import 'package:flutter/foundation.dart';
import 'integrity_checker.dart';

/// Helper class to test security features during development
class SecurityTestHelper {
  /// Test the app signature verification
  /// This will print the current signature to the console
  static Future<void> testSignatureVerification() async {
    print('=== Security Test: App Signature ===');

    try {
      final isValid = await IntegrityChecker.verifyAppSignature();
      print(
          '✅ Signature verification result: ${isValid ? "VALID" : "INVALID"}');
      print('   Build mode: ${kDebugMode ? "DEBUG" : "RELEASE"}');
      print('   Expected: ${IntegrityChecker.EXPECTED_SIGNATURE}');
    } catch (e) {
      print('❌ Error testing signature: $e');
    }

    print('===================================\n');
  }

  /// Test the install source verification
  static Future<void> testInstallSource() async {
    print('=== Security Test: Install Source ===');

    try {
      final isValid = await IntegrityChecker.verifyInstallSource();
      print('✅ Install source check: ${isValid ? "VALID" : "INVALID"}');
    } catch (e) {
      print('❌ Error testing install source: $e');
    }

    print('=====================================\n');
  }

  /// Test root detection
  static Future<void> testRootDetection() async {
    print('=== Security Test: Root Detection ===');

    try {
      final isSecure = await IntegrityChecker.checkDeviceSecurity();
      print('✅ Device security check: ${isSecure
          ? "SECURE"
          : "ROOTED/INSECURE"}');
    } catch (e) {
      print('❌ Error testing root detection: $e');
    }

    print('=====================================\n');
  }

  /// Run all security tests
  static Future<void> runAllTests() async {
    print('\n🔐 Running All Security Tests...\n');
    await testSignatureVerification();
    await testInstallSource();
    await testRootDetection();
    print('🔐 All Security Tests Complete!\n');
  }
}
