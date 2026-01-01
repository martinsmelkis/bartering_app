import 'package:json_annotation/json_annotation.dart';
import 'file_attachment.dart';

part 'file_metadata_dto.g.dart';

/// DTO for file metadata from server
/// Matches Kotlin: FileMetadataDto
@JsonSerializable()
class FileMetadataDto {
  final String id;
  final String senderId;
  final String filename;
  final String mimeType;
  final int fileSize;
  final int expiresAt;

  FileMetadataDto({
    required this.id,
    required this.senderId,
    required this.filename,
    required this.mimeType,
    required this.fileSize,
    required this.expiresAt,
  });

  factory FileMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$FileMetadataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FileMetadataDtoToJson(this);

  /// Convert to FileAttachment for display in chat
  FileAttachment toFileAttachment() {
    return FileAttachment(
      fileId: id,
      filename: filename,
      mimeType: mimeType,
      fileSize: fileSize,
      expiresAt: expiresAt,
      isDownloaded: false,
    );
  }
}
