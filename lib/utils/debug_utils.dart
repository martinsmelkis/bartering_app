import 'package:flutter/foundation.dart';

/// Debug logging utilities that are completely removed in release builds.
/// 
/// These functions use kDebugMode to ensure logs are tree-shaken (removed)
/// in release builds, improving performance and security.
/// 
/// The inner debugPrint() also provides:
/// - Automatic chunking for long messages (prevents truncation)
/// - Throttling to prevent overwhelming the log system

/// Logs a debug message. Completely removed in release builds.
/// 
/// Use this instead of print() or debugPrint() for all debug logging.
/// The message will be automatically chunked if it's too long.
/// 
/// Example:
/// ```dart
/// logDebug('User authenticated: $userId');
/// logDebug('Large JSON: ${jsonEncode(data)}'); // Won't be truncated
/// ```
void logDebug(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

/// Logs an object with a label. Completely removed in release builds.
/// 
/// Example:
/// ```dart
/// logDebugObject('User data', userProfile);
/// logDebugObject('API Response', responseData);
/// ```
void logDebugObject(String label, Object? object) {
  if (kDebugMode) {
    debugPrint('$label: ${object.toString()}');
  }
}

/// Logs an error message with optional error and stack trace.
/// Completely removed in release builds.
/// 
/// For production error logging, use a proper crash reporting service
/// like Firebase Crashlytics instead.
/// 
/// Example:
/// ```dart
/// logDebugError('Failed to load data', error, stackTrace);
/// ```
void logDebugError(String message, [Object? error, StackTrace? stackTrace]) {
  if (kDebugMode) {
    debugPrint('❌ ERROR: $message');
    if (error != null) {
      debugPrint('Error details: $error');
    }
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
