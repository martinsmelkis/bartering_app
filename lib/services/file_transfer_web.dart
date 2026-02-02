/// Web-specific implementation for file downloads
/// This is only compiled on web platforms where dart:html is available

import 'dart:html' as html;
import 'dart:typed_data';

/// Trigger file download on web platform by creating a blob URL
void downloadFileOnWeb(String filename, Uint8List bytes) {
  // Create blob from bytes
  final blob = html.Blob([bytes]);

  // Create download link
  final url = html.Url.createObjectUrl(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();

  // Cleanup
  html.Url.revokeObjectUrl(url);

  print('File downloaded on web: $filename');
}