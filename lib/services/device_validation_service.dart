import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceValidationResult {
  final bool isValid;
  final bool isPhysicalDevice;
  final int suspicionScore; // 0-100, higher = more suspicious
  final String reason;
  final Map<String, dynamic> details;
  final List<String> suspiciousIndicators;

  const DeviceValidationResult({
    required this.isValid,
    required this.isPhysicalDevice,
    required this.suspicionScore,
    required this.reason,
    required this.details,
    this.suspiciousIndicators = const [],
  });

  /// Returns a summary of suspicious findings
  String getSuspicionSummary() {
    if (suspiciousIndicators.isEmpty) {
      return 'No suspicious indicators found';
    }
    return 'Found ${suspiciousIndicators.length} suspicious indicator(s): ${suspiciousIndicators.join(", ")}';
  }
}

class DeviceValidationService {
  /// Comprehensive device validation
  static Future<DeviceValidationResult> validateDevice() async {
    final deviceInfo = DeviceInfoPlugin();
    int suspicionScore = 0;
    String reason = 'Valid device';
    Map<String, dynamic> details = {};
    List<String> suspiciousIndicators = [];

    try {
      if (kIsWeb) {
        // Web validation with comprehensive checks
        final webInfo = await deviceInfo.webBrowserInfo;

        details = {
          'browser': webInfo.browserName.toString(),
          'userAgent': webInfo.userAgent,
          'vendor': webInfo.vendor,
          'languages': webInfo.languages,
          'hardwareConcurrency': webInfo.hardwareConcurrency,
          'maxTouchPoints': webInfo.maxTouchPoints,
          'platform': webInfo.platform,
        };

        // === 1. User Agent Analysis ===
        final ua = webInfo.userAgent ?? '';

        // Check for headless/automation tools
        if (ua.contains('HeadlessChrome')) {
          suspicionScore += 50;
          suspiciousIndicators.add('HeadlessChrome detected');
        }
        if (ua.contains('PhantomJS')) {
          suspicionScore += 50;
          suspiciousIndicators.add('PhantomJS detected');
        }
        if (ua.contains('Selenium')) {
          suspicionScore += 50;
          suspiciousIndicators.add('Selenium detected');
        }
        if (ua.contains('puppeteer')) {
          suspicionScore += 50;
          suspiciousIndicators.add('Puppeteer detected');
        }
        if (ua.contains('webdriver')) {
          suspicionScore += 50;
          suspiciousIndicators.add('WebDriver detected');
        }

        // === 2. Browser Vendor Check ===
        // Real browsers should have a vendor
        if (webInfo.vendor?.isEmpty ?? true) {
          suspicionScore += 15;
          suspiciousIndicators.add('Missing browser vendor');
        }

        // === 3. Languages Check ===
        // Real browsers have language preferences
        final languages = webInfo.languages ?? [];
        if (languages.isEmpty) {
          suspicionScore += 15;
          suspiciousIndicators.add('No language preferences');
        }

        // === 4. Hardware Concurrency Check ===
        // Real devices have CPU cores
        final cores = webInfo.hardwareConcurrency ?? 0;
        if (cores == 0) {
          suspicionScore += 20;
          suspiciousIndicators.add('Zero CPU cores reported');
        } else if (cores > 64) {
          // Suspiciously high core count
          suspicionScore += 10;
          suspiciousIndicators.add('Unusually high CPU core count: $cores');
        }

        // === 5. Touch Points Check ===
        // Check for inconsistent touch capabilities
        final touchPoints = webInfo.maxTouchPoints ?? 0;
        final isMobile =
            ua.contains('Mobile') ||
            ua.contains('Android') ||
            ua.contains('iPhone');
        if (isMobile && touchPoints == 0) {
          // Mobile device claiming no touch support is suspicious
          suspicionScore += 15;
          suspiciousIndicators.add('Mobile UA without touch support');
        }

        // === 6. Platform Consistency Check ===
        final platformStr = webInfo.platform ?? '';

        // Check for platform/UA mismatches
        if (ua.contains('Windows') &&
            !platformStr.toLowerCase().contains('win')) {
          suspicionScore += 20;
          suspiciousIndicators.add('Platform/UA mismatch (Windows)');
        }
        if (ua.contains('Mac') && !platformStr.toLowerCase().contains('mac')) {
          suspicionScore += 20;
          suspiciousIndicators.add('Platform/UA mismatch (Mac)');
        }
        if (ua.contains('Linux') &&
            !platformStr.toLowerCase().contains('linux')) {
          suspicionScore += 20;
          suspiciousIndicators.add('Platform/UA mismatch (Linux)');
        }

        // === 7. User Agent Anomalies ===
        // Empty or very short user agent
        if (ua.length < 20) {
          suspicionScore += 30;
          suspiciousIndicators.add('Suspiciously short user agent');
        }

        // Missing common UA components
        if (!ua.contains('Mozilla') &&
            !ua.contains('Chrome') &&
            !ua.contains('Safari')) {
          suspicionScore += 25;
          suspiciousIndicators.add('Missing standard browser identifiers');
        }

        // === 8. Automation Framework Detection ===
        // Check for common automation tool patterns
        if (ua.toLowerCase().contains('bot')) {
          suspicionScore += 40;
          suspiciousIndicators.add('Bot indicator in UA');
        }
        if (ua.toLowerCase().contains('crawler')) {
          suspicionScore += 40;
          suspiciousIndicators.add('Crawler indicator in UA');
        }
        if (ua.toLowerCase().contains('spider')) {
          suspicionScore += 40;
          suspiciousIndicators.add('Spider indicator in UA');
        }

        // === 9. Screen Resolution Check (requires JS interop for full check) ===
        // This is a basic check - for more comprehensive checks,
        // you would need platform channels to JavaScript
        // Here we note the limitation in details
        details['screenCheckNote'] =
            'Enhanced screen validation available via JS interop';

        // === 10. Suspicious Browser Combinations ===
        final browserName = webInfo.browserName.toString().toLowerCase();

        // Chrome claiming to be on unusual platforms
        if (browserName.contains('chrome') &&
            platformStr.toLowerCase().contains('blackberry')) {
          suspicionScore += 25;
          suspiciousIndicators.add('Chrome on suspicious platform');
        }

        // Update reason based on findings
        if (suspicionScore > 50) {
          reason = suspiciousIndicators.isNotEmpty
              ? suspiciousIndicators.first
              : 'Likely automated browser detected';

          return DeviceValidationResult(
            isValid: false,
            isPhysicalDevice: true, // N/A for web
            suspicionScore: suspicionScore,
            reason: reason,
            details: details,
            suspiciousIndicators: suspiciousIndicators,
          );
        }

        // Add note about web validation
        details['validationNote'] =
            'Web platform validated with ${suspiciousIndicators.length} checks';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;

        details = {
          'platform': 'android',
          'brand': androidInfo.brand,
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'isPhysicalDevice': androidInfo.isPhysicalDevice,
          'sdkInt': androidInfo.version.sdkInt,
          'fingerprint': androidInfo.fingerprint,
        };

        // === 1. Physical Device Check ===
        if (!androidInfo.isPhysicalDevice) {
          suspicionScore += 40;
          suspiciousIndicators.add('Android emulator');
          reason = 'Android emulator detected';
        }

        // === 2. Generic Device Indicators ===
        if (androidInfo.brand.toLowerCase() == 'generic') {
          suspicionScore += 15;
          suspiciousIndicators.add('Generic brand');
        }

        if (androidInfo.model.toLowerCase().contains('sdk')) {
          suspicionScore += 15;
          suspiciousIndicators.add('SDK model name');
        }

        // === 3. Known Emulator Manufacturers ===
        final manufacturer = androidInfo.manufacturer.toLowerCase();
        if (manufacturer == 'genymotion') {
          suspicionScore += 30;
          suspiciousIndicators.add('Genymotion emulator');
        }
        if (manufacturer == 'andy') {
          suspicionScore += 30;
          suspiciousIndicators.add('Andy emulator');
        }
        if (manufacturer == 'nox') {
          suspicionScore += 30;
          suspiciousIndicators.add('Nox emulator');
        }

        // === 4. Suspicious Build Fingerprints ===
        final fingerprint = androidInfo.fingerprint.toLowerCase();
        if (fingerprint.contains('generic')) {
          suspicionScore += 10;
          suspiciousIndicators.add('Generic fingerprint');
        }
        if (fingerprint.contains('test-keys')) {
          suspicionScore += 20;
          suspiciousIndicators.add('Test keys in fingerprint');
        }

        // === 5. SDK Version Checks ===
        if (androidInfo.version.sdkInt < 21) {
          suspicionScore += 10;
          suspiciousIndicators.add('Very old Android version (< 5.0)');
        }

        // === 6. Model Name Analysis ===
        final model = androidInfo.model.toLowerCase();
        if (model.contains('emulator')) {
          suspicionScore += 25;
          suspiciousIndicators.add('Emulator in model name');
        }
        if (model.contains('simulator')) {
          suspicionScore += 25;
          suspiciousIndicators.add('Simulator in model name');
        }
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;

        details = {
          'platform': 'ios',
          'model': iosInfo.model,
          'name': iosInfo.name,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
          'systemVersion': iosInfo.systemVersion,
          'identifierForVendor': iosInfo.identifierForVendor,
        };

        // === 1. Physical Device Check ===
        if (!iosInfo.isPhysicalDevice) {
          suspicionScore += 40;
          suspiciousIndicators.add('iOS simulator');
          reason = 'iOS simulator detected';
        }

        // === 2. Model Name Analysis ===
        final model = iosInfo.model.toLowerCase();
        if (model.contains('simulator')) {
          suspicionScore += 15;
          suspiciousIndicators.add('Simulator in model name');
        }
        if (model.contains('x86')) {
          suspicionScore += 20;
          suspiciousIndicators.add('x86 architecture (simulator)');
        }

        // === 3. Identifier Check ===
        // Physical devices should have a vendor identifier
        if (iosInfo.identifierForVendor == null ||
            iosInfo.identifierForVendor!.isEmpty) {
          suspicionScore += 15;
          suspiciousIndicators.add('Missing vendor identifier');
        }

        // === 4. System Version Check ===
        // Check for suspiciously old or new versions
        final version = iosInfo.systemVersion;
        try {
          final majorVersion = int.tryParse(version.split('.').first) ?? 0;
          if (majorVersion < 12) {
            suspicionScore += 10;
            suspiciousIndicators.add('Very old iOS version');
          }
        } catch (e) {
          // Invalid version format
          suspicionScore += 5;
          suspiciousIndicators.add('Invalid iOS version format');
        }
      } else {
        // Desktop or other platform
        suspicionScore = 100;
        reason = 'Unsupported platform';
        details = {'platform': 'unsupported'};
        suspiciousIndicators.add('Desktop or unsupported platform');
      }

      // Determine validity
      final isValid = suspicionScore < 50;
      final isPhysicalDevice = kIsWeb
          ? true
          : (details['isPhysicalDevice'] ?? false);

      // Add overall assessment to details
      details['suspicionScore'] = suspicionScore;
      details['totalIndicators'] = suspiciousIndicators.length;

      debugPrint('@@@@@@@@@@@@@ Validate device end');

      return DeviceValidationResult(
        isValid: isValid,
        isPhysicalDevice: isPhysicalDevice,
        suspicionScore: suspicionScore,
        reason: isValid ? 'Valid device' : reason,
        details: details,
        suspiciousIndicators: suspiciousIndicators,
      );
    } catch (e) {
      // Device-info plugins can temporarily fail on newly released iOS/Android
      // versions or App Review hardware. Treat validation errors as non-blocking
      // so users never see a blank/blocked launch because a local heuristic failed.
      return DeviceValidationResult(
        isValid: true,
        isPhysicalDevice: true,
        suspicionScore: 0,
        reason: 'Device validation skipped after error: $e',
        details: {'error': e.toString(), 'validationSkipped': true},
        suspiciousIndicators: const [],
      );
    }
  }

  /// Get a human-readable summary of the device validation
  static Future<String> getDeviceSummary() async {
    final result = await validateDevice();

    final buffer = StringBuffer();
    buffer.writeln('Device Validation Summary:');
    buffer.writeln('- Valid: ${result.isValid ? "✓" : "✗"}');
    buffer.writeln('- Physical Device: ${result.isPhysicalDevice ? "✓" : "✗"}');
    buffer.writeln('- Suspicion Score: ${result.suspicionScore}/100');
    buffer.writeln('- Reason: ${result.reason}');

    if (result.suspiciousIndicators.isNotEmpty) {
      buffer.writeln(
        '- Suspicious Indicators (${result.suspiciousIndicators.length}):',
      );
      for (final indicator in result.suspiciousIndicators) {
        buffer.writeln('  • $indicator');
      }
    }

    return buffer.toString();
  }

  /// Simplified check for UI
  static Future<bool> isValidForRegistration({
    bool allowEmulators = false,
    bool allowWeb = true,
  }) async {
    final result = await validateDevice();

    if (!allowWeb && kIsWeb) return false;
    if (!allowEmulators && !result.isPhysicalDevice && !kIsWeb) return false;

    return result.isValid;
  }
}
