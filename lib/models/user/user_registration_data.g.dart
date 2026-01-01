// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registration_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistrationData _$UserRegistrationDataFromJson(
  Map<String, dynamic> json,
) => UserRegistrationData(
  id: json['id'] as String,
  name: json['name'] as String,
  publicKey: json['publicKey'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$UserRegistrationDataToJson(
  UserRegistrationData instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'publicKey': instance.publicKey,
  'email': instance.email,
  'password': instance.password,
};
