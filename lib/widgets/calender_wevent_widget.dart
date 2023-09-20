import 'package:abushakir/abushakir.dart';
import 'package:ethiopiandatepickerandconvertor/const/app_strings.dart';
import 'package:ethiopiandatepickerandconvertor/const/enums.dart';
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
  ///

  final List<Map<String, String>> eventsList;
  final Function(String) sendUserEventData;

  /// show gregorian calender or not
  final bool displayGregorianCalender;

  /// display calender in afan oromo amharic and english
  final String userLanguage;

  /// pass color code
   final Color borderColor;
   final Color todaysDateColor;

  /// define you intial year
  int startYear;

  /// define your final year
  int endYear;

 CalenderWithEventWidget({super.key,
   this.startYear = 1950,
   this.endYear = 2030,
   required this.eventsList, required this.sendUserEventData, required this.displayGregorianCalender, required this.userLanguage, required this.borderColor, required this.todaysDateColor});




  @override
  State<CalenderWithEventWidget> createState() =>
      _CalenderWithEventWidgetState();
}

class _CalenderWithEventWidgetState extends State<CalenderWithEventWidget> {
  /// list for storing user selection
  List selectedValues = [];

  /// years lists is for year pickers
  List yearsList = [];

  /// day name
  String dayName = '';

  /// both comparsion related lists help us to compare values and set color and etc functions
  List compareTappedDates = [];

  /// single tapped
  List compareLongPressedDates = [];

  /// long press

  /// other lists like tappedDates will be set to response or results after button click
  List tappedDates = [];

  List pickedValues = [];

  /// for user range or UI
  String? firstDateForUser;

  String? endDateForUser;

  ///out put or UI related
  List forUserOutPut = [];

  List rangeForUserOutPut = [];

  /// long tap range pickers
  List longTapPickedRange = [];

  /// value related
  int initialDate = -1;

  int endDate = -1;

  /// did user starts to select dates
  bool firstDateAdded = false;

  bool endDateAdded = false;

  /// those below will me to determine whether user is removing or clicking if counter is >1
  int firstNumberClickCounter = 0;

  int secondNumberClickCounter = 0;

  /// below the list will include first and end number
  List firstDateAndLastDate = [];

