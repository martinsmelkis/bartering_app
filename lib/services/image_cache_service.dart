import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// Application-wide cache for decrypted image previews
/// Prevents re-downloading and re-decoding images across rebuilds
class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  // Cache storage: fileId -> decrypted image bytes
  final Map<String, Uint8List> _cache = {};
  
  // LRU tracking: maintain order of access
  final List<String> _accessOrder = [];
  
  // Platform-specific limits
  static const int _maxCachedImagesWeb = 10; // Lower limit on web
  static const int _maxCachedImagesNative = 30; // Higher on native
  
  /// Get maximum cache size based on platform
  int get _maxCacheSize => kIsWeb ? _maxCachedImagesWeb : _maxCachedImagesNative;

  /// Check if an image is cached
  bool isCached(String fileId) {
    return _cache.containsKey(fileId);
  }

  /// Get cached image bytes
  Uint8List? getImage(String fileId) {
    if (_cache.containsKey(fileId)) {
      // Update access order (move to end = most recently used)
      _accessOrder.remove(fileId);
      _accessOrder.add(fileId);
      
      if (kDebugMode) {
        print('🖼️  [ImageCache] HIT: $fileId');
      }
      return _cache[fileId];
    }
    
    if (kDebugMode) {
      print('🖼️  [ImageCache] MISS: $fileId');
    }
    return null;
  }

  /// Add image to cache
  void cacheImage(String fileId, Uint8List bytes) {
    // Don't cache if already exists
    if (_cache.containsKey(fileId)) {
      // Just update access order
      _accessOrder.remove(fileId);
      _accessOrder.add(fileId);
      return;
    }

    // Add to cache
    _cache[fileId] = bytes;
    _accessOrder.add(fileId);

    if (kDebugMode) {
      print('🖼️  [ImageCache] STORED: $fileId (${bytes.length} bytes)');
    }

    // Evict oldest if over limit
    _evictIfNeeded();
  }

  /// Evict least recently used items if cache is full
  void _evictIfNeeded() {
    while (_accessOrder.length > _maxCacheSize) {
      final oldestFileId = _accessOrder.removeAt(0);
      final bytes = _cache.remove(oldestFileId);
      
      if (kDebugMode) {
        print('🗑️  [ImageCache] EVICTED: $oldestFileId (${bytes?.length ?? 0} bytes)');
      }
    }
  }

  /// Remove specific image from cache
  void removeImage(String fileId) {
    _cache.remove(fileId);
    _accessOrder.remove(fileId);
    
    if (kDebugMode) {
      print('🖼️  [ImageCache] REMOVED: $fileId');
    }
  }

  /// Clear entire cache
  void clear() {
    final count = _cache.length;
    _cache.clear();
    _accessOrder.clear();
    
    if (kDebugMode) {
      print('🖼️  [ImageCache] CLEARED: $count images removed');
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    int totalBytes = 0;
    for (final bytes in _cache.values) {
      totalBytes += bytes.length;
    }
    
    return {
      'count': _cache.length,
      'maxSize': _maxCacheSize,
      'totalBytes': totalBytes,
      'totalMB': (totalBytes / (1024 * 1024)).toStringAsFixed(2),
    };
  }

  /// Print cache statistics
  void printStats() {
    final stats = getStats();
    if (kDebugMode) {
      print('📊 [ImageCache] Stats: ${stats['count']}/${stats['maxSize']} images, ${stats['totalMB']} MB');
    }
  }
}
