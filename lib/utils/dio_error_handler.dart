import 'dart:convert';
import 'dart:io' show SocketException;

import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:dio/dio.dart';

/// Utility class for handling DioException errors and extracting user-friendly messages.
class DioErrorHandler {
  /// Backward-compatible generic error extractor used across older cubits.
  ///
  /// Order:
  /// 1) backend-provided message (`message`/`error`/`detail`)
  /// 2) simple status mapping for known cases
  /// 3) provided default message
  static String getErrorMessage(
    DioException exception,
    String defaultErrorMessage,
  ) {
    final backendMessage = _extractBackendErrorMessage(exception);
    if (backendMessage != null && backendMessage.trim().isNotEmpty) {
      return backendMessage.trim();
    }

    if (exception.response?.statusCode == 403) {
      return 'Transaction blocked by Server';
    }

    return defaultErrorMessage;
  }

  /// Returns a user-facing API error string in this order:
  /// 1) backend-provided message (`message`/`error`/`detail`)
  /// 2) status-code-aware localized message
  /// 3) localized fallback passed by caller
  static String getLocalizedApiErrorMessage(
    DioException exception,
    AppLocalizations l10n, {
    required String fallbackMessage,
  }) {
    final backendMessage = _extractBackendErrorMessage(exception);
    if (backendMessage != null && backendMessage.trim().isNotEmpty) {
      return backendMessage.trim();
    }

    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.receiveTimeout) {
      return l10n.apiErrorTimeout;
    }

    if (exception.error is SocketException ||
        exception.type == DioExceptionType.connectionError) {
      return l10n.apiErrorNoInternet;
    }

    switch (exception.response?.statusCode) {
      case 400:
        return l10n.apiErrorBadRequest;
      case 401:
        return l10n.apiErrorAuthSessionExpired;
      case 403:
        return l10n.apiErrorForbidden;
      case 404:
        return l10n.apiErrorNotFound;
      case 409:
        return l10n.apiErrorConflict;
      case 422:
        return l10n.apiErrorValidation;
    }

    final statusCode = exception.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return l10n.apiErrorServer;
    }

    return fallbackMessage;
  }

  static String? extractBackendErrorMessage(DioException exception) {
    return _extractBackendErrorMessage(exception);
  }

  static String? _extractBackendErrorMessage(DioException exception) {
    final data = exception.response?.data;
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      final candidate = data['message'] ?? data['error'] ?? data['detail'];
      if (candidate is String && candidate.trim().isNotEmpty) {
        return candidate;
      }
      return null;
    }

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return null;
      if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is Map<String, dynamic>) {
            final candidate = decoded['message'] ?? decoded['error'] ?? decoded['detail'];
            if (candidate is String && candidate.trim().isNotEmpty) {
              return candidate;
            }
          }
        } catch (parseError) {
          logDebugError('Error parsing error response', parseError);
        }
      }
      return trimmed;
    }

    return null;
  }
}

