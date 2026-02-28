import 'dart:io';

import 'package:barter_app/data/local/tables.dart';
import 'package:barter_app/data/local/platform/platform.dart' as platform;
import 'package:barter_app/utils/debug_utils.dart';
import 'package:drift/drift.dart';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(
    tables: [Profiles, Conversations, UserChats, ConversationParticipants])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(QueryExecutor e) : super(e);

  static Future<AppDatabase> create() async {
    try {
      final executor = await _openDatabase();
      // Create an instance AppDatabase using the private constructor.
      final db = AppDatabase._(executor);
      return db;
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      // Check for SQLCipher decryption errors
      if (errorString.contains('decryption') || 
          errorString.contains('not a database') ||
          errorString.contains('hmac check failed') ||
          errorString.contains('file is not a database') ||
          errorString.contains('sqliteexception(26)')) {
        logDebug('🔄 Database decryption failed. Deleting corrupted database and recreating...');
        logDebug('Error details: $e');
        
        // Delete the corrupted database file
        final path = await getApplicationDocumentsDirectory();
        final dbFile = File(p.join(path.path, 'app.db.enc'));
        if (await dbFile.exists()) {
          await dbFile.delete();
          logDebug('✅ Corrupted database file deleted');
        }
        
        // Retry creating the database
        logDebug('🔄 Retrying database creation...');
        final executor = await _openDatabase();
        final db = AppDatabase._(executor);
        logDebug('✅ Fresh database created successfully');
        return db;
      }
      
      // Re-throw other errors
      logDebugError('Unexpected database error', e);
      rethrow;
    }
  }

  @override
  int get schemaVersion => 7; // v7: Added transactionId to conversations

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // For development: drop and recreate all tables when schema changes
        if (from < 3) {
          // Drop all tables in reverse order (respecting foreign keys)
          await customStatement('PRAGMA foreign_keys = OFF');

          await m.deleteTable('user_chats');
          await m.deleteTable('conversation_participants');
          await m.deleteTable('conversations');

          await customStatement('PRAGMA foreign_keys = ON');

          // Recreate all tables with new schema
          await m.createAll();
        }

        // Migration from v3 to v4: Add file attachment fields
        if (from < 4) {
          await m.addColumn(userChats, userChats.fileId);
          await m.addColumn(userChats, userChats.filename);
          await m.addColumn(userChats, userChats.mimeType);
          await m.addColumn(userChats, userChats.fileSize);
          await m.addColumn(userChats, userChats.expiresAt);
          await m.addColumn(userChats, userChats.localPath);
          await m.addColumn(userChats, userChats.isDownloaded);
        }

        // Migration from v4 to v5: Add senderName field to messages
        if (from < 5) {
          await m.addColumn(userChats, userChats.senderName);
        }

        // Migration from v5 to v6: Add lastMessageSenderName to conversations
        if (from < 6) {
          await m.addColumn(conversations, conversations.lastMessageSenderName);
        }

        // Migration from v6 to v7: Add transactionId to conversations
        if (from < 7) {
          await m.addColumn(conversations, conversations.transactionId);
        }
      },
      beforeOpen: (details) async {
        // Enable foreign keys for data integrity
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

Future<QueryExecutor> _openDatabase() async {
  return LazyDatabase(() async {
    if (kIsWeb) {
      return platform.Platform.createDatabaseConnection('app.db');
    }
    return platform.Platform.createDatabaseConnection('app.db');
  });
}
