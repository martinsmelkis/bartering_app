part of 'user_moderation_cubit.dart';

/// Base state for user moderation
abstract class UserModerationState extends Equatable {
  const UserModerationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class UserModerationInitial extends UserModerationState {}

/// Loading state
class UserModerationLoading extends UserModerationState {}

/// User has been blocked
class UserBlocked extends UserModerationState {
  final String userId;

  const UserBlocked(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// User has been unblocked
class UserUnblocked extends UserModerationState {
  final String userId;

  const UserUnblocked(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// User has been reported
class UserReported extends UserModerationState {
  final String userId;
  final String reportId;

  const UserReported(this.userId, this.reportId);

  @override
  List<Object?> get props => [userId, reportId];
}

/// Blocked users have been loaded
class BlockedUsersLoaded extends UserModerationState {
  final List<String> blockedUserIds;

  const BlockedUsersLoaded(this.blockedUserIds);

  @override
  List<Object?> get props => [blockedUserIds];
}

/// Error state
class UserModerationError extends UserModerationState {
  final String message;

  const UserModerationError(this.message);

  @override
  List<Object?> get props => [message];
}
