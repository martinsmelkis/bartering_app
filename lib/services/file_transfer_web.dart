/// Web-specific implementation for file downloads
/// WASM-compatible using package:web

import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

/// Trigger file download on web platform by creating a blob URL
void downloadFileOnWeb(String filename, Uint8List bytes) {
  // Create blob from bytes
  final array = bytes.toJS;
  final blob = web.Blob([array].toJS, web.BlobPropertyBag(type: 'application/octet-stream'));

  // Create download link
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = filename;
  anchor.click();

  // Cleanup
  web.URL.revokeObjectURL(url);

  print('File downloaded on web: $filename');
}
