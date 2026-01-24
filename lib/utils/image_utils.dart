/// Utility class for handling image URLs with progressive loading support
class ImageUtils {
  /// Image size options supported by the backend
  static const String sizeThumb = 'thumb';
  static const String sizeFull = 'full';
  
  /// Builds an image URL with the specified size parameter
  /// 
  /// Parameters:
  /// - [baseUrl]: The base URL of the service (e.g., "https://api.example.com")
  /// - [imagePath]: The image path returned from the API (e.g., "/api/v1/images/user123/abc-123.jpg" or full URL)
  /// - [size]: The size variant to load ('thumb' for thumbnails, 'full' for full resolution)
  /// 
  /// Returns: Complete URL with size parameter (e.g., "https://api.example.com/api/v1/images/user123/abc-123.jpg?size=thumb")
  static String buildImageUrl({
    required String baseUrl,
    required String imagePath,
    String size = sizeFull,
  }) {
    // If imagePath is already a full URL (starts with http:// or https://), use it directly
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // Check if URL already has query parameters
      final separator = imagePath.contains('?') ? '&' : '?';
      return '$imagePath${separator}size=$size';
    }
    
    // Remove trailing slash from baseUrl if present
    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    
    // Construct full URL with size parameter
    return '$cleanBaseUrl$imagePath?size=$size';
  }
  
  /// Builds a thumbnail URL (300x300) for list/grid views
  static String buildThumbnailUrl({
    required String baseUrl,
    required String imagePath,
  }) {
    return buildImageUrl(baseUrl: baseUrl, imagePath: imagePath, size: sizeThumb);
  }
  
  /// Builds a full resolution URL for detail views
  static String buildFullImageUrl({
    required String baseUrl,
    required String imagePath,
  }) {
    return buildImageUrl(baseUrl: baseUrl, imagePath: imagePath, size: sizeFull);
  }
}
