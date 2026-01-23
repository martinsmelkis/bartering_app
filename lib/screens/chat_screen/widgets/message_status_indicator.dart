import 'package:flutter/material.dart';
import '../../../models/chat/e_chat_message_status.dart';

/// Widget that displays message status indicators (✓, ✓✓, or blue ✓✓)
/// Following WhatsApp-style conventions
class MessageStatusIndicator extends StatelessWidget {
  final EChatMessageStatus? status;
  final Color? color;
  final double size;

  const MessageStatusIndicator({
    super.key,
    required this.status,
    this.color,
    this.size = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    if (status == null || status == EChatMessageStatus.sending) {
      // Sending - show a clock icon
      return Icon(
        Icons.access_time,
        size: size,
        color: color ?? Colors.grey[600],
      );
    }

    return Icon(
      _getIconForStatus(status!),
      size: size,
      color: _getColorForStatus(status!, color),
    );
  }

  IconData _getIconForStatus(EChatMessageStatus status) {
    switch (status) {
      case EChatMessageStatus.sending:
        return Icons.access_time; // Clock icon
      case EChatMessageStatus.sent:
        return Icons.check; // Single checkmark
      case EChatMessageStatus.delivered:
        return Icons.done_all; // Double checkmark
      case EChatMessageStatus.read:
        return Icons.done_all; // Double checkmark (will be blue)
    }
  }

  Color _getColorForStatus(EChatMessageStatus status, Color? defaultColor) {
    switch (status) {
      case EChatMessageStatus.sending:
      case EChatMessageStatus.sent:
      case EChatMessageStatus.delivered:
        return defaultColor ?? Colors.grey[600]!;
      case EChatMessageStatus.read:
        return Colors.blue; // Blue for read
    }
  }
}

/// Widget for displaying compact message status (for message bubbles)
class CompactMessageStatus extends StatelessWidget {
  final EChatMessageStatus? status;
  final DateTime timestamp;
  final TextStyle? timeStyle;

  const CompactMessageStatus({
    super.key,
    required this.status,
    required this.timestamp,
    this.timeStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTimeStyle = TextStyle(
      fontSize: 11,
      color: Colors.grey[600],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(timestamp),
          style: timeStyle ?? defaultTimeStyle,
        ),
        const SizedBox(width: 4),
        MessageStatusIndicator(
          status: status,
          size: 14,
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Status description text for detailed views
class MessageStatusText extends StatelessWidget {
  final EChatMessageStatus? status;

  const MessageStatusText({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _getStatusText(),
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    );
  }

  String _getStatusText() {
    switch (status) {
      case null:
      case EChatMessageStatus.sending:
        return 'Sending...';
      case EChatMessageStatus.sent:
        return 'Sent';
      case EChatMessageStatus.delivered:
        return 'Delivered';
      case EChatMessageStatus.read:
        return 'Read';
    }
  }
}
