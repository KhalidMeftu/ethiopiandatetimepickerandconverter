import 'package:ethiopiandatepickerandconvertor/widgets/simple_date_picker.dart';
import 'package:ethiopiandatepickerandconvertor/widgets/simple_calendar_with_events.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> events = [
    {'date': '2018-1-15', 'title': 'New Year Event', 'description': 'Ethiopian New Year Celebration'},
    {'date': '2018-2-10', 'title': 'Meeting', 'description': 'Team meeting at 10 AM'},
    {'date': '2018-3-5', 'title': 'Conference', 'description': 'Tech conference'},
    {'date': '2018-4-20', 'title': 'Birthday', 'description': 'Birthday celebration'},
    {'date': '2018-5-1', 'title': 'Event 2', 'description': 'Description 2'},
    {'date': '2018-6-1', 'title': 'Holiday', 'description': 'Public holiday'},
    {'date': '2018-7-12', 'title': 'Training', 'description': 'Staff training session'},
    {'date': '2018-8-8', 'title': 'Workshop', 'description': 'Development workshop'},
    {'date': '2018-9-25', 'title': 'Festival', 'description': 'Cultural festival'},
    {'date': '2018-10-3', 'title': 'Seminar', 'description': 'Educational seminar'},
    {'date': '2018-11-18', 'title': 'Graduation', 'description': 'Graduation ceremony'},
    {'date': '2018-12-24', 'title': 'Event 3', 'description': 'Description 3'},
    {'date': '2018-12-28', 'title': 'Event 1', 'description': 'Description 1'},
    {'date': '2018-12-30', 'title': 'Year End Party', 'description': 'End of year celebration'},
    {'date': '2018-13-3', 'title': 'Event 4', 'description': 'Description 4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethiopian Date Picker Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ethiopian Date Picker',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await showDialog<List<String>>(
                  context: context,
                  builder: (_) {
                    return SimpleDatePicker(
                      displayGregorianCalender: false,
                      userLanguage: "ao",
                      startYear: 1990,
                      endYear: 2020,
                      todaysDateBackgroundColor: Colors.greenAccent,
                      onDatesSelected: (selectedDates) {
                        debugPrint('Selected dates (Afan Oromo): $selectedDates');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected: ${selectedDates.join(", ")}'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: const Text('Date Picker (Afan Oromo)'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                await showDialog<List<String>>(
                  context: context,
                  builder: (_) {
                    return SimpleDatePicker(
                      displayGregorianCalender: true,
                      userLanguage: "am",
                      startYear: 1990,
                      endYear: 2020,
                      todaysDateBackgroundColor: Colors.greenAccent,
                      onDatesSelected: (selectedDates) {
                        debugPrint('Selected dates (Amharic): $selectedDates');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected: ${selectedDates.join(", ")}'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: const Text('Date Picker (Amharic) with Gregorian'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                await showDialog<List<String>>(
                  context: context,
                  builder: (_) {
                    return SimpleDatePicker(
                      displayGregorianCalender: false,
                      userLanguage: "en",
                      startYear: 1990,
                      endYear: 2020,
                      todaysDateBackgroundColor: Colors.greenAccent,
                      onDatesSelected: (selectedDates) {
                        debugPrint('Selected dates (English): $selectedDates');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected: ${selectedDates.join(", ")}'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: const Text('Date Picker (English)'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SimpleCalendarWithEvents(
                      borderColor: Colors.yellow,
                      todaysDateColor: Colors.purpleAccent,
                      displayGregorianCalender: true,
                      userLanguage: "ao",
                      startYear: 1990,
                      endYear: 2020,
                      eventsList: events,
                      onEventTap: (data) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Event: $data'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: const Text('Calendar with Events (Oromo)'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SimpleCalendarWithEvents(
                      borderColor: Colors.red,
                      todaysDateColor: Colors.orange,
                      displayGregorianCalender: false,
                      userLanguage: "am",
                      startYear: 1990,
                      endYear: 2020,
                      eventsList: events,
                      onEventTap: (data) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Event: $data'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: const Text('Calendar with Events (Amharic)'),
            ),
          ],
        ),
      ),
    );
  }
}
