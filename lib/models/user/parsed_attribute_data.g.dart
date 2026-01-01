// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parsed_attribute_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParsedAttributeData _$ParsedAttributeDataFromJson(Map<String, dynamic> json) =>
    ParsedAttributeData(
      attribute: json['attribute'] as String,
      relevancyScore: (json['relevancyScore'] as num).toDouble(),
      uiStyleHint: json['uiStyleHint'] as String,
    );

Map<String, dynamic> _$ParsedAttributeDataToJson(
  ParsedAttributeData instance,
) => <String, dynamic>{
  'attribute': instance.attribute,
  'relevancyScore': instance.relevancyScore,
  'uiStyleHint': instance.uiStyleHint,
};
