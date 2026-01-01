// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileUploadResponse _$FileUploadResponseFromJson(Map<String, dynamic> json) =>
    FileUploadResponse(
      success: json['success'] as bool,
      fileId: json['fileId'] as String,
      expiresAt: (json['expiresAt'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$FileUploadResponseToJson(FileUploadResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'fileId': instance.fileId,
      'expiresAt': instance.expiresAt,
      'message': instance.message,
    };
