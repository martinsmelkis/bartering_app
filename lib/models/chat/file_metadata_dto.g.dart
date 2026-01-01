// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_metadata_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileMetadataDto _$FileMetadataDtoFromJson(Map<String, dynamic> json) =>
    FileMetadataDto(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      filename: json['filename'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      expiresAt: (json['expiresAt'] as num).toInt(),
    );

Map<String, dynamic> _$FileMetadataDtoToJson(FileMetadataDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'filename': instance.filename,
      'mimeType': instance.mimeType,
      'fileSize': instance.fileSize,
      'expiresAt': instance.expiresAt,
    };
