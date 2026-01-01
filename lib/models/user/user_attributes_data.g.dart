// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_attributes_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAttributesData _$UserAttributesDataFromJson(Map<String, dynamic> json) =>
    UserAttributesData(
      userId: json['userId'] as String,
      attributesRelevancyData:
          (json['attributesRelevancyData'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ),
    );

Map<String, dynamic> _$UserAttributesDataToJson(UserAttributesData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'attributesRelevancyData': instance.attributesRelevancyData,
    };
