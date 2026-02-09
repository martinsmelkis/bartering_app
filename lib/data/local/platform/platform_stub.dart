import 'package:drift/drift.dart';

class PlatformInterface {
  static Future<DatabaseConnection> createDatabaseConnection(String databaseName) =>
      throw UnsupportedError(
          'Cannot create a client without dart:html or dart:io');

  /// Stub method - browser storage clearing only applies to web platform
  static Future<void> clearAllBrowserStorage() async {
    // No-op on stub platforms
  }
}