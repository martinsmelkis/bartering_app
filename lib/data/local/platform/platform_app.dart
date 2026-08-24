import 'dart:io';

import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

import 'package:path/path.dart' as p;

import '../../../services/secure_storage_service.dart';

class _SqliteMultipleCiphersUnavailable implements Exception {
  final Object cause;

  const _SqliteMultipleCiphersUnavailable(this.cause);
}

class PlatformInterface {
  static Future<QueryExecutor> createDatabaseConnection(
    String databaseName,
  ) async {
    final secureStorage = SecureStorageService();
    var privateKey = await secureStorage.getOwnPrivateKey();

    // If no private key exists, generate one via CryptoService
    // This handles first app launch where database is needed before full init
    if (privateKey == null || privateKey.isEmpty) {
      logDebug(
        '🔐 No private key found for database encryption, generating...',
      );
      final cryptoService = await CryptoService.create();
      if (cryptoService.isReady) {
        privateKey = await secureStorage.getOwnPrivateKey();
        logDebug('✅ Private key generated successfully');
      }
    }

    if (privateKey == null || privateKey.length < 10) {
      throw Exception(
        'Private key not found or is too short for database encryption.',
      );
    }
    final encryptionPassword = privateKey.substring(0, 10);

    final path = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(path.path, 'app.db.enc'));

    // Check if database file exists - if not, we're creating fresh (no decryption needed)
    final isNewDatabase = !await dbFile.exists();
    if (isNewDatabase) {
      logDebug(
        '🆕 Database file does not exist, will create new encrypted database',
      );
    }

    if (!kReleaseMode) {
      if (Platform.isIOS) {
        logDebug(
          '⚠️ Using an unencrypted iOS debug/profile database to avoid '
          'sqlite3mc simulator native-asset loading issues.',
        );
        return _createUnencryptedDevelopmentDatabase(path.path, databaseName);
      }

      try {
        return NativeDatabase.createInBackground(
          dbFile,
          setup: (db) => _configureEncryptedDatabase(db, encryptionPassword),
        );
      } on _SqliteMultipleCiphersUnavailable catch (error) {
        logDebug(
          '⚠️ SQLite3MultipleCiphers unavailable in this debug/profile runtime. '
          'Using an unencrypted simulator/dev database instead: ${error.cause}',
        );
        return _createUnencryptedDevelopmentDatabase(path.path, databaseName);
      }
    }

    return NativeDatabase.createInBackground(
      dbFile,
      setup: (db) => _configureEncryptedDatabase(db, encryptionPassword),
    );
  }

  static void _configureEncryptedDatabase(
    sqlite3.Database db,
    String encryptionPassword,
  ) {
    // SQLite3MultipleCiphers is bundled through package:sqlite3 hooks.
    // Configure it for compatibility with databases created by SQLCipher 4.
    db.execute("pragma cipher = 'sqlcipher'");
    db.execute('pragma legacy = 4');

    // Apply the key before running any query that can read the database header
    // or schema. This pragma doesn't support prepared statements, so inline it.
    final escapedKey = encryptionPassword.replaceAll("'", "''");
    db.execute("pragma key = '$escapedKey'");

    // Check that we're actually running with SQLite3MultipleCiphers. This must
    // run after the key because preparing statements can touch the schema.
    try {
      db.select('select sqlite3mc_version()');
    } catch (error) {
      if (!kReleaseMode) {
        throw _SqliteMultipleCiphersUnavailable(error);
      }
      throw UnsupportedError(
        'This database needs to run with SQLite3MultipleCiphers, but that '
        'library is not available: $error',
      );
    }

    // Test that the key is correct by selecting from a table.
    // This will throw if the key is wrong (decryption fails).
    db.execute('select count(*) from sqlite_master');
  }

  static QueryExecutor _createUnencryptedDevelopmentDatabase(
    String documentsPath,
    String databaseName,
  ) {
    final plainDbFile = File(p.join(documentsPath, '$databaseName.dev.sqlite'));
    return NativeDatabase.createInBackground(plainDbFile);
  }

  /// Stub method - browser storage clearing only applies to web platform
  static Future<void> clearAllBrowserStorage() async {
    // No-op on mobile platforms - database is handled separately
  }
}
