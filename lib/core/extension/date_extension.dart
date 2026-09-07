extension DateTimeExtensions on DateTime {
  String diffForHumans({bool abbreviatedUnits = false, bool showRelativeDates = false, int precision = 2}) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(this);
    final int seconds = difference.inSeconds;
    final int minutes = difference.inMinutes;
    final int hours = difference.inHours;
    final int days = difference.inDays;

    if (showRelativeDates && difference.abs().inDays < 2) {
      if (difference.isNegative) {
        return 'yesterday';
      } else if (difference.inDays == 0) {
        return 'today';
      } else {
        return 'tomorrow';
      }
    }

    if (seconds < 5) {
      return 'just now';
    } else if (seconds < 60) {
      return '$seconds${abbreviatedUnits ? 's' : ' seconds'} ago';
    } else if (minutes < 60) {
      return '$minutes${abbreviatedUnits ? 'm' : ' minutes'} ago';
    } else if (hours < 24) {
      return '${_formatUnit(hours, abbreviatedUnits, 'hour')} ago';
    } else if (days < 30) {
      return '${_formatUnit(days, abbreviatedUnits, 'day')} ago';
    } else if (days < 365) {
      final int months = _calculateMonths(now, this);
      return '${_formatUnit(months, abbreviatedUnits, 'month')} ago';
    } else {
      final int years = days ~/ 365;
      return '${_formatUnit(years, abbreviatedUnits, 'year')} ago';
    }
  }

  String _formatUnit(int count, bool abbreviated, String unit) {
    final String pluralUnit = abbreviated ? '${unit[0]}${unit[1]}' : '$unit${count != 1 ? 's' : ''}';
    if (count == 1) {
      return '1 $pluralUnit';
    } else {
      return '$count $pluralUnit';
    }
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isTimeBeforeNow() {
    final now = DateTime.now();
    final selected = DateTime(now.year, now.month, now.day, hour, minute, second);
    return selected.isBefore(now);
  }

  int _calculateMonths(DateTime now, DateTime dateTime) {
    return (now.year - dateTime.year) * 12 + now.month - dateTime.month;
  }
}
