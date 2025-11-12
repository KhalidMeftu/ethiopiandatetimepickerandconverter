import 'package:abushakir/abushakir.dart';

/// Helper class for Ethiopian date operations
class EthiopianDateHelper {
  /// Returns today's Ethiopian date as a formatted string
  static String getTodayEthiopianDate() {
    final today = ETC.today();
    return '${today.year}-${today.month}-${today.day}';
  }

  /// Returns Ethiopian date from year, month, day
  static String getEthiopianDate(int year, int month, int day) {
    return '$year-$month-$day';
  }

  /// Returns current Ethiopian year
  static int getCurrentEthiopianYear() {
    return ETC.today().year;
  }

  /// Returns current Ethiopian month
  static int getCurrentEthiopianMonth() {
    return ETC.today().month;
  }

  /// Returns current Ethiopian day
  static int getCurrentEthiopianDay() {
    return ETC.today().day;
  }

  /// Creates an ETC object for a specific date
  static ETC createEthiopianDate(int year, int month, int day) {
    return ETC(year: year, month: month, day: day);
  }

  /// Get Ethiopian month name
  static String getEthiopianMonthName(int month, String language) {
    final etc = ETC(year: getCurrentEthiopianYear(), month: month, day: 1);
    return etc.monthName ?? '';
  }
}