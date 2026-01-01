import 'package:json_annotation/json_annotation.dart';

part 'file_upload_response.g.dart';

/// Response from file upload endpoint
/// Matches Kotlin: FileUploadResponse
@JsonSerializable()
class FileUploadResponse {
  final bool success;
  final String fileId;
  final int expiresAt;
  final String message;

  FileUploadResponse({
    required this.success,
    required this.fileId,
    required this.expiresAt,
    required this.message,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$FileUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadResponseToJson(this);
}
