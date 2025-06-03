import 'package:intl/intl.dart';

class DateFormatUtils {
  /// Format date to a more readable format
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    // If it's today
    if (difference.inDays == 0) {
      return 'Today, ${DateFormat('HH:mm').format(date)}';
    }

    // If it's yesterday
    if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat('HH:mm').format(date)}';
    }

    // If it's this week (within 7 days)
    if (difference.inDays <= 7) {
      return '${difference.inDays} days ago';
    }

    // If it's this year
    if (date.year == now.year) {
      return DateFormat('MMM d, HH:mm').format(date);
    }

    // For older dates
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format date for display (more readable than the default format)
  static String formatDisplayDate(DateTime date) {
    return DateFormat('MMM d, yyyy • HH:mm').format(date);
  }
}
