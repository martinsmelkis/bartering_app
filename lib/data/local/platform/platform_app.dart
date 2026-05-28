import 'dart:io';

import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;

import '../../../services/secure_storage_service.dart';

class PlatformInterface {
  static Future<QueryExecutor> createDatabaseConnection(
    String databaseName,
  ) async {
    final secureStorage = SecureStorageService();
    var privateKey = await secureStorage.getOwnPrivateKey();

    // If no private key exists, generate one via CryptoService
    // This handles first app launch where database is needed before full init
    if (privateKey == null || privateKey.isEmpty) {
      print('🔐 No private key found for database encryption, generating...');
      final cryptoService = await CryptoService.create();
      if (cryptoService.isReady) {
        privateKey = await secureStorage.getOwnPrivateKey();
        print('✅ Private key generated successfully');
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
      print(
        '🆕 Database file does not exist, will create new encrypted database',
      );
    }

    return NativeDatabase.createInBackground(
      dbFile,
      setup: (db) {
        // SQLite3MultipleCiphers is bundled through package:sqlite3 hooks.
        // Configure it for compatibility with databases created by SQLCipher 4.
        db.execute("pragma cipher = 'sqlcipher'");
        db.execute('pragma legacy = 4');

        // Apply the key before running any query that can read the database
        // header or schema. Unfortunately, this pragma doesn't seem to support
        // prepared statements so we inline the key.
        final escapedKey = encryptionPassword.replaceAll("'", "''");
        db.execute("pragma key = '$escapedKey'");

        // Check that we're actually running with SQLite3MultipleCiphers. This
        // must run after the key because preparing statements can touch the
        // encrypted database schema.
        try {
          db.select('select sqlite3mc_version()');
        } catch (error) {
          throw UnsupportedError(
            'This database needs to run with SQLite3MultipleCiphers, but that '
            'library is not available: $error',
          );
        }

        // Test that the key is correct by selecting from a table.
        // This will throw an exception if the key is wrong (decryption fails).
        db.execute('select count(*) from sqlite_master');
      },
    );
  }

  /// Stub method - browser storage clearing only applies to web platform
  static Future<void> clearAllBrowserStorage() async {
    // No-op on mobile platforms - database is handled separately
  }
}
