import 'dart:async';
import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/repositories/chat_repository.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// State for the chats badge (total unread count)
class ChatsBadgeState {
  final int unreadCount;
  final bool isLoading;

  const ChatsBadgeState({
    this.unreadCount = 0,
    this.isLoading = false,
  });

  ChatsBadgeState copyWith({
    int? unreadCount,
    bool? isLoading,
  }) {
    return ChatsBadgeState(
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Cubit to manage the total unread chat count badge
class ChatsBadgeCubit extends Cubit<ChatsBadgeState> {
  final ChatRepository _chatRepository = getIt<ChatRepository>();
  final UserRepository _userRepository = getIt<UserRepository>();
  
  StreamSubscription? _conversationsSubscription;
  String? _currentUserId;

  ChatsBadgeCubit() : super(const ChatsBadgeState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    emit(state.copyWith(isLoading: true));
    
    try {
      _currentUserId = await _userRepository.getUserId();
      
      if (_currentUserId != null) {
        // Watch for conversation changes and update badge count
        _conversationsSubscription = _chatRepository
            .watchConversationsForUser(_currentUserId!)
            .listen((conversations) {
          final totalUnread = conversations.fold<int>(
            0,
            (sum, conv) => sum + conv.unreadCount,
          );
          
          emit(ChatsBadgeState(
            unreadCount: totalUnread,
            isLoading: false,
          ));
          
          print('📬 Chat badge updated: $totalUnread unread messages');
        });
      } else {
        emit(const ChatsBadgeState(isLoading: false));
      }
    } catch (e) {
      print('❌ Error initializing chat badge cubit: $e');
      emit(const ChatsBadgeState(isLoading: false));
    }
  }

  /// Manually refresh the unread count (optional)
  Future<void> refresh() async {
    if (_currentUserId == null) {
      _currentUserId = await _userRepository.getUserId();
    }
    
    if (_currentUserId != null) {
      try {
        final count = await _chatRepository.getTotalUnreadCount(_currentUserId!);
        emit(state.copyWith(unreadCount: count));
        print('📬 Chat badge refreshed: $count unread messages');
      } catch (e) {
        print('❌ Error refreshing chat badge: $e');
      }
    }
  }

  @override
  Future<void> close() {
    _conversationsSubscription?.cancel();
    return super.close();
  }
}
