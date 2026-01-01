import 'package:drift/drift.dart';

// Renamed from Users to Profiles for clarity. This is the source of truth for user IDs.
@DataClassName('Profile')
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().unique()();
  TextColumn get onboardingData => text()(); // Storing the data as a JSON string
}

/// Represents a single conversation thread between two or more users.
@DataClassName('Conversation')
class Conversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conversationId => text().unique()();

  // Last message info for conversation list
  TextColumn get lastMessage => text().nullable()();

  DateTimeColumn get lastMessageTimestamp => dateTime().nullable()();

  TextColumn get lastMessageSenderId => text().nullable()();

  // Unread count for current user
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();

  // Conversation type: 'direct' or 'group'
  TextColumn get type => text().withDefault(const Constant('direct'))();

  // Optional conversation name (for group chats)
  TextColumn get name => text().nullable()();

  // Metadata
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Soft delete
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

/// Stores the individual messages within each conversation.
@DataClassName('UserChat')
class UserChats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get messageId => text().unique()();
  // Foreign key to the conversation this message belongs to.
  TextColumn get conversationId => text().references(Conversations, #conversationId)();
  TextColumn get senderId => text().references(Profiles, #userId)();
  TextColumn get recipientId => text().nullable().references(Profiles, #userId)();

  // Store both encrypted and decrypted content
  TextColumn get encryptedContent => text()(); // The encrypted payload
  TextColumn get decryptedContent =>
      text().nullable()(); // Decrypted message (null if not yet decrypted)

  // Message status tracking
  TextColumn get status =>
      text().withDefault(const Constant(
          'sending'))(); // sending, sent, delivered, read, failed

  // Metadata
  DateTimeColumn get timestamp => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Optional: for message replies, attachments, etc.
  TextColumn get replyToMessageId => text().nullable()();

  // File attachment fields
  TextColumn get fileId => text().nullable()();

  TextColumn get filename => text().nullable()();

  TextColumn get mimeType => text().nullable()();

  IntColumn get fileSize => integer().nullable()();

  IntColumn get expiresAt => integer().nullable()();

  TextColumn get localPath => text().nullable()();

  BoolColumn get isDownloaded => boolean().nullable()();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

/// A many-to-many link table to associate users with conversations.
/// This is essential for group chats and for efficiently querying conversations for a user.
class ConversationParticipants extends Table {
  TextColumn get conversationId => text().references(Conversations, #conversationId)();
  TextColumn get userId => text().references(Profiles, #userId)();

  @override
  Set<Column> get primaryKey => {conversationId, userId};
}
