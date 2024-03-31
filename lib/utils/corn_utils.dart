class CronUtils {

  /// Generates a human-readable description from a cron expression.
  ///
  /// The cron expression should be in the format of a simple cron expression,
  /// which consists of 5 parts separated by spaces. Each part represents a
  /// different aspect of the schedule, such as the minute, hour, day of month,
  /// month, and day of week.
  ///
  /// Throws an [Exception] if the cron expression does not have 5 parts.
  ///
  /// Returns a string that describes the cron expression in a human-readable
  /// format.
  String convertCronToHumanReadable({required String cronExpression}) {
    // Initialize an empty string to store the generated description.
    String description = '';

    // Split the cron expression into its parts.
    final List<String> cronParts = cronExpression.split(' ');

    // Check if the cron expression has 5 parts.
    if (cronParts.length != 5) {
      // If not, throw an exception.
      throw Exception('Simple cron expression must have 5 parts');
    }

    // Generate the description by calling helper methods for each part.
    description += _getTimeOfDayDescription(cronParts[0], cronParts[1]);
    description += _getDayOfMonthDescription(cronParts[2]);
    description += _getDayOfWeekDescription(cronParts[4]);
    description += _getMonthDescription(cronParts[3]);

    // Return the generated description.
    return description;
  }

  
  /// Generates a description of the time of day based on the given minute and hour values.
  ///
  /// The [minute] parameter should be a string representing the minute value.
  /// The [hour] parameter should be a string representing the hour value.
  ///
  /// Returns a string describing the time of day.
  ///
  /// Throws a [FormatException] if the minute or hour values are invalid.
  String _getTimeOfDayDescription(String minute, String hour) {
    String description = '';
    if (!minute.contains(RegExp(r"[-/,*]")) && !hour.contains(RegExp(r"[-/,*]"))) {
      _tryParseInt(hour, min: 0, max: 23, part: 'Hour');
      _tryParseInt(minute, min: 0, max: 59, part: 'Minute');
      description = 'At ${hour.padLeft(2, '0')}:${minute.padLeft(2, '0')}';
      return description;
    }

    if (minute == '*' && hour == '*') {
      description = 'Every minute';
      return description;
    }

    if (minute.contains(RegExp(r"[-/,]"))) {
      if (minute.contains(',')) {
        description = 'At minute ';
        final List<String> minuteParts = minute.split(',');
        for (int i = 0; i < minuteParts.length; i++) {
          _tryParseInt(minuteParts[i], min: 0, max: 59, part: 'Minute');
          description += minuteParts[i];
          if (i == minuteParts.length - 2) {
            description += ' and ';
          } else if (i < minuteParts.length - 1) {
            description += ', ';
          }
        }
      } else if (minute.contains('-')) {
        description = 'At every minute from ';
        final List<String> minuteParts = minute.split('-');
        if (minuteParts.length > 2) {
          throw const FormatException("Parser got error while parsing cron expression in minutes");
        }
        _tryParseInt(minuteParts[0], min: 0, max: 59, part: 'Minute');
        description += minuteParts[0];
        _tryParseInt(minuteParts[1], min: 0, max: 59, part: 'Minute');
        description += ' through ${minuteParts[1]}';
      } else if (minute.contains('/')) {
        description = 'At every ';
        final List<String> minuteParts = minute.split('/');
        if (minuteParts[0] != '*') {
          throw const FormatException("Non standard cron expression in minutes");
        }
        _tryParseInt(minuteParts[1], min: 0, max: 999999, part: 'Minute');
        description += '${minuteParts[1]}th minute';
      }
    } else {
      description += 'At ${minute == '*' ? 'every minute' : 'minute $minute'}';
    }

    if (hour.contains(RegExp(r"[-/,]"))) {
      if (hour.contains(',')) {
        description += ' of ';
        final List<String> hourParts = hour.split(',');
        for (int i = 0; i < hourParts.length; i++) {
          _tryParseInt(hourParts[i], min: 0, max: 23, part: 'Hour');
          description += hourParts[i];
          if (i == hourParts.length - 2) {
            description += ' and ';
          } else if (i < hourParts.length - 1) {
            description += ', ';
          }
        }
      } else if (hour.contains('-')) {
        description += ' of every hour from ';
        final List<String> hourParts = hour.split('-');
        if (hourParts.length > 2) {
          throw const FormatException("Parser got error while parsing cron expression in hours");
        }
        _tryParseInt(hourParts[0], min: 0, max: 23, part: 'Hour');
        description += hourParts[0];
        _tryParseInt(hourParts[1], min: 0, max: 23, part: 'Hour');
        description += ' through ${hourParts[1]}';
      } else if (hour.contains('/')) {
        description += ' of every ';
        final List<String> hourParts = hour.split('/');
        if (hourParts[0] != '*') {
          throw const FormatException("Non standard cron expression in hours");
        }
        _tryParseInt(hourParts[1], min: 0, max: 999999, part: 'Hour');
        description += '${hourParts[1]}th hour';
      }
    } else {
      description += ' At ${hour == '*' ? 'every hour' : 'hour $hour'}';
    }

    return description;
  }

  /// Returns a description of the day of the month based on the given [dayOfMonth].
  ///
  /// The [dayOfMonth] parameter is a string that represents the day of the month.
  /// It can be a specific day number (e.g., "15"), a range of days (e.g., "10-15"),
  /// a list of days (e.g., "1,10,20"), or a step pattern (e.g., "*/3" for every 3 days).
  ///
  /// Returns a string that describes the day of the month. The description is in the
  /// format of a human-readable sentence. For example, if [dayOfMonth] is "1", the
  /// returned description will be ", on day 1 of the month". If [dayOfMonth] is
  /// "1,15", the returned description will be ", on day 1 and 15 of the month".
  ///
  /// Throws a [FormatException] if the [dayOfMonth] parameter is not in a valid format.
  String _getDayOfMonthDescription(String dayOfMonth) {
    String description = '';

    if (dayOfMonth == '*') {
      return description;
    }

    if (!dayOfMonth.contains(RegExp(r"[-/,*]"))) {
      _tryParseInt(dayOfMonth, min: 1, max: 31, part: 'DayOfMonth');
      description = ', on day $dayOfMonth of the month';
      return description;
    }

    if (dayOfMonth.contains(RegExp(r"[-/,]"))) {
      if (dayOfMonth.contains(',')) {
        description += ', on day ';
        final List<String> dayOfMonthParts = dayOfMonth.split(',');
        for (int i = 0; i < dayOfMonthParts.length; i++) {
          _tryParseInt(dayOfMonthParts[i], min: 1, max: 31, part: 'DayOfMonth');
          description += dayOfMonthParts[i];
          if (i == dayOfMonthParts.length - 2) {
            description += ' and ';
          } else if (i < dayOfMonthParts.length - 1) {
            description += ', ';
          }
        }
        description += ' of the month';
      } else if (dayOfMonth.contains('-')) {
        description += ', between day ';
        final List<String> dayOfMonthParts = dayOfMonth.split('-');
        if (dayOfMonthParts.length > 2) {
          throw const FormatException("Parser got error while parsing cron expression in day of month");
        }
        _tryParseInt(dayOfMonthParts[0], min: 1, max: 31, part: 'DayOfMonth');
        description += dayOfMonthParts[0];
        _tryParseInt(dayOfMonthParts[1], min: 1, max: 31, part: 'DayOfMonth');
        description += ' and ${dayOfMonthParts[1]} of the month';
      } else if (dayOfMonth.contains('/')) {
        description += ', every ';
        final List<String> dayOfMonthParts = dayOfMonth.split('/');
        if (dayOfMonthParts[0] != '*') {
          throw const FormatException("Non standard cron expression in day of month");
        }
        _tryParseInt(dayOfMonthParts[1], min: 1, max: 999999, part: 'DayOfMonth');
        description += '${dayOfMonthParts[1]} days';
      }
    }
    return description;
  }

  /// Returns a description of the given month.
  ///
  /// The [month] parameter should be a string representing the month. It can be a
  /// single month (e.g. '1', '01', 'Jan', 'January'), a range of months (e.g.
  /// '1-3', 'Jan-Mar'), or a list of months (e.g. '1,3,5'). If the [month] is '*',
  /// an empty string is returned.
  ///
  /// Returns a string describing the month(s) specified in [month]. If [month] is
  /// a single month, the string will include the name of the month. If [month] is
  /// a range of months, the string will include the name of the starting month and
  /// the name of the ending month separated by ' through '. If [month] is a list of
  /// months, the string will include the names of the months separated by ', '. If
  /// [month] is a list of months and contains more than two months, the last two
  /// months will be separated by ' and '.
  ///
  /// Throws a [FormatException] if the [month] string is not in the expected format.
  ///
  /// Example usage:
  ///
  ///     print(_getMonthDescription('1')); // Prints: , only in January
  String _getMonthDescription(String month) {
    String description = '';

    if (month == '*') {
      return description;
    }

    if (!month.contains(RegExp(r"[-/,*]"))) {
      final int monthInt = _tryParseInt(month, min: 1, max: 12, part: 'Month');
      description = ', only in ${_getMonthName(monthInt)}';
      return description;
    }

    if (month.contains(RegExp(r"[-/,]"))) {
      if (month.contains(',')) {
        description += ', only in ';
        final List<String> monthParts = month.split(',');
        for (int i = 0; i < monthParts.length; i++) {
          int monthInt = _tryParseInt(monthParts[i], min: 1, max: 12, part: 'Month');
          description += _getMonthName(monthInt);
          if (i == monthParts.length - 2) {
            description += ' and ';
          } else if (i < monthParts.length - 1) {
            description += ', ';
          }
        }
      } else if (month.contains('-')) {
        description += ', ';
        final List<String> monthParts = month.split('-');
        if (monthParts.length > 2) {
          throw const FormatException("Parser got error while parsing cron expression in month");
        }
        final int monthInt = _tryParseInt(monthParts[0], min: 1, max: 12, part: 'Month');
        description += _getMonthName(monthInt);
        final int monthInt2 = _tryParseInt(monthParts[1], min: 1, max: 12, part: 'Month');
        description += ' through ${_getMonthName(monthInt2)}';
      } else if (month.contains('/')) {
        description += ', every ';
        final List<String> monthParts = month.split('/');
        if (monthParts[0] != '*') {
          throw const FormatException("Non standard cron expression in month");
        }
        final int monthInt = _tryParseInt(monthParts[1], min: 1, max: 999999, part: 'Month');
        description += '$monthInt months';
      }
    }

    return description;
  }

  /// Returns a description of the day of the week based on the given [dayOfWeek].
  ///
  /// The [dayOfWeek] parameter should be a string representing the day of the week.
  /// It can be a single day (e.g., "Monday"), a range of days (e.g., "Monday-Friday"),
  /// a list of days (e.g., "Monday, Wednesday, Friday"), or a wildcard (e.g., "*").
  ///
  /// Returns a string describing the day(s) of the week. If the [dayOfWeek] is "*",
  /// an empty string is returned. If the [dayOfWeek] is a single day, the day name is
  /// returned with a leading comma and space (e.g., ", Monday"). If the [dayOfWeek]
  /// is a range of days, the range is returned with a leading comma and space (e.g.,
  /// ", Monday through Friday"). If the [dayOfWeek] is a list of days, the list is
  /// returned with each day name separated by a comma and space (e.g., ", Monday,
  /// Wednesday, Friday"). If the [dayOfWeek] is not a valid format, a [FormatException]
  /// is thrown.
  String _getDayOfWeekDescription(String dayOfWeek) {
    String description = '';

    if (dayOfWeek == '*') {
      return description;
    }

    if (!dayOfWeek.contains(RegExp(r"[-/,*]"))) {
      final int dayOfWeekInt = _tryParseInt(dayOfWeek, min: 0, max: 6, part: 'DayOfWeek');
      description = ', and on ${_getDayName(dayOfWeekInt)}';
    }

    if (dayOfWeek.contains(RegExp(r"[-/,]"))) {
      if (dayOfWeek.contains(',')) {
        description += ', and on ';
        final List<String> dayOfWeekParts = dayOfWeek.split(',');
        for (int i = 0; i < dayOfWeekParts.length; i++) {
          final int dayOfWeekInt = _tryParseInt(dayOfWeekParts[i], min: 0, max: 6, part: 'DayOfWeek');
          description += _getDayName(dayOfWeekInt);
          if (i == dayOfWeekParts.length - 2) {
            description += ' and ';
          } else if (i < dayOfWeekParts.length - 1) {
            description += ', ';
          }
        }
      } else if (dayOfWeek.contains('-')) {
        description += ', ';
        final List<String> dayOfWeekParts = dayOfWeek.split('-');
        if (dayOfWeekParts.length > 2) {
          throw const FormatException("Parser got error while parsing cron expression in day of week");
        }
        final int dayOfWeekInt = _tryParseInt(dayOfWeekParts[0], min: 0, max: 6, part: 'DayOfWeek');
        description += _getDayName(dayOfWeekInt);
        final int dayOfWeekInt2 = _tryParseInt(dayOfWeekParts[1], min: 0, max: 6, part: 'DayOfWeek');
        description += ' through ${_getDayName(dayOfWeekInt2)}';
      } else if (dayOfWeek.contains('/')) {
        description += ', every ';
        final List<String> dayOfWeekParts = dayOfWeek.split('/');
        if (dayOfWeekParts[0] != '*') {
          throw const FormatException("Non standard cron expression in day of week");
        }
        _tryParseInt(dayOfWeekParts[1], min: 0, max: 999999, part: 'DayOfWeek');
        description += '${dayOfWeekParts[1]} days of the week';
      }
    }

    return description;
  }

  /// Converts a string to an integer and checks if it falls within a specified range.
  ///
  /// The [input] parameter is the string to be converted.
  /// The [min] parameter is the minimum value allowed for the integer. Defaults to 0.
  /// The [max] parameter is the maximum value allowed for the integer. Defaults to 59.
  /// The [part] parameter is an optional string that identifies the specific part of the code where the conversion is happening.
  ///
  /// Returns the converted integer if it falls within the specified range.
  ///
  /// Throws a [FormatException] if the string cannot be converted to an integer or if the integer is outside the specified range.
  int _tryParseInt(String input, {int min = 0, int max = 59, String? part}) {
    final int? i = int.tryParse(input);
    if (i == null) {
      throw FormatException("${part != null ? '<$part> ' : ''}Failed to convert string to integer");
    }
    if (i < min || i > max) {
      throw FormatException("${part != null ? '$part ' : ''}Value must be between $min and $max");
    }
    return i;
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
