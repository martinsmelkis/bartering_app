import 'package:json_annotation/json_annotation.dart';

part 'user_relationships_response.g.dart';

@JsonSerializable()
class UserRelationshipsResponse {
  final String userId;
  final List<String> favorites;
  final List<String> friends;
  final List<String> friendRequestsSent;
  final List<String> friendRequestsReceived;
  final List<String> chattedWith;
  final List<String> blocked;
  final List<String> hidden;
  final List<String> traded;
  final List<String> tradeInterested;

  const UserRelationshipsResponse({
    required this.userId,
    this.favorites = const [],
    this.friends = const [],
    this.friendRequestsSent = const [],
    this.friendRequestsReceived = const [],
    this.chattedWith = const [],
    this.blocked = const [],
    this.hidden = const [],
    this.traded = const [],
    this.tradeInterested = const [],
  });

  factory UserRelationshipsResponse.fromJson(Map<String, dynamic> json) =>
      _$UserRelationshipsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserRelationshipsResponseToJson(this);
}
