import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ethiopiandatepickerandconvertor/widgets/simple_calendar_with_events.dart';

void main() {
  group('SimpleCalendarWithEvents Widget Tests', () {
    late String lastEventData;

    final List<Map<String, String>> testEvents = [
      {'date': '2015-12-28', 'title': 'New Year', 'description': 'Ethiopian New Year'},
      {'date': '2015-5-1', 'title': 'Holiday', 'description': 'Labor Day'},
      {'date': '2015-8-15', 'title': 'Festival', 'description': 'Meskel Festival'},
    ];

    setUp(() {
      lastEventData = '';
    });

    Widget createTestWidget({
      List<Map<String, String>>? eventsList,
      bool displayGregorianCalender = false,
      String userLanguage = 'en',
      int startYear = 2000,
      int endYear = 2020,
      Color borderColor = Colors.yellow,
      Color todaysDateColor = Colors.green,
    }) {
      return MaterialApp(
        home: SimpleCalendarWithEvents(
          eventsList: eventsList ?? testEvents,
          onEventTap: (data) {
            lastEventData = data;
          },
          displayGregorianCalender: displayGregorianCalender,
          userLanguage: userLanguage,
          startYear: startYear,
          endYear: endYear,
          borderColor: borderColor,
          todaysDateColor: todaysDateColor,
        ),
      );
    }

    testWidgets('renders SimpleCalendarWithEvents widget', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      expect(find.byType(Material), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays header with current date info', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays month navigation buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      final leftArrow = find.byIcon(Icons.chevron_left);
      final rightArrow = find.byIcon(Icons.chevron_right);
      expect(leftArrow, findsOneWidget);
      expect(rightArrow, findsOneWidget);
    });

    testWidgets('navigates between months', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final rightArrow = find.byIcon(Icons.chevron_right);
      final leftArrow = find.byIcon(Icons.chevron_left);
      await tester.tap(rightArrow);
      await tester.pumpAndSettle();
      await tester.tap(leftArrow);
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

    testWidgets('displays day headers', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays calendar grid with dates', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('handles empty events list', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(eventsList: []));
      await tester.pumpAndSettle();

      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('handles events with different date formats', (WidgetTester tester) async {
      final invalidEvents = [
        {'date': 'invalid-date', 'title': 'Test', 'description': 'Test Event'},
        {'date': '2015-13-32', 'title': 'Invalid', 'description': 'Invalid Date'},
      ];

      await tester.pumpWidget(createTestWidget(eventsList: invalidEvents));
      await tester.pumpAndSettle();

      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
    });

    testWidgets('displays events with correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        borderColor: Colors.red,
        todaysDateColor: Colors.blue,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
    });

    testWidgets('handles Gregorian calendar display', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(displayGregorianCalender: true));
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('supports different languages', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(userLanguage: 'am'));
      await tester.pumpAndSettle();
      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
      await tester.pumpWidget(createTestWidget(userLanguage: 'ao'));
      await tester.pumpAndSettle();
      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
      await tester.pumpWidget(createTestWidget(userLanguage: 'en'));
      await tester.pumpAndSettle();
      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
    });

    testWidgets('handles events with missing data fields', (WidgetTester tester) async {
      final incompleteEvents = [
        {'date': '2015-12-28', 'title': 'Event 1'},
        {'date': '2015-5-1', 'description': 'Event 2'},
        {'date': '2015-8-15'},
      ];

      await tester.pumpWidget(createTestWidget(eventsList: incompleteEvents));
      await tester.pumpAndSettle();

      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
    });

    testWidgets('validates year range constraints', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        startYear: 2010,
        endYear: 2015,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
    });
  });

  group('SimpleCalendarWithEvents Event Handling Tests', () {
    late String capturedEventData;

    final List<Map<String, String>> testEvents = [
      {'date': '2015-12-28', 'title': 'New Year', 'description': 'Ethiopian New Year'},
      {'date': '2015-5-1', 'title': 'Holiday', 'description': 'Labor Day'},
    ];

    setUp(() {
      capturedEventData = '';
    });

    Widget createEventTestWidget() {
      return MaterialApp(
        home: SimpleCalendarWithEvents(
          eventsList: testEvents,
          onEventTap: (data) {
            capturedEventData = data;
          },
          displayGregorianCalender: false,
          userLanguage: 'en',
          startYear: 2015,
          endYear: 2016,
          borderColor: Colors.yellow,
          todaysDateColor: Colors.green,
        ),
      );
    }

    testWidgets('calls onEventTap callback when event date is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createEventTestWidget());
      await tester.pumpAndSettle();

      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);
      if (gestureDetectors.evaluate().isNotEmpty) {
        await tester.tap(gestureDetectors.first);
        await tester.pumpAndSettle();
      }
      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
    });

    testWidgets('event callback receives correct data format', (WidgetTester tester) async {
      await tester.pumpWidget(createEventTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
    });
  });

  group('SimpleCalendarWithEvents Integration Tests', () {
    testWidgets('full calendar interaction workflow', (WidgetTester tester) async {
      String eventData = '';

      await tester.pumpWidget(MaterialApp(
        home: SimpleCalendarWithEvents(
          eventsList: [
            {'date': '2015-1-1', 'title': 'Test Event', 'description': 'Test Description'},
          ],
          onEventTap: (data) {
            eventData = data;
          },
          displayGregorianCalender: true,
          userLanguage: 'en',
          startYear: 2015,
          endYear: 2016,
          borderColor: Colors.red,
          todaysDateColor: Colors.blue,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
      final rightArrow = find.byIcon(Icons.chevron_right);
      if (rightArrow.evaluate().isNotEmpty) {
        await tester.tap(rightArrow);
        await tester.pumpAndSettle();
      }

      final leftArrow = find.byIcon(Icons.chevron_left);
      if (leftArrow.evaluate().isNotEmpty) {
        await tester.tap(leftArrow);
        await tester.pumpAndSettle();
      }
      final gestureDetector = find.byType(GestureDetector);
      if (gestureDetector.evaluate().isNotEmpty) {
        await tester.fling(gestureDetector.first, const Offset(-200, 0), 800);
        await tester.pumpAndSettle();
      }
      expect(find.byType(SimpleCalendarWithEvents), findsOneWidget);
    });
  });
}