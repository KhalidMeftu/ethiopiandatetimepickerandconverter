import 'package:ethiopiandatepickerandconvertor/controller/alert_calender_bloc/alert_calender_controller_bloc.dart';
import 'package:ethiopiandatepickerandconvertor/widgets/calender_wevent_widget.dart';
import 'package:ethiopiandatepickerandconvertor/widgets/date_picker_alret.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> events = [
    {'date': '2015-12-28', 'title': 'Event 1', 'description': 'Description 1'},
    {'date': '2015-5-1', 'title': 'Event 2', 'description': 'Description 2'},
    {'date': '2015-12-24', 'title': 'Event 3', 'description': 'Description 2'},
    {'date': '2015-13-3', 'title': 'Event 4', 'description': 'Description 4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// final bool displayGregorianCalender;
      //   final bool amharicLanguageMode;
      //   final bool colorStatus;
      //   final int startYear;
      //   final int endYear;
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              List? val = await showDialog<List>(
                context: context,
                builder: (_) {
                  return BlocProvider.value(
                    value:
                        BlocProvider.of<AlertCalenderControllerBloc>(context),
                    child: AlertDatePicker(
                      displayGregorianCalender: false,
                      userLanguage: "ao",
                      startYear: 1990,
                      endYear: 2020,
                      todaysDateBackgroundColor: Colors.greenAccent,
                    ),
                  );
                },
              );
              print('Dialog one returned value ---> $val');
            },
            child: const Text('Show Dialog One'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BlocProvider.value(
                    value:
                        BlocProvider.of<AlertCalenderControllerBloc>(context),
                    child: CalenderWithEventWidget(
                      borderColor: Colors.yellow,
                      todaysDateColor: Colors.purpleAccent,
                      displayGregorianCalender: true,
                      userLanguage: "ao",
                      startYear: 1990,
                      endYear: 2020,
                      eventsList: events,
                      sendUserEventData: (data) {
                        print("Received data: $data");
                      },
                    ),
                  ),
                ),
              );
            },
            child: const Text('Calendar with events'),
          ),


          ElevatedButton(
            onPressed: () async {
              List? val = await showDialog<List>(
                context: context,
                builder: (_) {
                  return BlocProvider.value(
                    value:
                    BlocProvider.of<AlertCalenderControllerBloc>(context),
                    child: AlertDatePicker(
                      displayGregorianCalender: false,
                      userLanguage: "am",
                      startYear: 1990,
                      endYear: 2020,
                      todaysDateBackgroundColor: Colors.greenAccent,
                    ),
                  );
                },
              );
              print('Dialog one returned value ---> $val');
            },
            child: const Text('Show Dialog One am'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value:
                    BlocProvider.of<AlertCalenderControllerBloc>(context),
                    child: CalenderWithEventWidget(
                      borderColor: Colors.yellow,
                      todaysDateColor: Colors.purpleAccent,
                      displayGregorianCalender: true,
                      userLanguage: "am",
                      startYear: 1990,
                      endYear: 2020,
                      eventsList: events,
                      sendUserEventData: (data) {
                        print("Received data: $data");
                      },
                    ),
                  ),
                ),
              );
            },
            child: const Text('Calendar with events am'),
          ),
        ],
      ),
    );
  }
}