  /// for user range
  String? endDateOutPut;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlertCalenderControllerBloc,
        AlertCalenderControllerState>(
      buildWhen: (previous, current) {
        return previous == current || previous != current;
      },
      listener: (context, state) {
        // TODO: implement listener

        if (state is SetDayNameState) {
          dayName = state.dayName;
        }
        if (state is GetYearsListState) {
          yearsList = state.yearsList;
        }
      },
      builder: (context, state) {
        return yearsList.isEmpty
            ? Material(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: padding80(context),
                      bottom: padding80(context),
                      left: padding15(context),
                      right: padding15(context)),
                  child: Container(
                    color: LibColors.whiteColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          color: LibThemeColor(context),
                          width: double.infinity,
                          height: height200(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.all(padding8(context)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    dayName.isEmpty
                                        ? Text(
                                            returnDayAndMonthName(
                                                dayName,
                                                ' ${state.currentMoment.day}',
                                                '${state.currentMoment.monthName}',
                                                widget.userLanguage,
                                                '${state.currentMoment.year}',
                                                false)!,
                                            style: EthiopianDatePickerFont
                                                    .textFont()
                                                .copyWith(
                                                    fontSize:
                                                        textFont025(context),
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        LibColors.whiteColor),
                                          )
                                        : Text(
                                            returnDayAndMonthName(
                                                dayName,
                                                ' ${state.currentMoment.day}',
                                                '${state.currentMoment.monthName}',
                                                widget.userLanguage,
                                                '${state.currentMoment.year}',
                                                false)!,
                                            style: EthiopianDatePickerFont
                                                    .textFont()
                                                .copyWith(
                                                    fontSize:
                                                        textFont025(context),
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        LibColors.whiteColor),
                                          ),
                                    Material(
                                      color: Theme.of(context).primaryColor,
                                      child: IconButton(
                                        iconSize: iconSize20(context),
                                        icon: const Icon(
                                          Icons.edit,
                                          color: LibColors.whiteColor,
                                        ),
                                        // the method which is called
                                        // when button is pressed
                                        onPressed: () {
                                          BlocProvider.of<
                                                      AlertCalenderControllerBloc>(
                                                  context)
                                              .add(GetYearList(widget.startYear,
                                                  widget.endYear));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Material(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child:
                                        _actions(context, state.currentMoment)),
                                abbrivatedDaysList(),
                                Flexible(
                                  child: GestureDetector(
                                    onPanEnd: (e) {
                                      if (e.velocity.pixelsPerSecond.dx < 0) {
                                        BlocProvider.of<
                                                    AlertCalenderControllerBloc>(
                                                context)
                                            .add(NextMonthCalendar(
                                                state.currentMoment));
                                      } else if (e.velocity.pixelsPerSecond.dx >
                                          0) {
                                        BlocProvider.of<
                                                    AlertCalenderControllerBloc>(
                                                context)
                                            .add(PrevMonthCalendar(
                                                state.currentMoment));
                                      }
                                    },
                                    child: _daysListGridList(context,
                                        state.currentMoment, tappedDates),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Material(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: padding80(context),
                      bottom: padding80(context),
                      left: padding15(context),
                      right: padding15(context)),
                  child: Container(
                    color: LibColors.whiteColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          color: Theme.of(context).primaryColor,
                          width: double.infinity,
                          height: height200(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                  padding: EdgeInsets.all(padding8(context)),
                                  child: Text(
                                    " ${state.currentMoment.year}",
                                    textAlign: TextAlign.start,
                                    style: EthiopianDatePickerFont.textFont()
                                        .copyWith(
                                            fontSize: textFont025(context),
                                            color: LibColors.whiteColor),
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 100,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              itemCount: yearsList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Material(
                                  child: InkWell(
                                      onTap: () {
                                        BlocProvider.of<
                                                    AlertCalenderControllerBloc>(
                                                context)
                                            .add(GetSelectedIndex(
                                                index,
                                                widget.startYear,
                                                widget.endYear,
                                                yearsList[index]));
                                      },
                                      child: Text(
                                        yearsList[index].toString(),
                                        style:
                                            EthiopianDatePickerFont.textFont()
                                                .copyWith(
                                                    fontSize:
                                                        textFont025(context),
                                                    color:
                                                        LibColors.blackColor),
                                      )),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  _actions(BuildContext context, ETC currentMoment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: LibColors.blackColor,
          iconSize: iconSize16(context),
          onPressed: () {
            BlocProvider.of<AlertCalenderControllerBloc>(context)
                .add(PrevMonthCalendar(currentMoment));
          },
        ),
        Text('${currentMoment.monthName}',
         // returnDayAndMonthName(dayName, '', '${currentMoment.monthName}',
          //    widget.userLanguage, '', true)!,
          style: EthiopianDatePickerFont.textFont().copyWith(
              fontSize: textFont025(context),
              fontWeight: FontWeight.bold,
              color: LibColors.blackColor),
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

  _daysListGridList(BuildContext context, ETC currentMoment, List tappedDates) {
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
                .add(GetDayName(index, crossAxisCount, widget.userLanguage));
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: verticalPadding098(context),
                  horizontal: horizontalPadding18(context)),
              child: GestureDetector(
                onTap: () {
                  /// TODO pop if event
                  clickResponse(widget.eventsList,
                      '${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][0]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][1]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}');
                },
                child: Container(
                  alignment: Alignment.center,
                  height: height12(context),
                  width: width203(context),
                  decoration: BoxDecoration(
                    color: widget.todaysDateColor,
                    border: Border.all(
                      color: haveData(widget.eventsList,
                          '${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][0]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][1]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}') ==
                          true
                          ? widget.borderColor
                          : LibColors.blackColor,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}",
                      style: TextStyle(
                        color: haveData(widget.eventsList,
                            '${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][0]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][1]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}') ==
                            true
                            ? LibColors.redColor
                            : LibColors.blackColor,
                      ),
                    ),
                    widget.displayGregorianCalender?Text(
                      ethiopianToGregorianDateConvertor(
                        currentMoment.monthDays().toList()[
                        (index - currentMoment.monthDays().toList()[0][3])
                            .toInt()][2],
                        currentMoment,
                        true,
                      ),
                      style: TextStyle(
                        color: haveData(widget.eventsList,
                            '${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][0]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][1]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}') ==
                            true
                            ? LibColors.redColor
                            : LibColors.blackColor,
                        fontSize: textFont07(context),
                      ),
                    ):Container(),
                  ],
                )),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: 1, horizontal: horizontalPadding18(context)),
            child: GestureDetector(
              onTap: () {
                clickResponse(widget.eventsList,
                    '${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][0]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][1]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}');
              },
              child: Container(
                  alignment: Alignment.center,
                  height: height12(context),
                  width: width203(context),
                  decoration: BoxDecoration(
                    color: LibColors.grey300,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: haveData(widget.eventsList,
                                  '${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][0]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][1]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}') ==
                              true
                          ? widget.borderColor
                          : LibColors.blackColor,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}",
                        style: TextStyle(
                          color: haveData(widget.eventsList,
                                      '${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][0]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][1]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}') ==
                                  true
                              ? LibColors.redColor
                              : LibColors.blackColor,
                        ),
                      ),
                      widget.displayGregorianCalender?Text(
                        ethiopianToGregorianDateConvertor(
                          currentMoment.monthDays().toList()[
                              (index - currentMoment.monthDays().toList()[0][3])
                                  .toInt()][2],
                          currentMoment,
                          true,
                        ),
                        style: TextStyle(
                          color: haveData(widget.eventsList,
                                      '${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][0]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][1]}-${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}') ==
                                  true
                              ? LibColors.redColor
                              : LibColors.blackColor,
                          fontSize: textFont07(context),
                        ),
                      ):Container(),
                    ],
                  )),
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
            returnAbrivateWeekNames(map.value, widget.userLanguage)!,
            style: EthiopianDatePickerFont.textFont().copyWith(
                color: LibColors.blackColor, fontWeight: FontWeight.bold),
          );
        }).toList());
  }

  bool haveData(List<Map<String, String>> eventsList, String s) {
    for (int i = 0; i < eventsList.length; i++) {
      if (s == eventsList[i]['date']) {
        return true;
      }
    }
    return false; // Move the return false statement outside the for loop
  }

  String clickResponse(List<Map<String, String>> eventsList, String s) {
    for (int i = 0; i < eventsList.length; i++) {
      if (s == eventsList[i]['date']) {
        String title = eventsList[i]['title'] ?? '';
        String description = eventsList[i]['description'] ?? '';
        widget.sendUserEventData(title + description);

        return title + description;
      }
    }
    return 'null';
  }
}
