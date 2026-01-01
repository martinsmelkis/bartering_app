import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:crypto/crypto.dart';

class CertificatePinning {
  /// Pins specific SSL certificates to prevent man-in-the-middle attacks
  /// and unauthorized backend communication from modified apps
  static void setupCertificatePinning(Dio dio,
      List<String> allowedSHA256Fingerprints) {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        // Get the DER-encoded certificate
        final certDER = cert.der;

        // Calculate SHA-256 hash
        final digest = sha256.convert(certDER);

        // Format as colon-separated hex string (e.g., "AB:CD:EF:...")
        final certSHA256 = digest.bytes
            .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
            .join(':')
            .toUpperCase();

        // Check if the certificate matches any of our pinned certificates
        final isValid = allowedSHA256Fingerprints.contains(certSHA256);

        if (!isValid) {
          print('❌ Certificate pinning failed! Cert SHA256: $certSHA256');
          print('   Expected one of: $allowedSHA256Fingerprints');
        }

        return isValid;
      };

      return client;
    };
  }

  /// Helper method to get certificate fingerprint for testing
  /// Use this to find out what fingerprint your server is using
  static String getCertificateFingerprint(X509Certificate cert) {
    final certDER = cert.der;
    final digest = sha256.convert(certDER);
    return digest.bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join(':')
        .toUpperCase();
  }
}
