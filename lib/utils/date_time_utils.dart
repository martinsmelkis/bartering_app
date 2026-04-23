import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

/// Utility class for date and time formatting
class DateTimeUtils {
  /// Check if two dates are on the same calendar day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Format date for chat header display
  /// Returns "Today", "Yesterday", or formatted date
  static String formatChatDateHeader(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    if (isSameDay(date, now)) {
      return AppLocalizations.of(context)!.today;
    } else if (isSameDay(date, yesterday)) {
      return AppLocalizations.of(context)!.yesterday;
    } else {
      // Show date in format like "December 25, 2024"
      return DateFormat('MMMM d, y').format(date);
    }
  }

  /// Strip time from DateTime, keeping only the date part
  static DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Format time as HH:mm (24-hour format)
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Check if a date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Get relative date description (e.g., "2 days ago", "Last week")
  static String getRelativeTimeDescription(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return AppLocalizations.of(context)!.yesterday;
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }

  static String formatLastOnlineText(int? lastOnlineAtMs, AppLocalizations l10n) {
    if (lastOnlineAtMs == null || lastOnlineAtMs <= 0) {
      return '${l10n.lastOnlinePrefix} ${l10n.lastOnlineUnknown}';
    }

    final lastOnline = DateTime.fromMillisecondsSinceEpoch(lastOnlineAtMs);
    final now = DateTime.now();
    final diff = now.difference(lastOnline);

    if (diff.inMinutes < 1) {
      return '${l10n.lastOnlinePrefix} ${l10n.lastOnlineJustNow}';
    }

    if (diff.inHours < 1) {
      return '${l10n.lastOnlinePrefix} ${l10n.lastOnlineMinutesAgo(diff.inMinutes)}';
    }

    if (diff.inDays < 1) {
      return '${l10n.lastOnlinePrefix} ${l10n.lastOnlineHoursAgo(diff.inHours)}';
    }

    if (diff.inDays == 1) {
      return '${l10n.lastOnlinePrefix} ${l10n.yesterday}';
    }

    if (diff.inDays < 7) {
      return '${l10n.lastOnlinePrefix} ${l10n.lastOnlineDaysAgo(diff.inDays)}';
    }

    return '${l10n.lastOnlinePrefix} ${DateFormat('MMM d, y').format(lastOnline)}';
  }

}
