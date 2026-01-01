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
      print('@@@@@@@@@@ WARNING: The browser is missing features: ${result.missingFeatures}');
    }

    print('@@@@@@@@@@ WASM database connection created successfully.');
    return result.resolvedExecutor;
  }
}