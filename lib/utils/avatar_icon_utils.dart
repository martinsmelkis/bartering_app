import 'dart:convert';

import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:flutter/services.dart';

class AvatarIconUtils {
  static const int avatarCount = 29;

  static String iconIdFromAssetPath(String assetPath) {
    final match = RegExp(r'path(\d+)\.svg$').firstMatch(assetPath);
    final index = int.tryParse(match?.group(1) ?? '') ?? 1;
    return 'avatar_icon_$index';
  }

  static String? assetPathFromIconId(String? iconId) {
    final normalized = iconId?.trim();
    if (normalized == null || normalized.isEmpty) return null;

    final match = RegExp(r'avatar_icon_(\d+)$').firstMatch(normalized);
    if (match == null) return null;

    final index = int.tryParse(match.group(1) ?? '');
    if (index == null) return null;

    final clamped = index.clamp(1, avatarCount);
    return 'assets/icons/avatars/path$clamped.svg';
  }

  static String deterministicFallbackAssetPath(String userId) {
    final index = (userId.hashCode.abs() % avatarCount) + 1;
    return 'assets/icons/avatars/path$index.svg';
  }

  static Future<String> resolveSvgForProfile(UserProfileData profile) async {
    final profileAvatarIcon = profile.profileAvatarIcon?.trim();
    if (profileAvatarIcon != null && profileAvatarIcon.isNotEmpty) {
      if (profileAvatarIcon.contains('<svg')) {
        return profileAvatarIcon;
      }
      if (profileAvatarIcon.startsWith('data:image/svg+xml;base64,')) {
        final encoded = profileAvatarIcon.split(',').last;
        return utf8.decode(base64Decode(encoded), allowMalformed: true);
      }
    }

    final byIdPath = assetPathFromIconId(profile.profileAvatarIconId);
    if (byIdPath != null) {
      try {
        return await rootBundle.loadString(byIdPath);
      } catch (_) {
        // Fall back to deterministic UUID/userId based avatar below.
      }
    }

    final fallback = deterministicFallbackAssetPath(profile.userId);
    return await rootBundle.loadString(fallback);
  }
}
