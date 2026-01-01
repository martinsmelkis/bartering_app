part of 'notifications_cubit.dart';

enum NotificationsStatus { initial, loading, success, error }

class NotificationsState extends Equatable {
  final UserNotificationContacts? contacts;
  final List<AttributeNotificationPreference> attributePreferences;
  final MatchHistoryResponse? matchHistory;
  final NotificationsStatus status;
  final String? errorMessage;

  const NotificationsState({
    this.contacts,
    this.attributePreferences = const [],
    this.matchHistory,
    this.status = NotificationsStatus.initial,
    this.errorMessage,
  });

  factory NotificationsState.initial() {
    return const NotificationsState(
      status: NotificationsStatus.initial,
    );
  }

  NotificationsState copyWith({
    UserNotificationContacts? contacts,
    List<AttributeNotificationPreference>? attributePreferences,
    MatchHistoryResponse? matchHistory,
    NotificationsStatus? status,
    String? errorMessage,
  }) {
    return NotificationsState(
      contacts: contacts ?? this.contacts,
      attributePreferences: attributePreferences ?? this.attributePreferences,
      matchHistory: matchHistory ?? this.matchHistory,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        contacts,
        attributePreferences,
        matchHistory,
        status,
        errorMessage,
      ];
}
