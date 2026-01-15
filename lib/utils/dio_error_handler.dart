import 'dart:convert';
import 'package:dio/dio.dart';

/// Utility class for handling DioException errors and extracting error messages
class DioErrorHandler {
  // Extracts a user-friendly error message from a DioException
  //
  // This method attempts to extract error messages in the following order:
  // 1. Checks for specific HTTP status codes (e.g., 403 for blocked transactions)
  // 2. Attempts to parse the response data as JSON and extract the 'error' field
  // 3. Falls back to the provided default error message
  //
  // [exception] The DioException to handle
  // [defaultErrorMessage] The fallback message if no specific error can be extracted
  //
  // Returns a user-friendly error message string
  static String getErrorMessage(
    DioException exception,
    String defaultErrorMessage,
  ) {

    // Handle specific status codes
    if (exception.response?.statusCode == 403) {
      return 'Transaction blocked by Server';
    }

    // Extract error message from API response
    String errorMessage = defaultErrorMessage;

    if (exception.response?.data != null) {
      try {
        // Try to parse JSON response
        final data = exception.response!.data;
        if (data is Map<String, dynamic> && data.containsKey('error')) {
          errorMessage = data['error'];
        } else if (data is String) {
          // Try to parse string as JSON
          final jsonData = jsonDecode(data);
          if (jsonData is Map<String, dynamic> && jsonData.containsKey('error')) {
            errorMessage = jsonData['error'];
          }
        }
      } catch (parseError) {
        // If parsing fails, use the default error message
        print('Error parsing error response: $parseError');
      }
    }

    return errorMessage;
  }
}
