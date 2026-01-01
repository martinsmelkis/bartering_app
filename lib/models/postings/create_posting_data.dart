import 'package:json_annotation/json_annotation.dart';

part 'create_posting_data.g.dart';

@JsonSerializable()
class CreatePostingData {
  final String? id;
  final String userId;
  final String title;
  final String description;
  final double? value;
  final DateTime? expiresAt;
  final List<String>? imageUrls;
  final bool isOffer; // true for offer, false for interest/need
  final DateTime createdAt;

  const CreatePostingData({
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

  factory CreatePostingData.fromJson(Map<String, dynamic> json) =>
      _$CreatePostingDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostingDataToJson(this);

  CreatePostingData copyWith({
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
    return CreatePostingData(
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
