import 'package:json_annotation/json_annotation.dart';

part 'user_registration_data.g.dart';

@JsonSerializable() // Add this annotation
class UserRegistrationData {
  final String id;
  final String name;
  final String publicKey;
  final String email;
  final String password;

  const UserRegistrationData({
    required this.id,
    required this.name,
    required this.publicKey,
    required this.email,
    required this.password,
  });

  // Factory constructor for creating a new UserRegistrationData instance from a map.
  // Tell json_serializable to use this for deserialization.
  factory UserRegistrationData.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationDataFromJson(json);

  // Method for converting a UserRegistrationData instance into a map.
  // Tell json_serializable to use this for serialization.
  Map<String, dynamic> toJson() => _$UserRegistrationDataToJson(this);

  UserRegistrationData copyWith({
    String? id,
    String? name,
    String? publicKey,
    String? email,
    String? password,
  }) {
    return UserRegistrationData(
      id: id ?? this.id,
      name: name ?? this.name,
      publicKey: publicKey ?? this.publicKey,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

}