import 'dart:io';

import 'package:barter_app/utils/debug_utils.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';

import 'dart:ffi';

import '../../../services/secure_storage_service.dart';

class PlatformInterface {
  static Future<QueryExecutor> createDatabaseConnection(String databaseName) async {
    final secureStorage = SecureStorageService();
    final privateKey = await secureStorage.getOwnPrivateKey();

    if (privateKey == null || privateKey.length < 10) {
      throw Exception('Private key not found or is too short for database encryption.');
    }
    final encryptionPassword = privateKey.substring(0, 10);

    final path = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(path.path, 'app.db.enc'));

    try {
      return NativeDatabase.createInBackground(
        dbFile,
        isolateSetup: () async {
          open..overrideFor(
              OperatingSystem.android, openCipherOnAndroid)..overrideFor(
              OperatingSystem.linux,
                  () => DynamicLibrary.open('libsqlcipher.so'))..overrideFor(
              OperatingSystem.windows,
                  () => DynamicLibrary.open('sqlcipher.dll'));
        },
        setup: (db) {
          // Check that we're actually running with SQLCipher by quering the
          // cipher_version pragma.
          final result = db.select('pragma cipher_version');
          if (result.isEmpty) {
            throw UnsupportedError(
              'This database needs to run with SQLCipher, but that library is '
                  'not available!',
            );
          }

          // Then, apply the key to encrypt the database. Unfortunately, this
          // pragma doesn't seem to support prepared statements so we inline the
          // key.
          final escapedKey = encryptionPassword.replaceAll("'", "''");
          db.execute("pragma key = '$escapedKey'");

          // Test that the key is correct by selecting from a table
          try {
            db.execute('select count(*) from sqlite_master');
          } catch (e) {
            // If the key is incorrect (database corrupted or wrong key),
            // throw error so we can delete and recreate
            throw Exception('Database decryption failed: $e');
          }
        },
      );
    } catch (e) {
      // If database connection fails due to decryption error, delete and recreate
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('decryption') || 
          errorString.contains('not a database') ||
          errorString.contains('hmac check failed') ||
          errorString.contains('file is not a database') ||
          errorString.contains('sqliteexception(26)')) {
        logDebug('Database corrupted or key mismatch. Deleting and recreating...');
        logDebug('Error details: $e');
        
        // Delete the corrupted database file
        if (await dbFile.exists()) {
          await dbFile.delete();
          logDebug('✅ Corrupted database file deleted');
        }
        
        // Recursively call to create a fresh database
        logDebug('🔄 Creating fresh database with new encryption key...');
        return createDatabaseConnection(databaseName);
      }
      
      // Re-throw other errors
      logDebugError('Unexpected database error', e);
      rethrow;
    }
  }
}
