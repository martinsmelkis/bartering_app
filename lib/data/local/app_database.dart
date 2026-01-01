import 'package:barter_app/data/local/tables.dart';
import 'package:barter_app/data/local/platform/platform.dart' as platform;
import 'package:drift/drift.dart';

import 'package:flutter/foundation.dart';

part 'app_database.g.dart';

@DriftDatabase(
    tables: [Profiles, Conversations, UserChats, ConversationParticipants])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(QueryExecutor e) : super(e);

  static Future<AppDatabase> create() async {
    final executor = await _openDatabase();
    // Create an instance AppDatabase using the private constructor.
    final db = AppDatabase._(executor);
    return db;
  }

  @override
  int get schemaVersion => 4; // v4: Added file attachment fields

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
      },
      beforeOpen: (details) async {
        if (kDebugMode) {
          await customStatement('PRAGMA foreign_keys = ON');
        }
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
