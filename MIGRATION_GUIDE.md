# Migration Guide: No State Management Required

## Overview

This library now provides simplified widgets that don't require any state management setup, making it much easier to use.

## New Simplified Widgets (Recommended)

### 1. SimpleDatePicker
A date picker that doesn't require BLoC or any state management.

```dart
import 'package:ethiopiandatepickerandconvertor/widgets/simple_date_picker.dart';

// Usage in a dialog
showDialog<List<String>>(
  context: context,
  builder: (_) {
    return SimpleDatePicker(
      displayGregorianCalender: true,
      userLanguage: "am", // "am", "ao", or "en"
      startYear: 1990,
      endYear: 2030,
      todaysDateBackgroundColor: Colors.greenAccent,
      onDatesSelected: (selectedDates) {
        print('Selected dates: $selectedDates');
        // Handle selected dates
      },
    );
  },
);
```

### 2. SimpleCalendarWithEvents
A calendar widget for displaying events without state management.

```dart
import 'package:ethiopiandatetimepickerandconvertor/widgets/simple_calendar_with_events.dart';

// Usage as a page
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SimpleCalendarWithEvents(
      borderColor: Colors.yellow,
      todaysDateColor: Colors.purpleAccent,
      displayGregorianCalender: true,
      userLanguage: "ao",
      startYear: 1990,
      endYear: 2030,
      eventsList: [
        {'date': '2015-12-28', 'title': 'Event 1', 'description': 'Description 1'},
        {'date': '2015-5-1', 'title': 'Event 2', 'description': 'Description 2'},
      ],
      onEventTap: (eventData) {
        print('Event tapped: $eventData');
        // Handle event tap
      },
    ),
  ),
);
```

## Legacy Widgets (Requires BLoC Setup)

The original widgets are still available but require BLoC state management:
- `AlertDatePicker`
- `CalenderWithEventWidget`

To use legacy widgets, add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  meta: ^1.9.1
  equatable: ^2.0.5
```

## Benefits of New Widgets

1. **No State Management Required**: No need to set up BLoC providers
2. **Simpler Integration**: Just import and use directly
3. **Callback-based**: Uses simple callbacks instead of complex state management
4. **Same Features**: All the same Ethiopian calendar functionality
5. **Better Performance**: Less overhead without state management layer

## Language Support

Both widgets support:
- `"am"` - Amharic
- `"ao"` - Afan Oromo
- `"en"` - English

## Features

- Ethiopian calendar system
- Multiple language support
- Single date selection
- Range date selection (long press to start range)
- Gregorian calendar display option
- Event display and handling
- Customizable colors
- Year picker
- Gesture navigation (swipe between months)

## Migration Steps

1. **Remove BLoC dependencies** from your `pubspec.yaml` (if only using new widgets)
2. **Replace imports**:
   - Old: `import 'package:ethiopiandatepickerandconvertor/widgets/date_picker_alret.dart';`
   - New: `import 'package:ethiopiandatepickerandconvertor/widgets/simple_date_picker.dart';`
3. **Remove BlocProvider wrappers** from your widget tree
4. **Replace state management** with simple callbacks
5. **Update widget parameters** to use the new callback-based approach

Your Ethiopian date picker is now much simpler to integrate! 🎉