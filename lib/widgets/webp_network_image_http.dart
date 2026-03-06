/// Native implementation using dart:io and package:http
/// For mobile and desktop platforms

import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Fetches image bytes using the http package (native platforms only)
Future<Uint8List> fetchImageBytes(Uri url, Map<String, String> headers) async {
  final client = http.Client();
  try {
    final response = await client.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw HttpException(
        'Failed to load image: ${response.statusCode}',
        uri: url,
      );
    }

    return response.bodyBytes;
  } finally {
    client.close();
  }
}
