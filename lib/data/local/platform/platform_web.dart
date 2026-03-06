import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:barter_app/utils/debug_utils.dart';
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:web/web.dart' as web;

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
      web.window.localStorage.clear();
      logDebug('✅ localStorage cleared');
    } catch (e) {
      logDebug('⚠️ Failed to clear localStorage: $e');
    }

    try {
      // Clear sessionStorage
      web.window.sessionStorage.clear();
      logDebug('✅ sessionStorage cleared');
    } catch (e) {
      logDebug('⚠️ Failed to clear sessionStorage: $e');
    }

    try {
      // Delete IndexedDB databases used by the app
      final databases = ['app.db', 'app.db.enc', 'drift_worker'];
      for (final dbName in databases) {
        try {
          // Use JS interop to call deleteDatabase
          final idb = web.window.indexedDB;
          if (idb != null) {
            final request = idb.deleteDatabase(dbName);
            // Wait for the request to complete using a completer
            await _awaitRequest(request);
            logDebug('✅ IndexedDB database deleted: $dbName');
          }
        } catch (e) {
          logDebug('⚠️ Failed to delete IndexedDB database $dbName: $e');
        }
      }
    } catch (e) {
      logDebug('⚠️ Failed to clear IndexedDB: $e');
    }
  }

  /// Helper to await an IDBRequest using JS interop
  static Future<void> _awaitRequest(web.IDBRequest request) {
    final completer = Completer<void>();
    
    // Use inline JS function for event handling
    final successHandler = (web.Event event) {
      completer.complete();
    }.toJS;
    
    final errorHandler = (web.Event event) {
      completer.completeError('IndexedDB operation failed');
    }.toJS;
    
    request.addEventListener('success', successHandler);
    request.addEventListener('error', errorHandler);
    
    return completer.future;
  }
}