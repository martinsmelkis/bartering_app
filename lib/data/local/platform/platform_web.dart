import 'dart:html' as html;

import 'package:barter_app/utils/debug_utils.dart';
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

class PlatformInterface {
  static Future<QueryExecutor> createDatabaseConnection(String databaseName) async {

    // The `WasmDatabase.opened` constructor is the key.
    // It handles loading the wasm file, creating the VFS, and opening the database.
    final result = await WasmDatabase.open(
      databaseName: databaseName, // The name of the database in IndexedDB
      sqlite3Uri: Uri.parse('sqlite3.wasm'), // Path to the sqlite3.wasm file
      driftWorkerUri: Uri.parse('drift_worker.js'), // Path to the drift worker
    );

    // Verify the database is working
    if (result.missingFeatures.isNotEmpty) {
      logDebug('@@@@@@@@@@ WARNING: The browser is missing features: ${result.missingFeatures}');
    }

    logDebug('@@@@@@@@@@ WASM database connection created successfully.');
    return result.resolvedExecutor;
  }

  /// Clears all browser storage including IndexedDB databases.
  /// This is used when deleting a profile to ensure a clean slate.
  static Future<void> clearAllBrowserStorage() async {
    try {
      // Clear localStorage
      html.window.localStorage.clear();
      logDebug('✅ localStorage cleared');
    } catch (e) {
      logDebug('⚠️ Failed to clear localStorage: $e');
    }

    try {
      // Clear sessionStorage
      html.window.sessionStorage.clear();
      logDebug('✅ sessionStorage cleared');
    } catch (e) {
      logDebug('⚠️ Failed to clear sessionStorage: $e');
    }

    try {
      // Delete IndexedDB databases used by the app
      final databases = ['app.db', 'app.db.enc', 'drift_worker'];
      for (final dbName in databases) {
        try {
          await html.window.indexedDB?.deleteDatabase(dbName);
          logDebug('✅ IndexedDB database deleted: $dbName');
        } catch (e) {
          logDebug('⚠️ Failed to delete IndexedDB database $dbName: $e');
        }
      }
    } catch (e) {
      logDebug('⚠️ Failed to clear IndexedDB: $e');
    }
  }
}