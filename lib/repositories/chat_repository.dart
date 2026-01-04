import 'package:barter_app/data/local/app_database.dart';
import 'package:barter_app/models/chat/chat_message.dart';
import 'package:barter_app/models/chat/e_chat_message_status.dart';
import 'package:barter_app/models/chat/file_attachment.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

/// Repository for managing chat messages and conversations in local database
@singleton
@injectable
class ChatRepository {
  final AppDatabase _database;
  final UserRepository _userRepository;

  ChatRepository(this._database, this._userRepository);

  // ==================== USER PROFILES ====================

  /// Ensure user profile exists in database (required for foreign keys)
  Future<void> ensureUserProfileExists(String userId) async {
    final existing = await (_database.select(_database.profiles)
      ..where((tbl) => tbl.userId.equals(userId)))
        .getSingleOrNull();

    if (existing == null) {
      // Create a minimal profile entry for this user
      await _database.into(_database.profiles).insert(
        ProfilesCompanion(
          userId: Value(userId),
          onboardingData: Value('{}'), // Empty JSON for now
        ),
        mode: InsertMode.insertOrIgnore, // Ignore if already exists
      );
    }
  }

  // ==================== CONVERSATIONS ====================

  /// Get or create a conversation between two users
  Future<Conversation> getOrCreateConversation({
    required String userId1,
    required String userId2,
  }) async {
    // First, ensure both users exist in profiles table
    await ensureUserProfileExists(userId1);
    await ensureUserProfileExists(userId2);
    // Sort user IDs to ensure consistent conversation ID regardless of order
    final sortedIds = [userId1, userId2]..sort();
    final conversationId = 'direct_${sortedIds[0]}_${sortedIds[1]}';

    // Try to get existing conversation
    final existing = await (_database.select(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .getSingleOrNull();

    if (existing != null) {
      return existing;
    }

    // Create new conversation
    final conversationData = ConversationsCompanion(
      conversationId: Value(conversationId),
      type: const Value('direct'),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    await _database.into(_database.conversations).insert(conversationData);

    // Add participants
    await _database.batch((batch) {
      batch.insert(
        _database.conversationParticipants,
        ConversationParticipantsCompanion(
          conversationId: Value(conversationId),
          userId: Value(userId1),
        ),
      );
      batch.insert(
        _database.conversationParticipants,
        ConversationParticipantsCompanion(
          conversationId: Value(conversationId),
          userId: Value(userId2),
        ),
      );
    });

    return (await (_database.select(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .getSingle());
  }

  /// Get all conversations for a user
  Stream<List<Conversation>> watchConversationsForUser(String userId) {
    final query = _database.select(_database.conversations).join([
      innerJoin(
        _database.conversationParticipants,
        _database.conversationParticipants.conversationId
            .equalsExp(_database.conversations.conversationId),
      ),
    ])
      ..where(_database.conversationParticipants.userId.equals(userId))..where(
          _database.conversations.isArchived.equals(false))
      ..orderBy([
        OrderingTerm.desc(_database.conversations.lastMessageTimestamp),
      ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return row.readTable(_database.conversations);
      }).toList();
    });
  }

  /// Get other participant(s) in a conversation
  Future<List<String>> getConversationParticipants(String conversationId, {
    String? excludeUserId,
  }) async {
    final query = _database.select(_database.conversationParticipants)
      ..where((tbl) => tbl.conversationId.equals(conversationId));

    if (excludeUserId != null) {
      query.where((tbl) => tbl.userId.isNotValue(excludeUserId));
    }

    final participants = await query.get();
    return participants.map((p) => p.userId).toList();
  }

  /// Update conversation with last message info
  Future<void> updateConversationLastMessage({
    required String conversationId,
    required String lastMessage,
    required String senderId,
    required DateTime timestamp,
    bool incrementUnread = false,
  }) async {
    final conversation = await (_database.select(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .getSingleOrNull();

    if (conversation == null) return;

    final update = ConversationsCompanion(
      lastMessage: Value(lastMessage),
      lastMessageSenderId: Value(senderId),
      lastMessageTimestamp: Value(timestamp),
      updatedAt: Value(DateTime.now()),
      unreadCount: incrementUnread
          ? Value(conversation.unreadCount + 1)
          : Value(conversation.unreadCount),
    );

    await (_database.update(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .write(update);
  }

  /// Mark conversation as read (reset unread count)
  Future<void> markConversationAsRead(String conversationId) async {
    await (_database.update(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .write(const ConversationsCompanion(
      unreadCount: Value(0),
    ));
  }

  /// Archive a conversation
  Future<void> archiveConversation(String conversationId) async {
    await (_database.update(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .write(ConversationsCompanion(
      isArchived: const Value(true),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Delete a conversation and all its messages
  Future<void> deleteConversation(String conversationId) async {
    // Delete all messages in this conversation
    await (_database.delete(_database.userChats)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .go();

    // Delete conversation participants
    await (_database.delete(_database.conversationParticipants)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .go();

    // Delete the conversation itself
    await (_database.delete(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .go();
  }

  // ==================== MESSAGES ====================

  /// Save a message to the database
  Future<int> saveMessage(ChatMessage message, String conversationId) async {
    try {
      // Get current user ID to determine if this message is sent by current user
      final currentUserId = await _userRepository.getUserId();

      // Determine if this message is sent by the current user
      final isSentByCurrentUser = message.senderId == currentUserId;
      
      // Ensure sender profile exists
      await ensureUserProfileExists(message.senderId);

      // Get recipient ID from conversation if not provided
      String? recipientId = message.recipientId.isEmpty ? null : message.recipientId;

      if (recipientId == null || recipientId.isEmpty) {
        // Extract recipient from conversation participants
        final participants = await getConversationParticipants(
          conversationId,
          excludeUserId: message.senderId,
        );
        if (participants.isNotEmpty) {
          recipientId = participants.first;
          print('🔍 Found recipient from conversation: $recipientId');
        }
      }

      // Ensure recipient profile exists before inserting
      if (recipientId != null && recipientId.isNotEmpty) {
        await ensureUserProfileExists(recipientId);
      } else {
        print('⚠️ Warning: Could not determine recipient for message ${message
            .id}');
      }

      final messageData = UserChatsCompanion(
        messageId: Value(message.id),
        conversationId: Value(conversationId),
        senderId: Value(message.senderId),
        recipientId: recipientId != null && recipientId.isNotEmpty
            ? Value(recipientId)
            : const Value.absent(),
        // Skip if empty
        encryptedContent: Value(message.encryptedTextPayload),
        decryptedContent: Value(message.plainText),
        status: Value(
            _statusToString(message.status ?? EChatMessageStatus.sending)),
        timestamp: Value(message.timestamp),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        isDeleted: const Value(false),
        // File attachment fields
        fileId: message.fileAttachment != null
            ? Value(message.fileAttachment!.fileId)
            : const Value.absent(),
        filename: message.fileAttachment != null
            ? Value(message.fileAttachment!.filename)
            : const Value.absent(),
        mimeType: message.fileAttachment != null
            ? Value(message.fileAttachment!.mimeType)
            : const Value.absent(),
        fileSize: message.fileAttachment != null
            ? Value(message.fileAttachment!.fileSize)
            : const Value.absent(),
        expiresAt: message.fileAttachment != null
            ? Value(message.fileAttachment!.expiresAt)
            : const Value.absent(),
        localPath: message.fileAttachment?.localPath != null
            ? Value(message.fileAttachment!.localPath)
            : const Value.absent(),
        isDownloaded: message.fileAttachment != null
            ? Value(message.fileAttachment!.isDownloaded)
            : const Value.absent(),
      );

      final id = await _database.into(_database.userChats).insert(messageData);

      // Update conversation last message
      String lastMessageText = message.plainText ?? '';

      // If message has file attachment but no text, show file info
      if (lastMessageText.isEmpty && message.fileAttachment != null) {
        lastMessageText = '📎 ${message.fileAttachment!.filename}';
      }
      
      // If still empty (encrypted message without plaintext), use placeholder
      if (lastMessageText.isEmpty && message.encryptedTextPayload.isNotEmpty) {
        lastMessageText = 'New message'; // Placeholder for encrypted messages
      }

      if (lastMessageText.isNotEmpty) {
        await updateConversationLastMessage(
          conversationId: conversationId,
          lastMessage: lastMessageText,
          senderId: message.senderId,
          timestamp: message.timestamp,
          incrementUnread: !isSentByCurrentUser, // Use locally calculated value
        );
      }

      return id;
    } catch (e) {
      print('❌ Error saving message to database: $e');
      rethrow;
    }
  }

  /// Update message status
  Future<void> updateMessageStatus(String messageId,
      EChatMessageStatus status) async {
    await (_database.update(_database.userChats)
      ..where((tbl) => tbl.messageId.equals(messageId)))
        .write(UserChatsCompanion(
      status: Value(_statusToString(status)),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Update decrypted content for a message
  Future<void> updateMessageDecryptedContent(String messageId,
      String decryptedContent,) async {
    await (_database.update(_database.userChats)
      ..where((tbl) => tbl.messageId.equals(messageId)))
        .write(UserChatsCompanion(
      decryptedContent: Value(decryptedContent),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Get messages for a conversation
  Stream<List<UserChat>> watchMessagesForConversation(String conversationId) {
    final query = _database.select(_database.userChats)
      ..where((tbl) => tbl.conversationId.equals(conversationId))..where((
          tbl) => tbl.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]);

    return query.watch();
  }

  /// Get recent messages (limit) for a conversation
  Future<List<UserChat>> getRecentMessages(String conversationId, {
    int limit = 50,
  }) async {
    final query = _database.select(_database.userChats)
      ..where((tbl) => tbl.conversationId.equals(conversationId))..where((
          tbl) => tbl.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
      ..limit(limit);

    final messages = await query.get();
    return messages.reversed.toList(); // Reverse to get chronological order
  }

  /// Get messages with pending status (for retry)
  Future<List<UserChat>> getPendingMessages(String userId) async {
    final query = _database.select(_database.userChats)
      ..where((tbl) => tbl.senderId.equals(userId))..where((tbl) =>
          tbl.status.isIn(['sending', 'failed']))
      ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]);

    return await query.get();
  }

  /// Soft delete a message
  Future<void> deleteMessage(String messageId) async {
    await (_database.update(_database.userChats)
      ..where((tbl) => tbl.messageId.equals(messageId)))
        .write(UserChatsCompanion(
      isDeleted: const Value(true),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Hard delete old messages (for cleanup)
  Future<int> deleteOldMessages({required Duration olderThan}) async {
    final cutoffDate = DateTime.now().subtract(olderThan);

    return await (_database.delete(_database.userChats)
      ..where((tbl) => tbl.timestamp.isSmallerThanValue(cutoffDate)))
        .go();
  }

  // ==================== CONVERSION HELPERS ====================

  /// Convert UserChat (DB model) to ChatMessage (app model)
  ChatMessage userChatToChatMessage(UserChat dbMessage, String currentUserId) {
    // Reconstruct file attachment if fields are present
    FileAttachment? fileAttachment;
    if (dbMessage.fileId != null) {
      fileAttachment = FileAttachment(
        fileId: dbMessage.fileId!,
        filename: dbMessage.filename ?? '',
        mimeType: dbMessage.mimeType ?? 'application/octet-stream',
        fileSize: dbMessage.fileSize ?? 0,
        expiresAt: dbMessage.expiresAt ?? 0,
        localPath: dbMessage.localPath,
        isDownloaded: dbMessage.isDownloaded ?? false,
      );
    }

    return ChatMessage(
      id: dbMessage.messageId,
      senderId: dbMessage.senderId,
      recipientId: dbMessage.recipientId ?? '',
      // Handle nullable recipientId
      plainText: dbMessage.decryptedContent,
      encryptedTextPayload: dbMessage.encryptedContent,
      timestamp: dbMessage.timestamp,
      status: _stringToStatus(dbMessage.status),
      isSentByCurrentUser: dbMessage.senderId == currentUserId,
      fileAttachment: fileAttachment,
    );
  }

  /// Convert list of UserChats to ChatMessages
  List<ChatMessage> userChatsToChatMessages(List<UserChat> dbMessages,
      String currentUserId,) {
    return dbMessages
        .map((db) => userChatToChatMessage(db, currentUserId))
        .toList();
  }

  // ==================== UTILITIES ====================

  /// Get total unread message count for user
  Future<int> getTotalUnreadCount(String userId) async {
    final query = _database.select(_database.conversations).join([
      innerJoin(
        _database.conversationParticipants,
        _database.conversationParticipants.conversationId
            .equalsExp(_database.conversations.conversationId),
      ),
    ])
      ..where(_database.conversationParticipants.userId.equals(userId));

    final conversations = await query.get();
    return conversations.fold<int>(
      0,
          (sum, row) =>
      sum + row
          .readTable(_database.conversations)
          .unreadCount,
    );
  }

  /// Clear all chat data (for testing/debugging)
  Future<void> clearAllChats() async {
    await (_database.delete(_database.userChats)).go();
    await (_database.delete(_database.conversationParticipants)).go();
    await (_database.delete(_database.conversations)).go();
  }

  // ==================== PRIVATE HELPERS ====================

  String _statusToString(EChatMessageStatus status) {
    return status
        .toString()
        .split('.')
        .last;
  }

  EChatMessageStatus _stringToStatus(String status) {
    return EChatMessageStatus.values.firstWhere(
          (e) =>
      e
          .toString()
          .split('.')
          .last == status,
      orElse: () => EChatMessageStatus.sent,
    );
  }
}
