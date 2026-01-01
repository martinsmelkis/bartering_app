// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_attribute_entry_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAttributeEntryData _$UserAttributeEntryDataFromJson(
  Map<String, dynamic> json,
) => UserAttributeEntryData(
  attributeId: json['attributeId'] as String,
  type: (json['type'] as num).toInt(),
  relevancy: (json['relevancy'] as num).toDouble(),
  description: json['description'] as String?,
  uiStyleHint: json['uiStyleHint'] as String?,
);

Map<String, dynamic> _$UserAttributeEntryDataToJson(
  UserAttributeEntryData instance,
) => <String, dynamic>{
  'attributeId': instance.attributeId,
  'type': instance.type,
  'relevancy': instance.relevancy,
  'description': instance.description,
  'uiStyleHint': instance.uiStyleHint,
};
