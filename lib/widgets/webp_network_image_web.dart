// ignore_for_file: uri_does_not_exist
/// Web-specific implementation using Fetch API
/// Uses dart:js_util for proper constructor calling
/// Note: This file is only used on web platforms (conditional import in webp_network_image.dart)

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:js_util' as js_util;
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// Fetches image bytes using the browser's native Fetch API
Future<Uint8List> fetchImageBytes(Uri url, Map<String, String> headers) async {
  try {
    debugPrint('🔍 WebPNetworkImage: Fetching from $url');

    // Create request init with headers
    final jsHeaders = web.Headers();
    headers.forEach((key, value) {
      jsHeaders.set(key, value);
    });

    final requestInit = web.RequestInit(
      method: 'GET',
      headers: jsHeaders,
    );

    // Fetch the image
    final response = await web.window.fetch(url.toString().toJS, requestInit).toDart;

    debugPrint('🔍 WebPNetworkImage: Response status ${response.status}');

    if (!response.ok) {
      throw Exception('Failed to fetch image: ${response.status} ${response.statusText}');
    }

    // Get the response body as ArrayBuffer
    final arrayBufferPromise = (response as JSObject).callMethod('arrayBuffer'.toJS);
    final arrayBufferResult = await (arrayBufferPromise as JSPromise<JSObject>).toDart;

    // Convert ArrayBuffer to Uint8List
    final bytes = _arrayBufferToUint8List(arrayBufferResult);

    debugPrint('🔍 WebPNetworkImage: Successfully loaded ${bytes.length} bytes');
    return bytes;
  } catch (e, stackTrace) {
    debugPrint('❌ WebPNetworkImage: Error fetching image: $e');
    debugPrint('❌ WebPNetworkImage: Stack trace: $stackTrace');
    rethrow;
  }
}

/// Convert JS ArrayBuffer to Dart Uint8List
/// Uses dart:js_util.callConstructor for proper 'new' invocation
Uint8List _arrayBufferToUint8List(JSObject arrayBuffer) {
  try {
    // Get the window object
    final window = js_util.globalThis;

    // Get Uint8Array constructor and create instance with 'new'
    final uint8ArrayConstructor = js_util.getProperty(window, 'Uint8Array');
    final uint8Array = js_util.callConstructor(uint8ArrayConstructor, [arrayBuffer]) as JSObject;

    // Get the length
    final length = (uint8Array.getProperty('length'.toJS) as JSNumber).toDartInt;
    final dartList = Uint8List(length);

    // Copy bytes using indexed access
    for (var i = 0; i < length; i++) {
      final byteValue = uint8Array.getProperty(i.toJS) as JSNumber;
      dartList[i] = byteValue.toDartInt;
    }

    return dartList;
  } catch (e) {
    debugPrint('❌ WebPNetworkImage: Error converting ArrayBuffer to bytes: $e');
    rethrow;
  }
}
