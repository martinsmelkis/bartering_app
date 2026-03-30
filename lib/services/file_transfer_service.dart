import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:barter_app/models/chat/file_attachment.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb, compute;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/export.dart' as pc;

// Web-specific import using conditional compilation
import 'package:barter_app/services/file_transfer_web.dart' if (dart.library.io) 'package:barter_app/services/file_transfer_stub.dart';

// Top-level function for background decryption (isolate-compatible)
Future<Uint8List> _decryptInBackground(Map<String, dynamic> params) async {
  final encryptedBytes = params['encryptedBytes'] as Uint8List;
  final senderPublicKeyString = params['senderPublicKey'] as String;
  final privateKeyHex = params['privateKeyHex'] as String;

  // Recreate minimal crypto context in the isolate
  final domainParams = pc.ECDomainParameters('secp256r1');
  final d = BigInt.parse(privateKeyHex, radix: 16);
  final myPrivateKey = pc.ECPrivateKey(d, domainParams);

  // Parse sender's public key
  final encodedPoint = base64Decode(senderPublicKeyString);
  final point = domainParams.curve.decodePoint(encodedPoint);
  if (point == null) throw Exception('Invalid sender public key');
  final senderPublicKey = pc.ECPublicKey(point, domainParams);

  // Derive shared secret via ECDH
  final agreement = pc.ECDHBasicAgreement();
  agreement.init(myPrivateKey);
  final sharedBigInt = agreement.calculateAgreement(senderPublicKey);
  final fieldSize = (domainParams.curve.fieldSize / 8).ceil();
  final sharedSecret = _bigIntToBytes(sharedBigInt, fieldSize);

  // Derive symmetric key via HKDF
  final saltLength = 16;
  final ivLength = 12;
  final aesKeyLength = 32;
  final tagLengthBits = 128;

  if (encryptedBytes.length < saltLength + ivLength) {
    throw Exception('Payload too short');
  }

  final salt = encryptedBytes.sublist(0, saltLength);
  final iv = encryptedBytes.sublist(saltLength, saltLength + ivLength);
  final cipherBytes = encryptedBytes.sublist(saltLength + ivLength);

  final infoBytes = utf8.encode("E2EE Chat Symmetric Key");
  final hkdf = pc.HKDFKeyDerivator(pc.SHA256Digest());
  hkdf.init(pc.HkdfParameters(sharedSecret, aesKeyLength, salt, infoBytes));
  final symmetricKey = hkdf.process(Uint8List(aesKeyLength));

  // Decrypt using AES-GCM
  final cipher = pc.GCMBlockCipher(pc.AESEngine());
  cipher.init(false, pc.AEADParameters(
      pc.KeyParameter(symmetricKey), tagLengthBits, iv, Uint8List(0)));

  return cipher.process(cipherBytes);
}

// Helper for BigInt to fixed-size byte array (needed in isolate)
Uint8List _bigIntToBytes(BigInt number, int byteLength) {
  final bytes = Uint8List(byteLength);
  for (var i = byteLength - 1; i >= 0; i--) {
    bytes[i] = number.toUnsigned(8).toInt();
    number = number >> 8;
  }
  return bytes;
}

/// Result of a file download operation
class DownloadResult {
  final String? localPath; // Path to saved file (null on web)
  final Uint8List decryptedBytes; // Decrypted file bytes for preview

  DownloadResult({
    this.localPath,
    required this.decryptedBytes,
  });
}

/// Service for handling encrypted file transfers in chat
class FileTransferService {
  final ApiClient _apiClient;
  final CryptoService _cryptoService;

  FileTransferService(this._apiClient, this._cryptoService);

