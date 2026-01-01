import 'dart:io';
import 'dart:typed_data';
import 'package:barter_app/models/chat/file_attachment.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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

  /// Download and decrypt a file
  /// 
  /// Process:
  /// 1. Download encrypted file from server
  /// 2. Decrypt file with sender's public key (using recipient's private key via ECDH)
  /// 3. Save decrypted file to local storage
  /// 4. Return local file path
  Future<String?> downloadFile({
    required String fileId,
    required String userId,
    required String filename,
    required String senderPublicKey, // Sender's public key for ECDH decryption
    Function(double)? onProgress,
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

      // Decrypt file bytes using sender's public key
      // The CryptoService will use our private key + sender's public key to derive shared secret
      final decryptedBytes = await _cryptoService.decryptBytes(
        Uint8List.fromList(encryptedBytes),
        senderPublicKey,
      );

      // Save to local storage
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
      return localFilePath;
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
