// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_posting_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostingData _$CreatePostingDataFromJson(Map<String, dynamic> json) =>
    CreatePostingData(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      value: (json['value'] as num?)?.toDouble(),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isOffer: json['isOffer'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CreatePostingDataToJson(CreatePostingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'value': instance.value,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'imageUrls': instance.imageUrls,
      'isOffer': instance.isOffer,
      'createdAt': instance.createdAt.toIso8601String(),
    };
