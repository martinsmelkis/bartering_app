import 'package:barter_app/data/local/app_database.dart';
import 'package:barter_app/models/chat/chat_message.dart';
import 'package:barter_app/models/chat/e_chat_message_status.dart';
import 'package:barter_app/models/chat/file_attachment.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/utils/debug_utils.dart';
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
  /// Handles race conditions gracefully when called concurrently
  Future<void> ensureUserProfileExists(String userId) async {
    if (userId.isEmpty) {
      logDebug('⚠️ Cannot create profile for empty userId');
      return;
    }
    
    // Fast path: check if exists first
    final existing = await (_database.select(_database.profiles)
      ..where((tbl) => tbl.userId.equals(userId)))
        .getSingleOrNull();

    if (existing != null) {
      return; // Already exists, quick return
    }

    // Create profile with conflict handling for race conditions
    try {
      await _database.into(_database.profiles).insert(
        ProfilesCompanion(
          userId: Value(userId),
          onboardingData: const Value('{}'),
        ),
        mode: InsertMode.insertOrIgnore, // ✅ Key: ignore if already exists
      );
      logDebug('✅ Profile ensured for user: $userId');
    } catch (e) {
      // If insertOrIgnore still fails (shouldn't happen), check again
      if (e.toString().contains('UNIQUE constraint')) {
        logDebug('⚠️ Profile race condition resolved for: $userId');
        return; // Someone else created it, that's fine
      }
      // Re-throw actual unexpected errors
      logDebugError('Error creating profile for user $userId', e);
      rethrow;
    }
  }

  // ==================== CONVERSATIONS ====================

  /// Get or create a conversation between two users
  Future<Conversation> getOrCreateConversation({
    required String userId1,
    required String userId2,
    String? transactionId,
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
      // If transaction ID is provided and different from existing, update it
      if (transactionId != null && existing.transactionId != transactionId) {
        await (_database.update(_database.conversations)
          ..where((tbl) => tbl.conversationId.equals(conversationId)))
            .write(ConversationsCompanion(
          transactionId: Value(transactionId),
          updatedAt: Value(DateTime.now()),
        ));
        // Return updated conversation
        return (await (_database.select(_database.conversations)
          ..where((tbl) => tbl.conversationId.equals(conversationId)))
            .getSingle());
      }
      return existing;
    }

    // Create new conversation
    final conversationData = ConversationsCompanion(
      conversationId: Value(conversationId),
      type: const Value('direct'),
      transactionId: transactionId != null ? Value(transactionId) : const Value.absent(),
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
    String? senderName,
    required DateTime timestamp,
    bool incrementUnread = false,
  }) async {
    final conversation = await (_database.select(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .getSingleOrNull();

    if (conversation == null) return;

    final newUnreadCount = incrementUnread
        ? conversation.unreadCount + 1
        : conversation.unreadCount;

    logDebug('📊 Updating conversation $conversationId: unreadCount ${conversation.unreadCount} -> $newUnreadCount (incrementUnread: $incrementUnread)');

    final update = ConversationsCompanion(
      lastMessage: Value(lastMessage),
      lastMessageSenderId: Value(senderId),
      lastMessageSenderName: senderName != null && senderName.isNotEmpty
          ? Value(senderName)
          : const Value.absent(),
      lastMessageTimestamp: Value(timestamp),
      updatedAt: Value(DateTime.now()),
      unreadCount: Value(newUnreadCount),
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

  /// Get the transaction ID associated with a conversation
  Future<String?> getConversationTransactionId(String conversationId) async {
    final conversation = await (_database.select(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .getSingleOrNull();

    return conversation?.transactionId;
  }

  /// Set or update the transaction ID for a conversation
  Future<void> setConversationTransactionId({
    required String conversationId,
    required String transactionId,
  }) async {
    await (_database.update(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .write(ConversationsCompanion(
      transactionId: Value(transactionId),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Clear the transaction ID from a conversation
  Future<void> clearConversationTransactionId(String conversationId) async {
    await (_database.update(_database.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .write(ConversationsCompanion(
      transactionId: const Value(null),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Get conversation by transaction ID
  Future<Conversation?> getConversationByTransactionId(String transactionId) async {
    return await (_database.select(_database.conversations)
      ..where((tbl) => tbl.transactionId.equals(transactionId)))
        .getSingleOrNull();
  }

  // ==================== MESSAGES ====================

  /// Save a message to the database
  /// Handles missing profiles/conversations gracefully
  Future<int> saveMessage(ChatMessage message, String conversationId) async {
    try {
      // Get current user ID to determine if this message is sent by current user
      final currentUserId = await _userRepository.getUserId() ?? '';

      if (currentUserId.isEmpty) {
        throw Exception('Current user ID not found');
      }

      // Validate conversationId is not empty or "Unknown"
      if (conversationId.isEmpty || conversationId == 'Unknown') {
        logDebug('⚠️ Invalid conversationId: $conversationId. Attempting to determine correct ID...');
        
        // Try to determine the correct conversation ID from message
        final otherUserId = message.senderId == currentUserId 
            ? message.recipientId 
            : message.senderId;
            
        if (otherUserId.isNotEmpty) {
          final sortedIds = [currentUserId, otherUserId]..sort();
          conversationId = 'direct_${sortedIds[0]}_${sortedIds[1]}';
          logDebug('🔧 Determined conversation ID: $conversationId');
        } else {
          throw Exception('Cannot determine conversation ID - no valid recipient');
        }
      }

      // Determine if this message is sent by the current user
      final isSentByCurrentUser = message.senderId == currentUserId;

      logDebug('💬 Saving message: ${message.id}, conversation: $conversationId');
      
      // If message has a transactionId, link it to the conversation
      if (message.transactionId != null && message.transactionId!.isNotEmpty) {
        logDebug('🔗 Message has transactionId: ${message.transactionId}, linking to conversation');
        final conversation = await (_database.select(_database.conversations)
          ..where((tbl) => tbl.conversationId.equals(conversationId)))
            .getSingleOrNull();
        
        if (conversation != null && conversation.transactionId != message.transactionId) {
          await setConversationTransactionId(
            conversationId: conversationId,
            transactionId: message.transactionId!,
          );
          logDebug('✅ Conversation linked to transaction: ${message.transactionId}');
        }
      }

      // Verify conversation exists, recreate if needed
      final conversation = await (_database.select(_database.conversations)
        ..where((tbl) => tbl.conversationId.equals(conversationId)))
          .getSingleOrNull();

      if (conversation == null) {
        logDebug('⚠️ Conversation not found: $conversationId. Recreating...');
        try {
          // For direct conversations, there are only two participants: sender and recipient
          // Use the message sender and current user to recreate
          String otherUserId;

          if (message.senderId == currentUserId) {
            // Message is from current user, need recipient
            if (message.recipientId.isNotEmpty) {
              otherUserId = message.recipientId;
            } else {
              throw Exception('Recipient ID is empty in message');
            }
          } else {
            // Message is from other user, sender is the other participant
            otherUserId = message.senderId;
          }

          await getOrCreateConversation(
            userId1: currentUserId,
            userId2: otherUserId,
          );
          logDebug('✅ Conversation recreated successfully with user: $otherUserId');
        } catch (e) {
          logDebugError('Failed to recreate conversation', e);
          throw Exception('Failed to recreate conversation: $e');
        }
      }

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
          logDebug('🔍 Found recipient from conversation: $recipientId');
        }
      }

      // Ensure recipient profile exists before inserting
      if (recipientId != null && recipientId.isNotEmpty) {
        await ensureUserProfileExists(recipientId);
      } else {
        logDebug('⚠️ Warning: Could not determine recipient for message ${message
            .id}');
      }

      // Verify both profiles exist before insertion
      final senderProfile = await (_database.select(_database.profiles)
        ..where((tbl) => tbl.userId.equals(message.senderId)))
          .getSingleOrNull();

      if (senderProfile == null) {
        throw Exception('Sender profile does not exist: ${message.senderId}');
      }

      if (recipientId != null) {
        final recipientProfile = await (_database.select(_database.profiles)
          ..where((tbl) => tbl.userId.equals(recipientId!)))
            .getSingleOrNull();

        if (recipientProfile == null) {
          throw Exception('Recipient profile does not exist: $recipientId');
        }
      }

      logDebug('✅ All profiles verified, inserting message...');

      // Check if message already exists to avoid duplicate insert attempts
      final existingMessage = await (_database.select(_database.userChats)
        ..where((tbl) => tbl.messageId.equals(message.id)))
          .getSingleOrNull();
      
      if (existingMessage != null) {
        logDebug('⚠️ Message ${message.id} already exists, updating instead of inserting');
        // Update existing message (e.g., status might have changed)
        await _database.update(_database.userChats)
          ..where((tbl) => tbl.messageId.equals(message.id))
          ..write(UserChatsCompanion(
            status: Value(_statusToString(message.status ?? EChatMessageStatus.sending)),
            updatedAt: Value(DateTime.now()),
          ));
        return existingMessage.id;
      }

      final messageData = UserChatsCompanion(
        messageId: Value(message.id),
        conversationId: Value(conversationId),
        senderId: Value(message.senderId),
        senderName: message.senderName != null && message.senderName!.isNotEmpty
            ? Value(message.senderName!)
            : const Value.absent(),
        recipientId: recipientId != null && recipientId.isNotEmpty
            ? Value(recipientId)
            : const Value.absent(),
        // Skip if empty
        encryptedContent: Value(message.encryptedTextPayload),
        decryptedContent: message.plainText != null && message.plainText!.isNotEmpty
            ? Value(message.plainText!)
            : const Value.absent(),
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

      final id = await _database.into(_database.userChats).insert(messageData, mode: InsertMode.insertOrReplace);

      // Update conversation last message
      String lastMessageText;

      // If message has file attachment, show file info
      if (message.fileAttachment != null) {
        lastMessageText = '📎 ${message.fileAttachment!.filename}';
      }
      // If decrypted text is available, use it
      else if (message.plainText != null && message.plainText!.isNotEmpty) {
        lastMessageText = message.plainText!;
      }
      // If encrypted message without decrypted text, use placeholder
      else if (message.encryptedTextPayload.isNotEmpty) {
        lastMessageText = '🔒 Encrypted message'; // Placeholder for encrypted messages awaiting decryption
      }
      // Otherwise empty
      else {
        lastMessageText = '';
      }

      if (lastMessageText.isNotEmpty) {
        await updateConversationLastMessage(
          conversationId: conversationId,
          lastMessage: lastMessageText,
          senderId: message.senderId,
          senderName: message.senderName,
          timestamp: message.timestamp,
          incrementUnread: !isSentByCurrentUser, // Use locally calculated value
        );
      }

      return id;
    } catch (e) {
      logDebugError('Error saving message to database', e);
      rethrow;
    }
  }

  /// Update message status
  /// Handles both client-generated IDs and server-generated IDs
  Future<void> updateMessageStatus(String messageId,
      EChatMessageStatus status) async {
    logDebug('🔄 Attempting to update message status: messageId=$messageId, status=$status');
    
    // Try exact messageId match first
    final exactMatchCount = await (_database.update(_database.userChats)
      ..where((tbl) => tbl.messageId.equals(messageId)))
        .write(UserChatsCompanion(
      status: Value(_statusToString(status)),
      updatedAt: Value(DateTime.now()),
    ));
    
    if (exactMatchCount > 0) {
      logDebug('✅ Updated $exactMatchCount message(s) with exact ID match');
      return;
    }
    
    // If no exact match and this looks like a server UUID (contains hyphens),
    // try to find messages by timestamp proximity (within last 30 seconds)
    // This is a fallback for when server ID doesn't match client ID
    if (messageId.contains('-')) {
      logDebug('⚠️ No exact match for server UUID, trying timestamp-based fallback');
      final recentTime = DateTime.now().subtract(const Duration(seconds: 30));
      
      // Find recent messages that can be updated to this status
      // For READ status: look for delivered messages
      // For DELIVERED status: look for sent messages
      // For SENT status: look for sending messages
      final query = _database.select(_database.userChats)
        ..where((tbl) => tbl.timestamp.isBiggerOrEqualValue(recentTime))
        ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);
      
      final recentMessages = await query.get();
      
      // Filter messages that can be updated to the target status
      final eligibleMessages = recentMessages.where((msg) {
        final currentStatus = _stringToStatus(msg.status);
        // Can only progress forward: sending -> sent -> delivered -> read
        return (status == EChatMessageStatus.sent && currentStatus == EChatMessageStatus.sending) ||
               (status == EChatMessageStatus.delivered && 
                (currentStatus == EChatMessageStatus.sent || currentStatus == EChatMessageStatus.sending)) ||
               (status == EChatMessageStatus.read && 
                (currentStatus == EChatMessageStatus.delivered || currentStatus == EChatMessageStatus.sent));
      }).toList();
      
      if (eligibleMessages.isNotEmpty) {
        // Use the most recent eligible message
        final targetMessage = eligibleMessages.first;
        logDebug('🎯 Found eligible message ${targetMessage.messageId} with status ${targetMessage.status} -> updating to $status');
        
        final fallbackCount = await (_database.update(_database.userChats)
          ..where((tbl) => tbl.messageId.equals(targetMessage.messageId)))
            .write(UserChatsCompanion(
          status: Value(_statusToString(status)),
          updatedAt: Value(DateTime.now()),
        ));
        logDebug('✅ Updated $fallbackCount message(s) using timestamp fallback');
        return;
      } else {
        logDebug('⚠️ No eligible messages found. Recent messages statuses: ${recentMessages.map((m) => m.status).join(", ")}');
      }
    }
    
    logDebug('⚠️ No messages updated for messageId: $messageId');
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

  /// Get encrypted messages from a specific sender that haven't been decrypted yet
  Future<List<UserChat>> getEncryptedMessages({
    required String conversationId,
    required String senderId,
  }) async {
    final query = _database.select(_database.userChats)
      ..where((tbl) => tbl.conversationId.equals(conversationId))
      ..where((tbl) => tbl.senderId.equals(senderId))
      ..where((tbl) => tbl.decryptedContent.isNull())
      ..where((tbl) => tbl.encryptedContent.isNotValue(''));

    return await query.get();
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
    try {
      // Reconstruct file attachment if fields are present
      FileAttachment? fileAttachment;
      if (dbMessage.fileId != null) {
        try {
          fileAttachment = FileAttachment(
            fileId: dbMessage.fileId!,
            filename: dbMessage.filename ?? '',
            mimeType: dbMessage.mimeType ?? 'application/octet-stream',
            fileSize: dbMessage.fileSize ?? 0,
            expiresAt: dbMessage.expiresAt ?? 0,
            localPath: dbMessage.localPath,
            isDownloaded: dbMessage.isDownloaded ?? false,
          );
        } catch (e) {
          logDebug('⚠️ Error creating FileAttachment: $e');
          // Continue without file attachment
        }
      }

      EChatMessageStatus convertedStatus;
      try {
        convertedStatus = _stringToStatus(dbMessage.status);
      } catch (e) {
        logDebug('⚠️ Error converting status "${dbMessage.status}": $e, using "sent" as default');
        convertedStatus = EChatMessageStatus.sent;
      }

      // Determine plainText: use decryptedContent if available, otherwise null
      // (null indicates encrypted message awaiting public key)
      final String? plainText;
      if (dbMessage.decryptedContent != null && dbMessage.decryptedContent!.isNotEmpty) {
        plainText = dbMessage.decryptedContent;
      } else {
        // Null indicates encrypted but not yet decrypted
        plainText = null;
      }

      return ChatMessage(
        id: dbMessage.messageId,
        senderId: dbMessage.senderId,
        senderName: dbMessage.senderName,
        recipientId: dbMessage.recipientId ?? '',
        plainText: plainText,
        encryptedTextPayload: dbMessage.encryptedContent,
        timestamp: dbMessage.timestamp,
        status: convertedStatus,
        isSentByCurrentUser: dbMessage.senderId == currentUserId,
        fileAttachment: fileAttachment,
      );
    } catch (e) {
      logDebug('❌ Critical error in userChatToChatMessage: $e');
      rethrow; // Let the caller handle this
    }
  }

  /// Convert list of UserChats to ChatMessages
  List<ChatMessage> userChatsToChatMessages(List<UserChat> dbMessages,
      String currentUserId,) {
    final List<ChatMessage> convertedMessages = [];
    
    for (final db in dbMessages) {
      try {
        final chatMessage = userChatToChatMessage(db, currentUserId);
        convertedMessages.add(chatMessage);
      } catch (e) {
        logDebug('❌ Error converting UserChat to ChatMessage: $e');
        logDebug('   Message ID: ${db.messageId}, Sender: ${db.senderId}');
        // Skip this message but continue with others
        continue;
      }
    }
    
    logDebug('✅ Converted ${convertedMessages.length}/${dbMessages.length} messages successfully');
    return convertedMessages;
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
