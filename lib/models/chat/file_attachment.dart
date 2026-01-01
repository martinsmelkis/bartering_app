/// Model for file attachments in chat messages
class FileAttachment {
  final String fileId;
  final String filename;
  final String mimeType;
  final int fileSize;
  final int expiresAt;
  final String? localPath; // Path to downloaded file
  final bool isDownloaded;
  final bool isUploading;
  final double? uploadProgress;

  FileAttachment({
    required this.fileId,
    required this.filename,
    required this.mimeType,
    required this.fileSize,
    required this.expiresAt,
    this.localPath,
    this.isDownloaded = false,
    this.isUploading = false,
    this.uploadProgress,
  });

  factory FileAttachment.fromJson(Map<String, dynamic> json) {
    return FileAttachment(
      fileId: json['fileId'] as String,
      filename: json['filename'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: json['fileSize'] as int,
      expiresAt: json['expiresAt'] as int,
      localPath: json['localPath'] as String?,
      isDownloaded: json['isDownloaded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'filename': filename,
      'mimeType': mimeType,
      'fileSize': fileSize,
      'expiresAt': expiresAt,
      'localPath': localPath,
      'isDownloaded': isDownloaded,
    };
  }

  FileAttachment copyWith({
    String? fileId,
    String? filename,
    String? mimeType,
    int? fileSize,
    int? expiresAt,
    String? localPath,
    bool? isDownloaded,
    bool? isUploading,
    double? uploadProgress,
  }) {
    return FileAttachment(
      fileId: fileId ?? this.fileId,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      expiresAt: expiresAt ?? this.expiresAt,
      localPath: localPath ?? this.localPath,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  /// Get human-readable file size
  String get fileSizeFormatted {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024)
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Check if file is an image
  bool get isImage => mimeType.startsWith('image/');

  /// Check if file is a video
  bool get isVideo => mimeType.startsWith('video/');

  /// Check if file is audio
  bool get isAudio => mimeType.startsWith('audio/');

  /// Check if file is a document
  bool get isDocument =>
      mimeType.contains('pdf') ||
          mimeType.contains('document') ||
          mimeType.contains('text') ||
          mimeType.contains('msword') ||
          mimeType.contains('spreadsheet');
}
