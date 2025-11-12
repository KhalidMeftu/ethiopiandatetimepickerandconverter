import 'package:abushakir/abushakir.dart';

class DateConverter {
  /// Convert Ethiopian date to Gregorian date
  /// Input: year, month, day in Ethiopian calendar
  /// Returns: Map with 'year', 'month', 'day' keys for Gregorian date
  static Map<String, int> ethiopianToGregorian({
    required int year,
    required int month,
    required int day,
  }) {
    try {
      final ethiopianDate = EtDatetime(year: year, month: month, day: day);
      final gregorianDate = DateTime.fromMillisecondsSinceEpoch(ethiopianDate.moment);

      return {
        'year': gregorianDate.year,
        'month': gregorianDate.month,
        'day': gregorianDate.day,
      };
    } catch (e) {
      throw Exception('Invalid Ethiopian date: $e');
    }
  }

  /// Convert Gregorian date to Ethiopian date
  /// Input: year, month, day in Gregorian calendar
  /// Returns: Map with 'year', 'month', 'day' keys for Ethiopian date
  static Map<String, int> gregorianToEthiopian({
    required int year,
    required int month,
    required int day,
  }) {
    try {
      final gregorianDate = DateTime(year, month, day);
      // Convert using EtDatetime
      final ethiopianDate = EtDatetime.fromMillisecondsSinceEpoch(gregorianDate.millisecondsSinceEpoch);

      return {
        'year': ethiopianDate.year,
        'month': ethiopianDate.month,
        'day': ethiopianDate.day,
      };
    } catch (e) {
      throw Exception('Invalid Gregorian date: $e');
    }
  }

  /// Convert Ethiopian date string to Gregorian date string
  /// Input format: "day/month/year" or "day-month-year"
  /// Returns: Formatted Gregorian date string
  static String ethiopianToGregorianString(String ethiopianDateStr, {String separator = '/'}) {
    try {
      // Validate format first
      if (!_isValidDateFormat(ethiopianDateStr)) {
        throw Exception('Invalid date format. Use day/month/year or day-month-year with proper separators');
      }

      // Support both / and - separators
      final parts = ethiopianDateStr.contains('/')
          ? ethiopianDateStr.split('/')
          : ethiopianDateStr.split('-');

      if (parts.length != 3) {
        throw Exception('Invalid date format. Use day/month/year or day-month-year');
      }

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      // Validate Ethiopian date ranges
      if (month < 1 || month > 13) {
        throw Exception('Ethiopian month must be between 1 and 13');
      }
      if (month == 13 && day > 6) {
        throw Exception('Pagume month can only have up to 6 days');
      }
      if (day < 1 || day > 30) {
        throw Exception('Day must be between 1 and 30');
      }

      final result = ethiopianToGregorian(year: year, month: month, day: day);

      return '${result['day']}$separator${result['month']}$separator${result['year']}';
    } catch (e) {
      throw Exception('Date conversion failed: $e');
    }
  }

  /// Convert Gregorian date string to Ethiopian date string
  /// Input format: "day/month/year" or "day-month-year"
  /// Returns: Formatted Ethiopian date string
  static String gregorianToEthiopianString(String gregorianDateStr, {String separator = '/'}) {
    try {
      // Validate format first
      if (!_isValidDateFormat(gregorianDateStr)) {
        throw Exception('Invalid date format. Use day/month/year or day-month-year with proper separators');
      }

      // Support both / and - separators
      final parts = gregorianDateStr.contains('/')
          ? gregorianDateStr.split('/')
          : gregorianDateStr.split('-');

      if (parts.length != 3) {
        throw Exception('Invalid date format. Use day/month/year or day-month-year');
      }

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      // Validate Gregorian date ranges
      if (month < 1 || month > 12) {
        throw Exception('Month must be between 1 and 12');
      }
      if (day < 1 || day > 31) {
        throw Exception('Day must be between 1 and 31');
      }

      final result = gregorianToEthiopian(year: year, month: month, day: day);

      return '${result['day']}$separator${result['month']}$separator${result['year']}';
    } catch (e) {
      throw Exception('Date conversion failed: $e');
    }
  }

  /// Get today's Ethiopian date
  static Map<String, int> getTodayEthiopian() {
    final now = DateTime.now();
    final et = EtDatetime.fromMillisecondsSinceEpoch(now.millisecondsSinceEpoch);
    return {
      'year': et.year,
      'month': et.month,
      'day': et.day,
    };
  }

  /// Get today's Ethiopian date as formatted string
  static String getTodayEthiopianString({String separator = '/'}) {
    final today = getTodayEthiopian();
    return '${today['day']}$separator${today['month']}$separator${today['year']}';
  }

  /// Get Ethiopian month name in different languages
  static String getEthiopianMonthName(int month, String language) {
    if (month < 1 || month > 13) {
      throw Exception('Invalid month number. Must be between 1 and 13');
    }

    final monthNames = {
      'am': ['ጥር', 'የካቲት', 'መጋቢት', 'ሚያዝያ', 'ግንቦት', 'ሰኔ',
             'ኃምሌ', 'ነሐሴ', 'መስከረም', 'ጥቅምት', 'ኅዳር', 'ታኅሳስ', 'ጷጉሜን'],
      'ao': ['Amajjii', 'Guraandhala', 'Bitooteessa', 'Elba(Ebila)', 'Caamsa', 'Waxabajjii',
             'Adooleessa', 'Hagayya', 'Fuulbana', 'Onkololeessa', 'Sadaasa', 'Muddee', 'Qaammee'],
      'en': ['January', 'February', 'March', 'April', 'May', 'June',
             'July', 'August', 'September', 'October', 'November', 'December', 'Pagume'],
    };

    return monthNames[language]?[month - 1] ?? monthNames['en']![month - 1];
  }

