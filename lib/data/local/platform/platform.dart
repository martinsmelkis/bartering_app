import 'package:drift/drift.dart';

import 'platform_stub.dart'
if (dart.library.io) 'platform_app.dart'
//if (dart.library.html) 'platform_web.dart';
if (dart.library.js_interop) 'platform_web.dart';

class Platform {
  static Future<QueryExecutor> createDatabaseConnection(String databaseName) =>
      PlatformInterface.createDatabaseConnection(databaseName);

  /// Clears all browser storage including IndexedDB databases.
  /// This is used when deleting a profile to ensure a clean slate.
  static Future<void> clearAllBrowserStorage() =>
      PlatformInterface.clearAllBrowserStorage();
}