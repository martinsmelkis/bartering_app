/// Stub implementation for non-web platforms
/// This is only compiled on mobile/desktop platforms

import 'dart:typed_data';

/// Stub implementation - not called on non-web platforms
void downloadFileOnWeb(String filename, Uint8List bytes) {
  // This should never be called on non-web platforms
  throw UnimplementedError('Web download is only available on web platform');
}