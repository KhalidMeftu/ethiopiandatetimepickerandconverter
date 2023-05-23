import 'package:abushakir/abushakir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../const/lib_colors.dart';
import '../const/lib_fonts.dart';
import '../const/lib_functions.dart';
import '../const/ui_helper.dart';
import '../controller/alert_calender_bloc/alert_calender_controller_bloc.dart';

class CalenderWithEventWidget extends StatefulWidget {
  /// int of our map value will contain date
  /// List will have event title, description
  /// this will require only events just map of events
  /// those events will have int dates and event title and event description
  /// the on tap function will trigger callbacks will fire for you an alert or navigate to new page
  final Map<int, List> eventsList;
  final Function onTap;

  const CalenderWithEventWidget({Key? key, required this.eventsList, required this.onTap})
      : super(key: key);

  @override
  State<CalenderWithEventWidget> createState() =>
      _CalenderWithEventWidgetState();
}

class _CalenderWithEventWidgetState extends State<CalenderWithEventWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: calenderWidget(widget.eventsList),
      ),
    );
  }

  Widget calenderWidget(Map<int, List> eventsList) {
    return BlocBuilder<AlertCalenderControllerBloc,
        AlertCalenderControllerState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
              top: padding80(context),
              bottom: padding80(context),
              left: padding15(context),
              right: padding15(context)),
          child: Container(
            color: LibColors.whiteColor,
            child: Column(
              children: [
                Expanded(
                  child: Material(
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: _Actions(context, state.currentMoment)),
                        abbrivatedDaysList(),

                        Expanded(
                          child: GestureDetector(
                            onPanEnd: (e) {
                              if (e.velocity.pixelsPerSecond.dx < 0) {
                                BlocProvider.of<AlertCalenderControllerBloc>(
                                        context)
                                    .add(
                                        NextMonthCalendar(state.currentMoment));
                              } else if (e.velocity.pixelsPerSecond.dx > 0) {
                                BlocProvider.of<AlertCalenderControllerBloc>(
                                        context)
                                    .add(
                                        PrevMonthCalendar(state.currentMoment));
                              }
                            },
                            child:
                                _daysListGridList(context, state.currentMoment),
                          ),
                        ),

                        // Expanded(child: _daysGridList(context, month)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _Actions(BuildContext context, ETC currentMoment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: Colors.black,
          iconSize: iconSize16(context),
          onPressed: () {
            BlocProvider.of<AlertCalenderControllerBloc>(context)
                .add(PrevMonthCalendar(currentMoment));
          },
        ),
        Text(
          "${currentMoment.monthName}, ${currentMoment.year}",
          style: LibFont.textFont().copyWith(
              fontSize: textFont025(context),
              fontWeight: FontWeight.bold,
              color: LibColors.whiteColor),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          iconSize: iconSize16(context),
          onPressed: () {
            BlocProvider.of<AlertCalenderControllerBloc>(context)
                .add(NextMonthCalendar(currentMoment));
          },
        ),
      ],
    );
  }

  _daysListGridList(BuildContext context, ETC currentMoment) {
    int crossAxisCount = 7;
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding(context),
        vertical: verticalPadding(context),
      ),
      crossAxisCount: crossAxisCount,
      children: List.generate(
          (currentMoment.monthDays().toList().length +
                  currentMoment.monthDays().toList()[0][3])
              .toInt(), (index) {
        if (currentMoment.monthDays().toList()[0][3] > 0 &&
            index < currentMoment.monthDays().toList()[0][3]) {
          return InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: verticalPadding098(context),
                  horizontal: horizontalPadding18(context)),
              child: Container(
                alignment: Alignment.center,
                height: height12(context),
                width: width203(context),
                decoration: BoxDecoration(
                  color: LibColors.grey100,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Text(
                  "",
                ),
              ),
            ),
          );
        } else {
          /// we will mark today here
          if (currentMoment.monthDays().toList()[
                      (index - currentMoment.monthDays().toList()[0][3])
                          .toInt()][0] ==
                  EtDatetime.now().year &&
              currentMoment.monthDays().toList()[
                      (index - currentMoment.monthDays().toList()[0][3])
                          .toInt()][1] ==
                  EtDatetime.now().month &&
              currentMoment.monthDays().toList()[
                      (index - currentMoment.monthDays().toList()[0][3])
                          .toInt()][2] ==
                  EtDatetime.now().day) {
            BlocProvider.of<AlertCalenderControllerBloc>(context)
                .add(GetDayName(index, crossAxisCount));
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: verticalPadding098(context),
                  horizontal: horizontalPadding18(context)),
              child: InkWell(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: height12(context),
                  width: width203(context),
                  decoration: BoxDecoration(
                    color: LibColors.red300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                          "${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ethiopianToGregorianDateConvertor(
                              currentMoment.monthDays().toList()[(index -
                                      currentMoment.monthDays().toList()[0][3])
                                  .toInt()][2],
                              currentMoment,
                              true),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: 1, horizontal: horizontalPadding18(context)),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                height: height12(context),
                width: width203(context),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Text(
                        "${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ethiopianToGregorianDateConvertor(
                            currentMoment.monthDays().toList()[(index -
                                    currentMoment.monthDays().toList()[0][3])
                                .toInt()][2],
                            currentMoment,
                            true),
                        style: TextStyle(color: Colors.black, fontSize: 7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  Widget abbrivatedDaysList() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.asMap().entries.map((MapEntry map) {
          return Text(
            map.value,
            style: LibFont.textFont().copyWith(
                color: LibColors.blackColor, fontWeight: FontWeight.bold),
          );
        }).toList());
  }
}
