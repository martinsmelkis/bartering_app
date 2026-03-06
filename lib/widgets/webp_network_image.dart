import 'dart:ui' as ui show Codec, ImmutableBuffer;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Platform-conditional imports for HTTP
import 'webp_network_image_http.dart' if (dart.library.js_interop) 'webp_network_image_web.dart';

/// Custom ImageProvider that adds Accept: image/webp header to requests
/// This allows the server to automatically serve WebP images when available
class WebPNetworkImage extends ImageProvider<WebPNetworkImage> {
  const WebPNetworkImage(
    this.url, {
    this.scale = 1.0,
    this.headers,
  });

  /// The URL from which the image will be fetched.
  final String url;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// The HTTP headers that will be used with [http.get] to fetch the image from network.
  final Map<String, String>? headers;

  @override
  Future<WebPNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<WebPNetworkImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(WebPNetworkImage key, ImageDecoderCallback decode) {
    // Ignore: deprecated_member_use
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<WebPNetworkImage>('Image key', this),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(WebPNetworkImage key, ImageDecoderCallback decode) async {
    assert(key == this);

    // Build headers with WebP support
    final Map<String, String> requestHeaders = <String, String>{
      'Accept': 'image/webp,image/*,*/*;q=1.0',
      ...?headers,
    };

    try {
      final Uri resolved = Uri.base.resolve(key.url);
      // Use platform-specific HTTP fetch (web uses Fetch API via package:web)
      final Uint8List bytes = await fetchImageBytes(resolved, requestHeaders);

      if (bytes.isEmpty) {
        throw Exception('NetworkImage is an empty file: $resolved');
      }

      // Decode the image
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      return decode(buffer);
    } catch (e) {
      // Wrap any exceptions in a format that can be handled by the framework
      scheduleMicrotask(() {
        PaintingBinding.instance.imageCache.evict(key);
      });
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is WebPNetworkImage && other.url == url && other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() => '${objectRuntimeType(this, 'WebPNetworkImage')}("$url", scale: $scale)';
}

/// Convenience widget for displaying images with WebP support
class WebPImage extends StatelessWidget {
  const WebPImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.loadingBuilder,
    this.errorBuilder,
    this.frameBuilder,
    this.headers,
    this.scale = 1.0,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final ImageFrameBuilder? frameBuilder;
  final Map<String, String>? headers;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: WebPNetworkImage(
        imageUrl,
        scale: scale,
        headers: headers,
      ),
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder ?? _defaultErrorBuilder,
      frameBuilder: frameBuilder,
    );
  }

  Widget _defaultErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    debugPrint('❌ WebPImage error: $error');
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}
