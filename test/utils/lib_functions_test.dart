import 'package:flutter_test/flutter_test.dart';
import 'package:abushakir/abushakir.dart';
import 'package:ethiopiandatepickerandconvertor/const/lib_functions.dart';
import 'package:ethiopiandatepickerandconvertor/const/app_strings.dart';

void main() {
  group('Library Functions Tests', () {
    group('Ethiopian to Gregorian Date Conversion', () {
      test('converts Ethiopian date to Gregorian for calendar display', () {
        final ethiopianCalendar = ETC.today();
        final result = ethiopianToGregorianDateConvertor(15, ethiopianCalendar, true);
        expect(result, isA<String>());
        expect(result.isNotEmpty, true);
      });

      test('converts Ethiopian date to Gregorian for full date', () {
        final ethiopianCalendar = ETC.today();
        final result = ethiopianToGregorianDateConvertor(15, ethiopianCalendar, false);
        expect(result, isA<String>());
        expect(result.isNotEmpty, true);
      });

      test('handles different days of the month', () {
        final ethiopianCalendar = ETC(year: 2015, month: 1, day: 1);
        final result1 = ethiopianToGregorianDateConvertor(1, ethiopianCalendar, true);
        expect(result1, isA<String>());
        final result15 = ethiopianToGregorianDateConvertor(15, ethiopianCalendar, true);
        expect(result15, isA<String>());
        final result30 = ethiopianToGregorianDateConvertor(30, ethiopianCalendar, true);
        expect(result30, isA<String>());
      });

      test('handles edge cases for date conversion', () {
        final ethiopianCalendar = ETC(year: 2015, month: 13, day: 1);

        final result = ethiopianToGregorianDateConvertor(5, ethiopianCalendar, true);
        expect(result, isA<String>());
        expect(result.isNotEmpty, true);
      });
    });

    group('Calendar Specific Year Function', () {
      test('creates calendar for specific year', () {
        final calendar = getCalenderSpecificYear(2015);

        expect(calendar, isA<ETC>());
        expect(calendar.year, equals(2015));
      });

      test('handles different years', () {
        final calendar2010 = getCalenderSpecificYear(2010);
        final calendar2020 = getCalenderSpecificYear(2020);

        expect(calendar2010.year, equals(2010));
        expect(calendar2020.year, equals(2020));
      });
    });

    group('Day and Month Name Functions', () {
      test('returns day and month names for Amharic', () {
        final result = returnDayAndMonthName(
          'ሰኞ',
          '15',
          'መስከረም',
          'am',
          '2015',
          false
        );

        expect(result, isA<String>());
        expect(result!.isNotEmpty, true);
      });

      test('returns day and month names for Oromo', () {
        final result = returnDayAndMonthName(
          'Wiixata',
          '15',
          'Fulbaana',
          'ao',
          '2015',
          false
        );

        expect(result, isA<String>());
        expect(result!.isNotEmpty, true);
      });

      test('returns day and month names for English', () {
        final result = returnDayAndMonthName(
          'Monday',
          '15',
          'September',
          'en',
          '2015',
          false
        );

        expect(result, isA<String>());
        expect(result!.isNotEmpty, true);
      });

      test('handles month only display', () {
        final result = returnDayAndMonthName(
          '',
          '',
          'መስከረም',
          'am',
          '',
          true
        );

        expect(result, isA<String>());
        expect(result!.isNotEmpty, true);
      });

      test('handles invalid language gracefully', () {
        final result = returnDayAndMonthName(
          'Monday',
          '15',
          'September',
          'invalid',
          '2015',
          false
        );

        expect(result, isA<String?>());
      });
    });

    group('Week Names Functions', () {
      test('returns abbreviated week names for Amharic', () {
        final amharicShortDays = ['ሰ', 'ማ', 'ረ', 'ሐ', 'አ', 'ቅ', 'እ'];

        for (final day in amharicShortDays) {
          final result = returnAbrivateWeekNames(day, 'am');
          expect(result, isA<String?>());
          if (result != null) {
            expect(result.isNotEmpty, true);
          }
        }
      });

      test('returns abbreviated week names for Afan Oromo', () {
        final amharicShortDays = ['ሰ', 'ማ', 'ረ', 'ሐ', 'አ', 'ቅ', 'እ'];

        for (final day in amharicShortDays) {
          final result = returnAbrivateWeekNames(day, 'ao');
          expect(result, isA<String?>());
          if (result != null) {
            expect(result.isNotEmpty, true);
          }
        }
      });

      test('returns abbreviated week names for English', () {
        final amharicShortDays = ['ሰ', 'ማ', 'ረ', 'ሐ', 'አ', 'ቅ', 'እ'];

        for (final day in amharicShortDays) {
          final result = returnAbrivateWeekNames(day, 'en');
          expect(result, isA<String?>());
          if (result != null) {
            expect(result.isNotEmpty, true);
          }
        }
      });

      test('handles invalid day names gracefully', () {
        final result = returnAbrivateWeekNames('InvalidDay', 'en');
        expect(result, isA<String?>());
      });

      test('handles invalid language codes', () {
        final result = returnAbrivateWeekNames('ሰ', 'invalid');
        expect(result, isA<String?>());
      });
    });

    group('Constants and Strings', () {
      test('days list is properly defined', () {
        expect(days, isA<List>());
        expect(days.length, equals(7));
        expect(days.contains('ሰ'), true);
        expect(days.contains('እ'), true);
      });
    });
  });

  group('Ethiopian Calendar Integration Tests', () {
    test('conversion consistency across different dates', () {
      final testDates = [
        {'year': 2015, 'month': 1, 'day': 1},
        {'year': 2015, 'month': 6, 'day': 15},
        {'year': 2015, 'month': 12, 'day': 30},
        {'year': 2015, 'month': 13, 'day': 5},
      ];

      for (final dateData in testDates) {
        final ethiopianCalendar = ETC(
          year: dateData['year']!,
          month: dateData['month']!,
          day: dateData['day']!,
        );

        final calendarResult = ethiopianToGregorianDateConvertor(
          dateData['day']!,
          ethiopianCalendar,
          true,
        );

        final fullResult = ethiopianToGregorianDateConvertor(
          dateData['day']!,
          ethiopianCalendar,
          false,
        );

        expect(calendarResult, isA<String>());
        expect(fullResult, isA<String>());
        expect(calendarResult.isNotEmpty, true);
        expect(fullResult.isNotEmpty, true);
      }
    });

    test('multi-language consistency', () {
      final languages = ['am', 'ao', 'en'];
      final months = ['መስከረም', 'ጥቅምት', 'ህዳር'];

      for (final lang in languages) {
        for (final month in months) {
          final result = returnDayAndMonthName(
            'TestDay',
            '15',
            month,
            lang,
            '2015',
            false,
          );

          expect(result, isA<String>());
          if (result != null) {
            expect(result.isNotEmpty, true);
          }
        }
      }
    });
  });
}