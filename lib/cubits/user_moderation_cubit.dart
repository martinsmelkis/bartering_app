import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/models/relationships/report_models.dart';
import 'package:barter_app/services/api_client.dart';

part 'user_moderation_state.dart';

/// Cubit for managing user blocking and reporting functionality
class UserModerationCubit extends Cubit<UserModerationState> {
  final ApiClient _apiClient;

  UserModerationCubit(this._apiClient) : super(UserModerationInitial());

  final Set<String> _blockedUserIds = {};
  final Set<String> _reportedUserIds = {};

  Set<String> get blockedUserIds => Set.unmodifiable(_blockedUserIds);
  Set<String> get reportedUserIds => Set.unmodifiable(_reportedUserIds);

  bool isBlocked(String userId) => _blockedUserIds.contains(userId);
  bool hasReported(String userId) => _reportedUserIds.contains(userId);

  /// Block a user
  Future<bool> blockUser(String currentUserId, String userIdToBlock) async {
    emit(UserModerationLoading());

    try {
      final request = RelationshipRequest(
        fromUserId: currentUserId,
        toUserId: userIdToBlock,
        relationshipType: 'blocked',
      );

      final response = await _apiClient.blockUser(request.toJson());
      final success = response == true;

      if (success) {
        _blockedUserIds.add(userIdToBlock);
        emit(UserBlocked(userIdToBlock));
        return true;
      } else {
        emit(const UserModerationError('Failed to block user'));
        return false;
      }
    } catch (e) {
      print('Error blocking user: $e');
      emit(UserModerationError(e.toString()));
      return false;
    }
  }

  /// Unblock a user
  Future<bool> unblockUser(String currentUserId, String userIdToUnblock) async {
    emit(UserModerationLoading());

    try {
      final request = RelationshipRequest(
        fromUserId: currentUserId,
        toUserId: userIdToUnblock,
        relationshipType: 'blocked',
      );

      final response = await _apiClient.unblockUser(request.toJson());
      final success = response == true;

      if (success) {
        _blockedUserIds.remove(userIdToUnblock);
        emit(UserUnblocked(userIdToUnblock));
        return true;
      } else {
        emit(const UserModerationError('Failed to unblock user'));
        return false;
      }
    } catch (e) {
      print('Error unblocking user: $e');
      emit(UserModerationError(e.toString()));
      return false;
    }
  }

  /// Report a user
  Future<String?> reportUser({
    required String reporterUserId,
    required String reportedUserId,
    required ReportReason reason,
    String? description,
    ReportContextType? contextType,
    String? contextId,
  }) async {
    emit(UserModerationLoading());

    try {
      final request = UserReportRequest(
        reporterUserId: reporterUserId,
        reportedUserId: reportedUserId,
        reportReason: reason.value,
        description: description,
        contextType: contextType?.value,
        contextId: contextId,
      );

      final reportId = await _apiClient.createReport(request.toJson());

      if (reportId != null) {
        _reportedUserIds.add(reportedUserId);
        emit(UserReported(reportedUserId, reportId));
        return reportId;
      } else {
        emit(const UserModerationError('Failed to report user'));
        return null;
      }
    } catch (e) {
      print('Error reporting user: $e');
      emit(UserModerationError(e.toString()));
      return null;
    }
  }

  /// Load blocked users for the current user
  Future<void> loadBlockedUsers(String userId) async {
    emit(UserModerationLoading());

    try {
      final profiles = await _apiClient.getBlockedUsers(userId);
      _blockedUserIds.clear();
      _blockedUserIds.addAll(profiles.map((p) => p.userId));
      emit(BlockedUsersLoaded(_blockedUserIds.toList()));
    } catch (e) {
      print('Error fetching blocked users: $e');
      emit(UserModerationError(e.toString()));
    }
  }

  /// Check if a user is blocked
  Future<bool> checkIsBlocked(String currentUserId, String otherUserId) async {
    try {
      final response = await _apiClient.isUserBlocked(currentUserId, otherUserId);
      final isBlocked = response == true;
      if (isBlocked) {
        _blockedUserIds.add(otherUserId);
      }
      return isBlocked;
    } catch (e) {
      print('Error checking block status: $e');
      return false;
    }
  }

}
