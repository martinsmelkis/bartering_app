import 'package:json_annotation/json_annotation.dart';

part 'posting_data_response.g.dart';

@JsonSerializable()
class UserPostingData {
  final String? id;
  final String userId;
  final String title;
  final String description;
  final double? value;
  final DateTime? expiresAt;
  final List<String>? imageUrls;
  final bool isOffer; // true for offer, false for interest/need
  final DateTime createdAt;

  const UserPostingData({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.value,
    this.expiresAt,
    this.imageUrls,
    required this.isOffer,
    required this.createdAt,
  });

  factory UserPostingData.fromJson(Map<String, dynamic> json) =>
      _$UserPostingDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserPostingDataToJson(this);

  UserPostingData copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    double? value,
    DateTime? expiresAt,
    List<String>? imageUrls,
    bool? isOffer,
    DateTime? createdAt,
  }) {
    return UserPostingData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      value: value ?? this.value,
      expiresAt: expiresAt ?? this.expiresAt,
      imageUrls: imageUrls ?? this.imageUrls,
      isOffer: isOffer ?? this.isOffer,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
