import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// SSL/TLS pinning utilities supporting both full-certificate pinning and
/// the more maintenance-friendly public-key (SPKI) pinning.
///
/// ## Quick-start
///
/// **Prefer public-key pinning** – it survives certificate renewals as long as
/// you keep the same key pair, so you only need an app update when you
/// actually rotate your private key (typically every few years).
///
/// ```dart
/// CertificatePinning.setupCertificatePinning(
///   dio,
///   allowedPublicKeyFingerprints: [
///     'sha256/AAABBBCCC...=',  // current key
///     'sha256/DDDEEEFFF...=',  // backup / next key
///   ],
/// );
/// ```
///
/// To discover your server's public-key fingerprint run:
/// ```sh
/// openssl s_client -connect api.example.com:443 2>/dev/null \
///   | openssl x509 -pubkey -noout \
///   | openssl pkey -pubin -outform DER \
///   | openssl dgst -sha256 -binary \
///   | openssl enc -base64
/// ```
/// Then prefix the output with `sha256/`.
class CertificatePinning {
  // ─── ASN.1 / DER helpers ────────────────────────────────────────────────

  static const int _tagSequence = 0x30;
  static const int _tagContext0 = 0xA0; // version [0] EXPLICIT

  /// Reads a DER length field at [pos].
  /// Returns `[decodedLength, bytesConsumed]`.
  static List<int> _readDerLength(List<int> data, int pos) {
    if (data[pos] < 0x80) return [data[pos], 1];
    final numBytes = data[pos] & 0x7F;
    int length = 0;
    for (int i = 0; i < numBytes; i++) {
      length = (length << 8) | data[pos + 1 + i];
    }
    return [length, 1 + numBytes];
  }

  /// Returns the total byte count of the TLV element starting at [pos]
  /// (tag byte + length bytes + value bytes).
  static int _skipTLV(List<int> data, int pos) {
    int offset = 1; // tag byte
    final lenResult = _readDerLength(data, pos + offset);
    offset += lenResult[1]; // length bytes
    offset += lenResult[0]; // value bytes
    return offset;
  }

  // ─── Public helpers ──────────────────────────────────────────────────────

  /// Extracts the raw **SubjectPublicKeyInfo (SPKI)** bytes from a
  /// DER-encoded X.509 certificate.
  ///
  /// The SPKI is the stable portion of the certificate: it stays identical
  /// across renewals as long as the same key pair is used, making it ideal
  /// for long-lived pins.
  ///
  /// Returns `null` if parsing fails (malformed cert or unexpected structure).
  static Uint8List? extractSPKI(List<int> derCert) {
    try {
      int pos = 0;

      // Enter outer Certificate SEQUENCE
      if (derCert[pos] != _tagSequence) return null;
      pos++; // skip tag
      pos += _readDerLength(derCert, pos)[1]; // skip length → inside Certificate

      // Enter TBSCertificate SEQUENCE
      if (derCert[pos] != _tagSequence) return null;
      pos++; // skip tag
      pos += _readDerLength(derCert, pos)[1]; // skip length → inside TBSCertificate

      // version [0] EXPLICIT INTEGER  (present in v2 / v3 certs – optional)
      if (derCert[pos] == _tagContext0) pos += _skipTLV(derCert, pos);

      pos += _skipTLV(derCert, pos); // serialNumber
      pos += _skipTLV(derCert, pos); // signature AlgorithmIdentifier
      pos += _skipTLV(derCert, pos); // issuer Name
      pos += _skipTLV(derCert, pos); // validity Validity
      pos += _skipTLV(derCert, pos); // subject Name

      // subjectPublicKeyInfo – extract the complete TLV bytes
      final spkiByteCount = _skipTLV(derCert, pos);
      return Uint8List.fromList(derCert.sublist(pos, pos + spkiByteCount));
    } catch (_) {
      return null;
    }
  }

  /// Returns the SHA-256 fingerprint of the **full certificate** in
  /// `"AB:CD:EF:..."` (colon-separated uppercase hex) format.
  ///
  /// Use this for classic certificate pinning.
  static String getCertificateFingerprint(X509Certificate cert) {
    final digest = sha256.convert(cert.der);
    return digest.bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join(':')
        .toUpperCase();
  }

  /// Returns the SHA-256 fingerprint of the certificate's **public key**
  /// (SPKI) in `"sha256/<base64>"` format – compatible with TrustKit (iOS)
  /// and OkHttp / Conscrypt (Android).
  ///
  /// Returns `null` if the SPKI cannot be extracted.
  static String? getPublicKeyFingerprint(X509Certificate cert) {
    final spki = extractSPKI(cert.der);
    if (spki == null) return null;
    final digest = sha256.convert(spki);
    return 'sha256/${base64.encode(digest.bytes)}';
  }

  // ─── Main API ────────────────────────────────────────────────────────────

  /// Configures [dio] to enforce SSL/TLS pinning.
  ///
  /// A connection is **accepted** when the server's certificate matches
  /// **any** entry in either of the two lists – so you can freely mix both
  /// pinning strategies and include backup / rotation pins.
  ///
  /// ### Parameters
  /// - [allowedCertFingerprints] — full-certificate SHA-256 fingerprints in
  ///   `"AB:CD:EF:..."` format (colon-separated uppercase hex).
  ///   Use these if you need the strictest guarantee (pins the entire cert).
  ///
  /// - [allowedPublicKeyFingerprints] — public-key (SPKI) SHA-256
  ///   fingerprints in `"sha256/<base64>"` format.
  ///   **Recommended** – survives certificate renewals when the key is reused.
  ///
  /// ### Example
  /// ```dart
  /// CertificatePinning.setupCertificatePinning(
  ///   dio,
  ///   allowedPublicKeyFingerprints: [
  ///     'sha256/AAABBBCCC...=',  // current key
  ///     'sha256/DDDEEEFFF...=',  // backup / upcoming rotation key
  ///   ],
  /// );
  /// ```
  /// // TODO use eventually
  static void setupCertificatePinning(
    Dio dio, {
    List<String> allowedCertFingerprints = const [],
    List<String> allowedPublicKeyFingerprints = const [],
  }) {
    assert(
      allowedCertFingerprints.isNotEmpty ||
          allowedPublicKeyFingerprints.isNotEmpty,
      'Provide at least one fingerprint (cert or public key).',
    );

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        // 1. Full-certificate check
        if (allowedCertFingerprints.isNotEmpty) {
          final certFP = getCertificateFingerprint(cert);
          if (allowedCertFingerprints.contains(certFP)) return true;
        }

        // 2. Public-key (SPKI) check
        if (allowedPublicKeyFingerprints.isNotEmpty) {
          final pkFP = getPublicKeyFingerprint(cert);
          if (pkFP != null && allowedPublicKeyFingerprints.contains(pkFP)) {
            return true;
          }
        }

        // Nothing matched – log details to help with debugging / rotation
        logDebugError('Certificate pinning failed for $host:$port');
        if (allowedCertFingerprints.isNotEmpty) {
          logDebug('  Cert fingerprint : ${getCertificateFingerprint(cert)}');
          logDebug('  Expected cert(s) : $allowedCertFingerprints');
        }
        if (allowedPublicKeyFingerprints.isNotEmpty) {
          logDebug('  PK fingerprint   : ${getPublicKeyFingerprint(cert)}');
          logDebug('  Expected PK(s)   : $allowedPublicKeyFingerprints');
        }

        return false;
      };

      return client;
    };
  }
}
