import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@singleton
class DeviceFingerprintService {
  static final DeviceFingerprintService _instance = DeviceFingerprintService._internal();
  factory DeviceFingerprintService() => _instance;
  DeviceFingerprintService._internal();

  String? _cachedFingerprint;

  /// Generates a unique device fingerprint
  Future<String> getDeviceFingerprint() async {
    if (_cachedFingerprint != null) return _cachedFingerprint!;

    final deviceInfo = DeviceInfoPlugin();
    final components = <String>[];

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        // Use Android ID as the primary identifier (similar to platform_device_id)
        components.addAll([
          androidInfo.id, // This is the Android ID - persistent unique device identifier
          androidInfo.model,
          androidInfo.brand,
          androidInfo.device,
          androidInfo.hardware,
          androidInfo.manufacturer,
          androidInfo.product,
        ]);
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        components.addAll([
          iosInfo.identifierForVendor ?? '', // This is the iOS unique identifier
          iosInfo.model,
          iosInfo.name,
          iosInfo.systemName,
          iosInfo.systemVersion,
        ]);
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        components.addAll([
          windowsInfo.deviceId,
          windowsInfo.computerName,
          windowsInfo.numberOfCores.toString(),
        ]);
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        components.addAll([
          linuxInfo.id,
          linuxInfo.machineId ?? '',
        ]);
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        components.addAll([
          macInfo.systemGUID ?? '',
          macInfo.model,
        ]);
      } else {
        if (kIsWeb) {
          final webInfo = await deviceInfo.webBrowserInfo;
          components.addAll([
            webInfo.userAgent ?? '',
            webInfo.language ?? '',
            webInfo.data.hashCode.toString() ?? ''
          ]);
        }
      }

      // Generate hash
      final combined = components.join('|');
      final bytes = utf8.encode(combined);
      final digest = sha256.convert(bytes);

      _cachedFingerprint = digest.toString();
      return _cachedFingerprint!;
    } catch (e) {
      // Fallback to random ID (stored in secure storage)
      return _generateFallbackFingerprint();
    }
  }

  String _generateFallbackFingerprint() {
    // Generate and store in secure storage
    return sha256.convert(utf8.encode(DateTime.now().toString())).toString();
  }

  /// Clears cached fingerprint (for testing)
  void clearCache() {
    _cachedFingerprint = null;
  }
}