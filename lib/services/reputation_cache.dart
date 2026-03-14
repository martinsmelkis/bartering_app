import 'package:barter_app/models/reviews/reputation_response.dart';

/// Simple in-memory cache for reputation data with expiration
class ReputationCache {
  static final ReputationCache _instance = ReputationCache._internal();
  factory ReputationCache() => _instance;
  ReputationCache._internal();

  final Map<String, _CacheEntry<ReputationResponse>> _reputationCache = {};
  final Map<String, _CacheEntry<List<BadgeDetail>>> _badgesCache = {};
  
  static const Duration _cacheDuration = Duration(minutes: 10);

  /// Get cached reputation data if available and not expired
  ReputationResponse? getReputation(String userId) {
    final entry = _reputationCache[userId];
    if (entry == null || entry.isExpired) {
      return null;
    }
    return entry.data;
  }

  /// Cache reputation data
  void setReputation(String userId, ReputationResponse data) {
    _reputationCache[userId] = _CacheEntry(data, DateTime.now().add(_cacheDuration));
  }

  /// Get cached badges if available and not expired
  List<BadgeDetail>? getBadges(String userId) {
    final entry = _badgesCache[userId];
    if (entry == null || entry.isExpired) {
      return null;
    }
    return entry.data;
  }

  /// Cache badges data
  void setBadges(String userId, List<BadgeDetail> badges) {
    _badgesCache[userId] = _CacheEntry(badges, DateTime.now().add(_cacheDuration));
  }

  /// Clear all cached data
  void clear() {
    _reputationCache.clear();
    _badgesCache.clear();
  }

  /// Clear cache for specific user
  void clearUser(String userId) {
    _reputationCache.remove(userId);
    _badgesCache.remove(userId);
  }
}

/// Generic cache entry with expiration
class _CacheEntry<T> {
  final T data;
  final DateTime expiresAt;

  _CacheEntry(this.data, this.expiresAt);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
