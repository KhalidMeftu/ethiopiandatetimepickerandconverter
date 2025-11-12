import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:ethiopiandatepickerandconvertor/utils/date_converter.dart';

void main() {
  group('Gregorian Age Calculator', () {
    test('age is 0y 0m 0d for birth today', () {
      final now = DateTime.now();
      final age = DateConverter.calculateGregorianAge(
        birthYear: now.year,
        birthMonth: now.month,
        birthDay: now.day,
      );
      expect(age['years'], 0);
      expect(age['months'], 0);
      expect(age['days'], 0);
    });

    test('age is 0y 0m 1d for birth yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final age = DateConverter.calculateGregorianAge(
        birthYear: yesterday.year,
        birthMonth: yesterday.month,
        birthDay: yesterday.day,
      );
      expect(age['years'], 0);
      expect(age['months'], 0);
      expect(age['days'], 1);
    });

    test('age is 0y 1m 0d for birth same day previous month', () {
      final now = DateTime.now();
      final prevMonthSameDay = DateTime(now.year, now.month - 1, 1);
      final daysInPrevMonth = DateTime(prevMonthSameDay.year, prevMonthSameDay.month + 1, 0).day;
      final birth = DateTime(now.year, now.month - 1, min(now.day, daysInPrevMonth));

      final age = DateConverter.calculateGregorianAge(
        birthYear: birth.year,
        birthMonth: birth.month,
        birthDay: birth.day,
      );
      expect(age['years'], 0);
      expect(age['months'], 1);
      expect(age['days'], 0);
    });

    test('age string formats in en/am/ao for birth today', () {
      final now = DateTime.now();
      final en = DateConverter.getGregorianAgeString(
        birthYear: now.year,
        birthMonth: now.month,
        birthDay: now.day,
        language: 'en',
      );
      final am = DateConverter.getGregorianAgeString(
        birthYear: now.year,
        birthMonth: now.month,
        birthDay: now.day,
        language: 'am',
      );
      final ao = DateConverter.getGregorianAgeString(
        birthYear: now.year,
        birthMonth: now.month,
        birthDay: now.day,
        language: 'ao',
      );
      expect(en, '0 years, 0 months, 0 days');
      expect(am, '0 ዓመት, 0 ወር, 0 ቀን');
      expect(ao, "0 waggaa, 0 ji'a, 0 guyyaa");
    });
  });

  group('Ethiopian Age Calculator', () {
    test('age is 0y 0m 0d for Ethiopian birth today', () {
      final etToday = DateConverter.getTodayEthiopian();
      final age = DateConverter.calculateEthiopianAge(
        birthYear: etToday['year']!,
        birthMonth: etToday['month']!,
        birthDay: etToday['day']!,
      );
      expect(age['years'], 0);
      expect(age['months'], 0);
      expect(age['days'], 0);
    });

    test('age is 0y 0m 1d for Ethiopian birth yesterday', () {
      final etToday = DateConverter.getTodayEthiopian();
      int y = etToday['year']!;
      int m = etToday['month']!;
      int d = etToday['day']!;

      if (d > 1) {
        d = d - 1;
      } else {
        m = m - 1;
        if (m < 1) {
          m = 13;
          y = y - 1;
        }
        final prevMonthMax = m == 13 ? 6 : 30;
        d = prevMonthMax;
      }

      final age = DateConverter.calculateEthiopianAge(
        birthYear: y,
        birthMonth: m,
        birthDay: d,
      );
      expect(age['years'], 0);
      expect(age['months'], 0);
      expect(age['days'], 1);
    });

    test('age is 0y 1m 0d for Ethiopian birth same day previous month', () {
      final etToday = DateConverter.getTodayEthiopian();
      int year = etToday['year']!;
      int month = etToday['month']!;
      int day = etToday['day']!;

      int prevMonth = month - 1;
      int prevYear = year;
      if (prevMonth < 1) {
        prevMonth = 13;
        prevYear = year - 1;
      }
      final prevMaxDay = prevMonth == 13 ? 6 : 30;
      final birthDay = min(day, prevMaxDay);

      final age = DateConverter.calculateEthiopianAge(
        birthYear: prevYear,
        birthMonth: prevMonth,
        birthDay: birthDay,
      );
      expect(age['years'], 0);
      expect(age['months'], 1);
      expect(age['days'], 0);
    });

    test('age string formats in en/am/ao for Ethiopian birth today', () {
      final etToday = DateConverter.getTodayEthiopian();
      final en = DateConverter.getEthiopianAgeString(
        birthYear: etToday['year']!,
        birthMonth: etToday['month']!,
        birthDay: etToday['day']!,
        language: 'en',
      );
      final am = DateConverter.getEthiopianAgeString(
        birthYear: etToday['year']!,
        birthMonth: etToday['month']!,
        birthDay: etToday['day']!,
        language: 'am',
      );
      final ao = DateConverter.getEthiopianAgeString(
        birthYear: etToday['year']!,
        birthMonth: etToday['month']!,
        birthDay: etToday['day']!,
        language: 'ao',
      );
      expect(en, '0 years, 0 months, 0 days');
      expect(am, '0 ዓመት, 0 ወር, 0 ቀን');
      expect(ao, "0 waggaa, 0 ji'a, 0 guyyaa");
    });
  });
}