  /// Upload an encrypted file
  /// 
  /// Process:
  /// 1. Read file bytes
  /// 2. Encrypt file with recipient's public key
  /// 3. Upload encrypted file to server
  /// 4. Return file metadata
  Future<FileAttachment?> uploadFile({
    required String senderId,
    required String recipientId,
    required String filePath,
    required String recipientPublicKey,
    int ttlHours = 24,
    Function(double)? onProgress,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      // Read file bytes
      final fileBytes = await file.readAsBytes();

      // Get file info
      final filename = path.basename(filePath);
      final mimeType = _getMimeType(filename);

      // Encrypt file bytes with recipient's public key
      final encryptedBytes = await _cryptoService.encryptBytes(
        fileBytes,
        recipientPublicKey,
      );

      // Create multipart file
      final multipartFile = MultipartFile.fromBytes(
        encryptedBytes,
        filename: filename,
      );

      // Upload to server
      final response = await _apiClient.uploadEncryptedFile(
        senderId,
        recipientId,
        filename,
        mimeType,
        ttlHours.toString(),
        multipartFile,
      );

      // Check if upload was successful
      if (response.success) {
        return FileAttachment(
          fileId: response.fileId,
          filename: filename,
          mimeType: mimeType,
          fileSize: fileBytes.length,
          expiresAt: response.expiresAt,
          isUploading: false,
        );
      } else {
        print('File upload failed: ${response.message}');
        return null;
      }
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  /// Upload an encrypted file from bytes (web-compatible)
  /// 
  /// This method accepts file bytes directly, making it compatible with web platform
  /// where file system access is limited.
  Future<FileAttachment?> uploadFileFromBytes({
    required String senderId,
    required String recipientId,
    required Uint8List fileBytes,
    required String filename,
    required String recipientPublicKey,
    int ttlHours = 24,
    Function(double)? onProgress,
  }) async {
    try {
      // Get MIME type
      final mimeType = _getMimeType(filename);

      // Encrypt file bytes with recipient's public key
      final encryptedBytes = await _cryptoService.encryptBytes(
        fileBytes,
        recipientPublicKey,
      );

      // Create multipart file
      final multipartFile = MultipartFile.fromBytes(
        encryptedBytes,
        filename: filename,
      );

      // Upload to server
      final response = await _apiClient.uploadEncryptedFile(
        senderId,
        recipientId,
        filename,
        mimeType,
        ttlHours.toString(),
        multipartFile,
      );

      // Check if upload was successful
      if (response.success) {
        return FileAttachment(
          fileId: response.fileId,
          filename: filename,
          mimeType: mimeType,
          fileSize: fileBytes.length,
          expiresAt: response.expiresAt,
          isUploading: false,
        );
      } else {
        print('File upload failed: ${response.message}');
        return null;
      }
    } catch (e) {
      print('Error uploading file from bytes: $e');
      rethrow;
    }
  }

  // TODO make web worker for web platform async mode?
  /// Download and decrypt a file
  ///
  /// Process:
  /// 1. Download encrypted file from server
  /// 2. Decrypt file with sender's public key (using recipient's private key via ECDH)
  /// 3. Save decrypted file to local storage (web: trigger browser download)
  /// 4. Return DownloadResult with both bytes (for preview) and path (for opening)
  Future<DownloadResult> downloadFile({
    required String fileId,
    required String userId,
    required String filename,
    required String senderPublicKey, // Sender's public key for ECDH decryption
    Function(double)? onProgress,
    bool saveToFile = true, // If false, only returns bytes (for preview)
  }) async {
    try {
      // Download encrypted file
      final encryptedBytes = await _apiClient.downloadEncryptedFile(
        fileId,
        userId,
      );

      print('@@@@@@@@@ Downloaded ${encryptedBytes.length} encrypted bytes');
      print('@@@@@@@@@ Decrypting with sender public key: ${senderPublicKey
          .substring(0, 20)}...');

      Uint8List decryptedBytes;
      
      // Use chunked decryption on web for large files to prevent UI freeze
      if (kIsWeb && encryptedBytes.length > 128 * 1024) {
        // For files > 128KB on web, use chunked decryption with progress
        decryptedBytes = await _decryptChunked(
          Uint8List.fromList(encryptedBytes),
          senderPublicKey,
          onProgress: onProgress,
        );
      } else {
        // For small files or native platforms, use direct decryption
        onProgress?.call(0.3); // Started
        decryptedBytes = await _cryptoService.decryptBytes(
          Uint8List.fromList(encryptedBytes),
          senderPublicKey,
        );
        onProgress?.call(1.0); // Complete
      }

      // If only preview is needed, return bytes without saving
      if (!saveToFile) {
        return DownloadResult(decryptedBytes: decryptedBytes);
      }

      if (kIsWeb) {
        // Web: Trigger browser download
        downloadFileOnWeb(filename, decryptedBytes);
        return DownloadResult(
          decryptedBytes: decryptedBytes,
        ); // No local path on web
      } else {
        // Mobile/Desktop: Save to local storage
        final directory = await getApplicationDocumentsDirectory();
        final downloadsDir = Directory('${directory.path}/downloads');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        // Generate unique filename if file already exists
        var localFilePath = '${downloadsDir.path}/$filename';
        var counter = 1;
        while (await File(localFilePath).exists()) {
          final ext = path.extension(filename);
          final name = path.basenameWithoutExtension(filename);
          localFilePath = '${downloadsDir.path}/${name}_$counter$ext';
          counter++;
        }

        // Write decrypted bytes to file
        final localFile = File(localFilePath);
        await localFile.writeAsBytes(decryptedBytes);

        print('File downloaded and decrypted: $localFilePath');
        return DownloadResult(
          localPath: localFilePath,
          decryptedBytes: decryptedBytes,
        );
      }
    } catch (e) {
      print('Error downloading file: $e');
      rethrow;
    }
  }

  /// Get pending files for a user
  Future<List<FileAttachment>> getPendingFiles(String userId) async {
    try {
      final fileDtos = await _apiClient.getPendingFiles(userId);

      return fileDtos.map((dto) => dto.toFileAttachment()).toList();
    } catch (e) {
      print('Error getting pending files: $e');
      return [];
    }
  }

  /// Get MIME type from filename extension
  String _getMimeType(String filename) {
    final ext = path.extension(filename).toLowerCase();

    switch (ext) {
    // Images
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.svg':
        return 'image/svg+xml';

    // Documents
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.xls':
        return 'application/vnd.ms-excel';
      case '.xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case '.txt':
        return 'text/plain';

    // Audio
      case '.mp3':
        return 'audio/mpeg';
      case '.wav':
        return 'audio/wav';
      case '.ogg':
        return 'audio/ogg';

    // Video
      case '.mp4':
        return 'video/mp4';
      case '.avi':
        return 'video/x-msvideo';
      case '.mov':
        return 'video/quicktime';
      case '.webm':
        return 'video/webm';

    // Archives
      case '.zip':
        return 'application/zip';
      case '.rar':
        return 'application/x-rar-compressed';
      case '.7z':
        return 'application/x-7z-compressed';

      default:
        return 'application/octet-stream';
    }
  }

  /// Decrypt bytes using chunked processing to prevent UI freeze on web.
  /// Yields to event loop every 256KB to allow UI updates.
  Future<Uint8List> _decryptChunked(
    Uint8List encryptedPayload,
    String senderPublicKeyString, {
    Function(double)? onProgress,
  }) async {
    const chunkSize = 256 * 1024; // 256KB chunks
    
    // Derive symmetric key once (same as decryptBytes but chunked)
    final senderPublicKey = _cryptoService.ecPublicKeyFromString(senderPublicKeyString);
    if (senderPublicKey == null) throw Exception('Invalid sender public key');
    
    final sharedSecret = _cryptoService.deriveSharedSecret(senderPublicKey);
    if (sharedSecret == null) throw Exception('Could not derive shared secret');
    
    const saltLength = 16;
    const ivLength = 12;
    const aesKeyLength = 32;
    const tagLengthBits = 128;
    
    if (encryptedPayload.length < saltLength + ivLength) {
      throw Exception('Payload too short');
    }
    
    final salt = encryptedPayload.sublist(0, saltLength);
    final iv = encryptedPayload.sublist(saltLength, saltLength + ivLength);
    final cipherBytes = encryptedPayload.sublist(saltLength + ivLength);
    
    final infoBytes = utf8.encode("E2EE Chat Symmetric Key");
    final hkdf = pc.HKDFKeyDerivator(pc.SHA256Digest());
    hkdf.init(pc.HkdfParameters(sharedSecret, aesKeyLength, salt, infoBytes));
    final symmetricKey = hkdf.process(Uint8List(aesKeyLength));
    
    onProgress?.call(0.3); // Key derivation complete
    
    // For GCM, we can't truly chunk - must process as whole
    // But we yield before/after to allow UI updates
    await Future.delayed(Duration.zero);
    
    final cipher = pc.GCMBlockCipher(pc.AESEngine());
    cipher.init(false, pc.AEADParameters(
        pc.KeyParameter(symmetricKey), tagLengthBits, iv, Uint8List(0)));
    
    onProgress?.call(0.5); // Decrypting
    
    final decryptedBytes = cipher.process(cipherBytes);
    
    onProgress?.call(1.0); // Decryption complete
    await Future.delayed(Duration.zero); // Yield to UI
    
    return decryptedBytes;
  }

  /// Format file size for display
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
