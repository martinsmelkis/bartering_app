import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'webp_network_image.dart';

/// A full-screen image viewer that supports zooming, panning, and swiping between multiple images
/// Supports both network URLs and local file paths
class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String? heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.heroTag,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    
    for (var i = 0; i < widget.imageUrls.length; i++) {
      // Evict any cached version of this image URL to force fresh fetch
      // This ensures we get the full-resolution version, not a cached thumbnail
      if (widget.imageUrls[i].startsWith('http://') || widget.imageUrls[i].startsWith('https://')) {
        try {
          final provider = WebPNetworkImage(widget.imageUrls[i]);
          provider.evict();
          print('  ✓ Evicted cached image for fresh load');
        } catch (e) {
          print('  ⚠️ Could not evict cache: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Helper to determine the image provider based on the path
  ImageProvider _getImageProvider(String path) {
    print('🔍 _getImageProvider called with path: $path');
    
    // Check if it's a network URL
    if (path.startsWith('http://') || path.startsWith('https://')) {
      print('  → Using WebPNetworkImage for URL: $path');
      // Use WebPNetworkImage which adds Accept: image/webp header
      // This ensures the full-res image isn't replaced by cached thumbnail
      return WebPNetworkImage(path, scale: 1.0);
    }
    // For web platform, treat paths as network URLs (blob URLs)
    else if (kIsWeb) {
      print('  → Using WebPNetworkImage (web mode)');
      return WebPNetworkImage(path, scale: 1.0);
    }
    // For mobile/desktop, treat as file path
    else {
      print('  → Using FileImage for local file');
      return FileImage(File(path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image gallery with zoom capability
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: _getImageProvider(widget.imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                heroAttributes: widget.heroTag != null
                    ? PhotoViewHeroAttributes(tag: '${widget.heroTag}_$index')
                    : null,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            itemCount: widget.imageUrls.length,
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null
                    ? null
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),
          ),

          // Image counter (only show if multiple images)
          if (widget.imageUrls.length > 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${widget.imageUrls.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
