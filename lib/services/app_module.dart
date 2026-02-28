import 'dart:io';

import 'package:barter_app/data/local/app_database.dart';
import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

@module
abstract class AppModule {
  // Ensure CryptoService is ready before creating AppDatabase
  // This ensures we have encryption keys for the SQLCipher database
  @preResolve
  Future<CryptoService> get cryptoService async {
    final service = await CryptoService.create();
    return service;
  }

  // AppDatabase depends on CryptoService being ready
  @preResolve
  @singleton
  Future<AppDatabase> get appDatabase async {
    // CryptoService is already initialized by the dependency above
    try {
      final db = await AppDatabase.create();
      // Eagerly trigger database open to catch any decryption errors early
      await db.customSelect('SELECT 1').get();
      logDebug('✅ Database opened successfully');
      return db;
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      // Check for SQLCipher decryption errors
      if (errorString.contains('decryption') || 
          errorString.contains('not a database') ||
          errorString.contains('hmac check failed') ||
          errorString.contains('file is not a database') ||
          errorString.contains('sqliteexception(26)')) {
        logDebug('🔄 Database decryption failed during init. Deleting and recreating...');
        logDebug('Error details: $e');
        print('@@@@@@@@@@@@@@ sql DB Error details: $e');
        
        // Delete the corrupted database file
        final docsPath = await getApplicationDocumentsDirectory();
        final dbFile = File(p.join(docsPath.path, 'app.db.enc'));
        if (await dbFile.exists()) {
          await dbFile.delete();
          logDebug('✅ Corrupted database file deleted');
        }
        
        // Retry creating the database
        logDebug('🔄 Retrying database creation...');
        final db = await AppDatabase.create();
        await db.customSelect('SELECT 1').get();
        logDebug('✅ Fresh database created successfully');
        return db;
      }
      
      // Re-throw other errors
      logDebugError('Unexpected database error during init', e);
      rethrow;
    }
  }

}