  /// Calculate age from birthdate in Ethiopian calendar
  /// Returns Map with years, months, and days
  static Map<String, int> calculateEthiopianAge({
    required int birthYear,
    required int birthMonth,
    required int birthDay,
  }) {
    final today = getTodayEthiopian();

    int years = today['year']! - birthYear;
    int months = today['month']! - birthMonth;
    int days = today['day']! - birthDay;

    // Adjust for negative days using the exact number of days in the previous Ethiopian month
    if (days < 0) {
      months--;

      // Determine previous Ethiopian month relative to today
      int prevMonth = today['month']! - 1;
      int prevMonthYear = today['year']!;
      if (prevMonth < 1) {
        prevMonth = 13;
        prevMonthYear -= 1;
      }

      // Compute the exact number of days in the previous Ethiopian month by:
      // - Taking the first day of the current Ethiopian month
      // - Converting to Gregorian and subtracting one day
      // - Converting back to Ethiopian and reading the day number (length)
      final firstOfThisMonthEt = EtDatetime(
        year: today['year']!,
        month: today['month']!,
        day: 1,
      );
      final firstOfThisMonthGr = DateTime.fromMillisecondsSinceEpoch(firstOfThisMonthEt.moment);
      final lastOfPrevMonthGr = firstOfThisMonthGr.subtract(const Duration(days: 1));
      final lastOfPrevMonthEt = EtDatetime.fromMillisecondsSinceEpoch(lastOfPrevMonthGr.millisecondsSinceEpoch);
      final prevMonthDays = lastOfPrevMonthEt.day; // exact length of previous month (5/6/30)

      days += prevMonthDays;
    }

    // Adjust for negative months
    if (months < 0) {
      years--;
      months += 13; // Ethiopian calendar has 13 months
    }

    return {
      'years': years,
      'months': months,
      'days': days,
    };
  }

  /// Calculate age from Gregorian birthdate
  /// Returns Map with years, months, and days
  static Map<String, int> calculateGregorianAge({
    required int birthYear,
    required int birthMonth,
    required int birthDay,
  }) {
    final today = DateTime.now();

    int years = today.year - birthYear;
    int months = today.month - birthMonth;
    int days = today.day - birthDay;

    // Adjust for negative days
    if (days < 0) {
      months--;
      // Get days in previous month
      final prevMonth = DateTime(today.year, today.month - 1, 1);
      final daysInPrevMonth = DateTime(prevMonth.year, prevMonth.month + 1, 0).day;
      days += daysInPrevMonth;
    }

    // Adjust for negative months
    if (months < 0) {
      years--;
      months += 12;
    }

    return {
      'years': years,
      'months': months,
      'days': days,
    };
  }

  /// Convert Ethiopian birthdate to age string
  static String getEthiopianAgeString({
    required int birthYear,
    required int birthMonth,
    required int birthDay,
    required String language,
  }) {
    final age = calculateEthiopianAge(
      birthYear: birthYear,
      birthMonth: birthMonth,
      birthDay: birthDay,
    );

    if (language == 'am') {
      return '${age['years']} ዓመት, ${age['months']} ወር, ${age['days']} ቀን';
    } else if (language == 'ao') {
      return '${age['years']} waggaa, ${age['months']} ji\'a, ${age['days']} guyyaa';
    } else {
      return '${age['years']} years, ${age['months']} months, ${age['days']} days';
    }
  }

  /// Convert Gregorian birthdate to age string
  static String getGregorianAgeString({
    required int birthYear,
    required int birthMonth,
    required int birthDay,
    required String language,
  }) {
    final age = calculateGregorianAge(
      birthYear: birthYear,
      birthMonth: birthMonth,
      birthDay: birthDay,
    );

    if (language == 'am') {
      return '${age['years']} ዓመት, ${age['months']} ወር, ${age['days']} ቀን';
    } else if (language == 'ao') {
      return '${age['years']} waggaa, ${age['months']} ji\'a, ${age['days']} guyyaa';
    } else {
      return '${age['years']} years, ${age['months']} months, ${age['days']} days';
    }
  }

  /// Validate date format
  static bool _isValidDateFormat(String dateStr) {
    // Check for valid date format: d/m/yyyy or dd/mm/yyyy or d-m-yyyy or dd-mm-yyyy
    final dateRegex = RegExp(r'^\d{1,2}[/\-]\d{1,2}[/\-]\d{4}$');
    if (!dateRegex.hasMatch(dateStr)) {
      return false;
    }

    // Check that separators are consistent
    if (dateStr.contains('/') && dateStr.contains('-')) {
      return false;
    }

    return true;
  }

  /// Validate and parse date string with strict format checking
  static Map<String, int> parseAndValidateDateString(String dateStr, {bool isEthiopian = false}) {
    if (!_isValidDateFormat(dateStr)) {
      throw Exception('Invalid date format. Use day/month/year or day-month-year');
    }

    final parts = dateStr.contains('/') ? dateStr.split('/') : dateStr.split('-');

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    if (isEthiopian) {
      // Validate Ethiopian date
      if (month < 1 || month > 13) {
        throw Exception('Ethiopian month must be between 1 and 13');
      }
      if (month == 13 && day > 6) {
        throw Exception('Pagume month can only have up to 6 days');
      }
      if (day < 1 || day > 30) {
        throw Exception('Day must be between 1 and 30');
      }
    } else {
      // Validate Gregorian date
      if (month < 1 || month > 12) {
        throw Exception('Month must be between 1 and 12');
      }
      if (day < 1 || day > 31) {
        throw Exception('Day must be between 1 and 31');
      }
    }

    return {'day': day, 'month': month, 'year': year};
  }
}