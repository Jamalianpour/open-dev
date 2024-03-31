import 'package:intl/intl.dart';

class UnixUtils {
  /// Formats the given [dateTime] according to the specified [pattern].
  ///
  /// Parameters:
  /// - [dateTime]: The [DateTime] object to be formatted.
  /// - [pattern]: The pattern string describing the format of the output.
  ///
  /// Returns:
  /// A [String] representing the formatted [dateTime].
  static String _format(DateTime dateTime, String pattern) {
    final DateFormat formatter = DateFormat(pattern);
    return formatter.format(dateTime);
  }

  static DateTime getDateTimeFromUnixTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  static DateTime getDateTimeFromUnixTimestampMs(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static DateTime getDateTimeFromUnixTimestampMicros(int timestamp) {
    return DateTime.fromMicrosecondsSinceEpoch(timestamp);
  }

  static int getUnixTimestamp(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  static int getUnixTimestampFromDate(DateTime date) {
    return date.millisecondsSinceEpoch ~/ 1000;
  }

  static String toYYYYMMDD(DateTime dateTime) {
    return _format(dateTime, 'yyyy-MM-dd');
  }

  static String toYYMMDDHHMM(DateTime dateTime) {
    return _format(dateTime, 'yy/MM/dd HH:mm');
  }

  static String toDDMMYYYY(DateTime dateTime) {
    return _format(dateTime, 'dd/MM/yyyy'); // Common European _format
  }

  static String toEEEEdMMMMd(DateTime dateTime) {
    return _format(dateTime, 'EEEE, d MMMM, yyyy'); // Full weekday, month, day, year
  }

  static String toHhma(DateTime dateTime) {
    return _format(dateTime, 'h:mm a'); // 12-hour clock with AM/PM
  }

  static String toRFC3339(DateTime dateTime) {
    return _format(dateTime, 'yyyy-MM-ddTHH:mm:ssZ'); // Coordinated Universal Time (UTC)
  }

  static String toRFC2822(DateTime dateTime) {
    return _format(dateTime, 'EEE, d MMM yyyy HH:mm:ss Z'); // Standard for email headers
  }

  static String toISO8601(DateTime dateTime, {bool withOffset = true}) {
    final pattern = withOffset ? 'yyyy-MM-ddTHH:mm:ss.SSS' : 'yyyy-MM-ddTHH:mm:ss';
    return '${_format(dateTime, pattern)}Z'; // ISO 8601 with optional offset
  }

  static String toHmmss(DateTime dateTime) {
    return _format(dateTime, 'H:mm:ss'); // 24-hour clock with seconds
  }

  static String toCustomFormat(DateTime dateTime, String customPattern) {
    return _format(dateTime, customPattern);
  }

  static int _numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Returns the week of the year for the given [DateTime] object.
  ///
  /// The [dateTime] parameter must be an instance of [DateTime].
  /// The return type is [int].
  static int toWeekOfYear(DateTime dateTime) {
    final int dayOfYear = int.parse(DateFormat("D").format(dateTime));
    int woy = ((dayOfYear - dateTime.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(dateTime.year - 1);
    } else if (woy > _numOfWeeks(dateTime.year)) {
      woy = 1;
    }
    return woy;
  }

  static int toDayOfYear(DateTime dateTime) {
    return int.parse(DateFormat("D").format(dateTime));
  }

  static String toLongWeekdayMonth(DateTime dateTime) {
    final formatter = DateFormat("dd MMMM yyyy");
    return formatter.format(dateTime);
  }

  static String toOrdinalDate(DateTime dateTime) {
    final int day = dateTime.day;
    final String suffix = day >= 11 && day <= 13
        ? day == 11
            ? 'th'
            : day == 12
                ? 'st'
                : 'nd'
        : ['st', 'nd', 'rd'][day % 100 > 20 ? 0 : day % 10];
    return '${dateTime.day}$suffix ${DateFormat('MMMM yyyy').format(dateTime)}';
  }

  /// Returns a string representing the time difference between [dateTime] and
  /// [now] in a human-readable format.
  ///
  /// The [dateTime] and [now] parameters must be instances of [DateTime].
  /// The return type is a [String].
  static String toRelativeTime(DateTime dateTime, DateTime now) {
    final difference = dateTime.difference(now);
    final duration = Duration(milliseconds: difference.inMilliseconds.abs());

    final int seconds = duration.inSeconds;
    final int days = duration.inDays;
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes;

    if (difference.isNegative) {
      // Past time
      if (days >= 365) {
        final int years = (days / 365).floor();
        return years == 1 ? '$years year ago' : '$years years ago';
      } else if (days >= 30) {
        final int months = (days / 30).floor();
        return months == 1 ? '$months month ago' : '$months months ago';
      } else if (days > 0) {
        return days == 1 ? '$days day ago' : '$days days ago';
      } else if (hours > 0) {
        return hours == 1 ? '$hours hour ago' : '$hours hours ago';
      } else if (minutes > 0) {
        return minutes == 1 ? '$minutes minute ago' : '$minutes minutes ago';
      } else if (seconds > 0) {
        return seconds == 1 ? '$seconds second ago' : '$seconds seconds ago';
      } else {
        return 'just now';
      }
    } else {
      // Future time
      if (days >= 365) {
        final int years = (days / 365).floor();
        return years == 1 ? 'in $years year' : 'in $years years';
      } else if (days >= 30) {
        final int months = (days / 30).floor();
        return months == 1 ? 'in $months month' : 'in $months months';
      } else if (days > 0) {
        return days == 1 ? 'in $days day' : 'in $days days';
      } else if (hours > 0) {
        return hours == 1 ? 'in $hours hour' : 'in $hours hours';
      } else if (minutes > 0) {
        return minutes == 1 ? 'in $minutes minute' : 'in $minutes minutes';
      } else if (seconds > 0) {
        return seconds == 1 ? 'in $seconds second' : 'in $seconds seconds';
      } else {
        return 'just now'; // Technically not future, but handle edge case
      }
    }
  }
}
