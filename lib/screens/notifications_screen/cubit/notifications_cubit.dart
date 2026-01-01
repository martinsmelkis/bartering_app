import 'package:barter_app/models/notifications/notification_models.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'notifications_state.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  final ApiClient _apiClient;

  NotificationsCubit(this._apiClient) : super(NotificationsState.initial());

  /// Load user's notification contacts
  Future<void> loadContacts() async {
    emit(state.copyWith(status: NotificationsStatus.loading));

    try {
      final response = await _apiClient.getNotificationContacts();
      emit(state.copyWith(
        contacts: response.contacts,
        status: NotificationsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Update user's notification contacts (email/preferences)
  /// Accepts either a request object or individual named parameters
  Future<String?> updateContacts({
    UpdateUserNotificationContactsRequest? request,
    String? email,
    bool? notificationsEnabled,
    int? quietHoursStart,
    int? quietHoursEnd,
  }) async {
    try {
      // Build request from parameters if not provided
      final updateRequest = request ??
          UpdateUserNotificationContactsRequest(
            email: email,
            notificationsEnabled: notificationsEnabled,
            quietHoursStart: quietHoursStart == -1 ? null : quietHoursStart,
            quietHoursEnd: quietHoursEnd == -1 ? null : quietHoursEnd,
          );

      final response = await _apiClient.updateNotificationContacts(updateRequest);
      emit(state.copyWith(contacts: response.contacts));
      return 'Contacts updated successfully';
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Add push token
  Future<String?> addPushToken(AddPushTokenRequest request) async {
    try {
      final response = await _apiClient.addPushToken(request);
      // Reload contacts to get updated push tokens list
      await loadContacts();
      return response.message;
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Remove push token
  Future<String?> removePushToken(String token) async {
    try {
      final response = await _apiClient.removePushToken(token);
      // Reload contacts to get updated push tokens list
      await loadContacts();
      return response.message;
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Load all attribute preferences
  Future<void> loadAttributePreferences() async {
    emit(state.copyWith(status: NotificationsStatus.loading));

    try {
      final response = await _apiClient.getAllAttributePreferences();
      emit(state.copyWith(
        attributePreferences: response.preferences,
        status: NotificationsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Update attribute preference
  Future<String?> updateAttributePreference(
    String attributeId,
    UpdateAttributeNotificationPreferenceRequest request,
  ) async {
    try {
      final response =
          await _apiClient.updateAttributePreference(attributeId, request);
      final updated = response.preference;

      // Update in the list
      final updatedList = state.attributePreferences.map((pref) {
        return pref.attributeId == updated.attributeId ? updated : pref;
      }).toList();

      // If it's a new preference, add it
      if (!updatedList.any((p) => p.attributeId == updated.attributeId)) {
        updatedList.add(updated);
      }

      emit(state.copyWith(attributePreferences: updatedList));
      return 'Preference updated';
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Delete attribute preference
  Future<String?> deleteAttributePreference(String attributeId) async {
    try {
      final response = await _apiClient.deleteAttributePreference(attributeId);

      // Remove from the list
      final updatedList = state.attributePreferences
          .where((pref) => pref.attributeId != attributeId)
          .toList();

      emit(state.copyWith(attributePreferences: updatedList));
      return response.message;
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Batch create attribute preferences
  Future<String?> batchCreateAttributePreferences(
      AttributeBatchRequest request) async {
    try {
      final response =
          await _apiClient.batchCreateAttributePreferences(request);
      // Reload to get all preferences
      await loadAttributePreferences();
      return 'Created ${response.created} preferences (${response.skipped} skipped)';
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Load match history
  Future<void> loadMatchHistory({bool unviewedOnly = false, int limit = 50}) async {
    try {
      final history = await _apiClient.getMatchHistory(unviewedOnly, limit);
      emit(state.copyWith(matchHistory: history));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Mark match as viewed
  Future<String?> markMatchViewed(String matchId) async {
    try {
      final response = await _apiClient.markMatchViewed(matchId);
      // Reload match history
      await loadMatchHistory();
      return response.message;
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Dismiss match
  Future<String?> dismissMatch(String matchId) async {
    try {
      final response = await _apiClient.dismissMatch(matchId);
      // Reload match history
      await loadMatchHistory();
      return response.message;
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }
}
