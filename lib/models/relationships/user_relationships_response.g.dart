// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_relationships_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRelationshipsResponse _$UserRelationshipsResponseFromJson(
  Map<String, dynamic> json,
) => UserRelationshipsResponse(
  userId: json['userId'] as String,
  favorites:
      (json['favorites'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  friends:
      (json['friends'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  friendRequestsSent:
      (json['friendRequestsSent'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  friendRequestsReceived:
      (json['friendRequestsReceived'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  chattedWith:
      (json['chattedWith'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  blocked:
      (json['blocked'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  hidden:
      (json['hidden'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  traded:
      (json['traded'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  tradeInterested:
      (json['tradeInterested'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserRelationshipsResponseToJson(
  UserRelationshipsResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'favorites': instance.favorites,
  'friends': instance.friends,
  'friendRequestsSent': instance.friendRequestsSent,
  'friendRequestsReceived': instance.friendRequestsReceived,
  'chattedWith': instance.chattedWith,
  'blocked': instance.blocked,
  'hidden': instance.hidden,
  'traded': instance.traded,
  'tradeInterested': instance.tradeInterested,
};
