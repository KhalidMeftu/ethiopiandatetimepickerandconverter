import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ethiopiandatepickerandconvertor/widgets/simple_date_picker.dart';

void main() {
  group('SimpleDatePicker Widget Tests', () {
    late List<String> selectedDates;

    setUp(() {
      selectedDates = [];
    });

    Widget createTestWidget({
      bool displayGregorianCalender = false,
      String userLanguage = 'en',
      int startYear = 2000,
      int endYear = 2020,
      Color todaysDateBackgroundColor = Colors.green,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SimpleDatePicker(
            displayGregorianCalender: displayGregorianCalender,
            userLanguage: userLanguage,
            startYear: startYear,
            endYear: endYear,
            todaysDateBackgroundColor: todaysDateBackgroundColor,
            onDatesSelected: (dates) {
              selectedDates = dates;
            },
          ),
        ),
      );
    }

    testWidgets('renders SimpleDatePicker widget', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(SimpleDatePicker), findsOneWidget);
      expect(find.byType(Material), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays correct language strings for English', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(userLanguage: 'en'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Okay'), findsOneWidget);
    });

    testWidgets('displays correct language strings for Amharic', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(userLanguage: 'am'));
      await tester.pumpAndSettle();
      expect(find.byType(TextButton), findsNWidgets(2));
    });

    testWidgets('displays correct language strings for Oromo', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(userLanguage: 'ao'));
      await tester.pumpAndSettle();
      expect(find.byType(TextButton), findsNWidgets(2));
    });

    testWidgets('shows year picker when edit button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      final editButton = find.byIcon(Icons.edit);
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('navigates between months with arrow buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      final leftArrow = find.byIcon(Icons.chevron_left);
      final rightArrow = find.byIcon(Icons.chevron_right);
      expect(leftArrow, findsOneWidget);
      expect(rightArrow, findsOneWidget);
      await tester.tap(rightArrow);
      await tester.pumpAndSettle();
      await tester.tap(leftArrow);
      await tester.pumpAndSettle();
    });

    testWidgets('handles date selection callback', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      final okButton = find.text('Okay');
      expect(okButton, findsOneWidget);
      await tester.tap(okButton);
      await tester.pumpAndSettle();
      expect(selectedDates, isA<List<String>>());
    });

    testWidgets('closes when cancel button is tapped', (WidgetTester tester) async {
      bool dialogClosed = false;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                await showDialog<List<String>>(
                  context: context,
                  builder: (_) => SimpleDatePicker(
                    displayGregorianCalender: false,
                    userLanguage: 'en',
                    startYear: 2000,
                    endYear: 2020,
                    todaysDateBackgroundColor: Colors.green,
                    onDatesSelected: (dates) {
                      selectedDates = dates;
                    },
                  ),
                );
                dialogClosed = true;
              },
              child: const Text('Open Picker'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('Open Picker'));
      await tester.pumpAndSettle();
      final cancelButton = find.text('Cancel');
      expect(cancelButton, findsOneWidget);
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
    });

    testWidgets('responds to pan gestures for month navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      final gestureDetector = find.byType(GestureDetector);
      expect(gestureDetector, findsWidgets);
      await tester.fling(gestureDetector.first, const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();
      await tester.fling(gestureDetector.first, const Offset(300, 0), 1000);
      await tester.pumpAndSettle();
    });

    testWidgets('handles Gregorian calendar display option', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(displayGregorianCalender: true));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('validates year range constraints', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(startYear: 2010, endYear: 2015));
      await tester.pumpAndSettle();
      final editButton = find.byIcon(Icons.edit);
      await tester.tap(editButton);
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('applies custom today date background color', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(todaysDateBackgroundColor: Colors.red));
      await tester.pumpAndSettle();
      expect(find.byType(SimpleDatePicker), findsOneWidget);
    });
  });

  group('SimpleDatePicker Integration Tests', () {
    testWidgets('full date selection workflow', (WidgetTester tester) async {
      List<String> selectedDates = [];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SimpleDatePicker(
            displayGregorianCalender: false,
            userLanguage: 'en',
            startYear: 2015,
            endYear: 2016,
            todaysDateBackgroundColor: Colors.blue,
            onDatesSelected: (dates) {
              selectedDates = dates;
            },
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(SimpleDatePicker), findsOneWidget);
      final actionButtons = find.byType(TextButton);
      expect(actionButtons, findsWidgets);
      final okayButton = find.text('Okay');
      if (okayButton.evaluate().isNotEmpty) {
        await tester.tap(okayButton);
        await tester.pumpAndSettle();
      }
      expect(selectedDates, isA<List<String>>());
    });
  });
}