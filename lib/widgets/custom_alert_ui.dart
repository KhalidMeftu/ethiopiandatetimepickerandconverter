import 'package:abushakir/abushakir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../const/app_strings.dart';
import '../const/lib_colors.dart';
import '../const/lib_fonts.dart';
import '../const/lib_functions.dart';
import '../const/ui_helper.dart';
import '../controller/alert_calender_controller_bloc.dart';

class AlertDatePicker extends StatefulWidget {
  /// rounded or rectangular
  /// amharic or english
  /// custom color or inherit app theme
  final List? pickedValues;

  ///--> picked values are dates which user selected either range dates or single values
  final bool displayGregorianCalender;
  final bool amharicLanguageMode;
  final bool colorStatus;
  final int startYear;
  final int endYear;


  const AlertDatePicker({Key? key,
    this.pickedValues,
    required this.displayGregorianCalender,
    required this.amharicLanguageMode,
    required this.colorStatus,
    required this.startYear,
    required this.endYear})
      : super(key: key);

  @override
  State<AlertDatePicker> createState() => _AlertDatePickerState();
}

class _AlertDatePickerState extends State<AlertDatePicker> {
  List selectedValues = [];
  List yearsList = [];
  String dayName = '';

  /// both comparsion related lists help us to compare values and set colo and etc functions
  List comparsionTapedDates = [];
  List longTappedComparisionDates = [];

  /// other lists like tappedDates will be set to response or results after button click
  List tappedDates = [];
  List pickedValues = [];


  /// for user range or UI
  String? firstDateForUser;
  String? endDateForUser;
  List forUser = [];
  List rangeForUser = [];


  /// long tap ranges
  List longTapPickedRange = [];


  /// value related
  int intialDate = -1;
  int endDate = -1;
  bool firstDateAdded = false;
  bool endDateAdded = false;


  /// those below will help me to determine whether user is removing or clicking if counter is >1 since
  /// single number can be added twice the logic will make it remove and remove it from list
  int firstNumberClickCounter = 0;
  int secondNumberClickCounter = 0;


  /// below the list will include first and end number
  List firstDateAndLastDate = [];


  @override
  void initState() {
    // TODO: implement initState
    selectedValues = widget.pickedValues!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlertCalenderControllerBloc,
        AlertCalenderControllerState>(
      buildWhen: (previous, current) {
        return previous == current || previous != current;
      },
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is SetSelectedIndexState) {
          return Padding(
            padding: EdgeInsets.only(
                top: padding80(context),
                bottom: padding80(context),
                left: padding15(context),
                right: padding15(context)),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    width: double.infinity,
                    height: height200(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(padding8(context)),
                          child: widget.amharicLanguageMode
                              ? Text(
                            LibAmharicStrings.selectYear,
                            textAlign: TextAlign.start,
                            style: LibFont.textFont().copyWith(
                                fontSize: textFont025(context),
                                color: LibColors.white70),
                          )
                              : Text(
                            LibEnglishStrings.selectYear,
                            textAlign: TextAlign.start,
                            style: LibFont.textFont().copyWith(
                                fontSize: textFont025(context),
                                color: LibColors.white70),

                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: EdgeInsets.all(padding8(context)),
                            child: Text(
                              " ${state.selectedYear}",
                              textAlign: TextAlign.start,
                              style: LibFont.textFont()
                                  .copyWith(fontSize: textFont025(context)),
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
                        itemCount: state.yearsList.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Material(
                            child: InkWell(
                                onTap: () {
                                  /// user clicked the some number so cancel it

                                  if (index == state.selectedIndex) {
                                    BlocProvider.of<
                                        AlertCalenderControllerBloc>(context)
                                        .add(GetYearList(
                                        widget.startYear, widget.endYear));
                                  } else if (index != state.selectedIndex) {
                                    /// change the bloc
                                    BlocProvider.of<
                                        AlertCalenderControllerBloc>(context)
                                        .add(GetYearList(
                                        widget.startYear, widget.endYear));
                                    BlocProvider.of<
                                        AlertCalenderControllerBloc>(context)
                                        .add(GetSelectedIndex(
                                        index, widget.startYear, widget.endYear,
                                        state.yearsList[index]));
                                  }
                                },
                                child: Text(
                                  state.yearsList[index].toString(),
                                  style: LibFont.textFont().copyWith(
                                      fontSize: textFont025(context),
                                      color: state.selectedIndex == index
                                          ? LibColors.redColor
                                          : LibColors.blackColor),
                                )),
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding8(context)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.amharicLanguageMode
                            ? Text(
                          LibAmharicStrings.cancel,
                          style: LibFont.textFont().copyWith(
                              fontSize: textFont025(context),
                              color: Theme
                                  .of(context)
                                  .primaryColor),
                        )
                            : Text(
                          LibEnglishStrings.cancel,
                          style: LibFont.textFont().copyWith(
                              fontSize: textFont025(context),
                              color: Theme
                                  .of(context)
                                  .primaryColor),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Material(
                          child: InkWell(
                              onTap: () {
                                yearsList = [];
                                BlocProvider.of<AlertCalenderControllerBloc>(
                                    context).add(
                                    CalenderByYear(state.currentMoment,
                                        state.selectedYear));
                              },
                              child: widget.amharicLanguageMode
                                  ? Text(
                                LibAmharicStrings.okay,
                                style: LibFont.textFont().copyWith(
                                    fontSize: textFont025(context),
                                    color:
                                    Theme
                                        .of(context)
                                        .primaryColor),
                              )
                                  : Text(
                                LibEnglishStrings.okay,
                                style: LibFont.textFont().copyWith(
                                    fontSize: textFont025(context),
                                    color:
                                    Theme
                                        .of(context)
                                        .primaryColor),
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return yearsList.isEmpty
            ? Padding(
          padding: EdgeInsets.only(
              top: padding80(context),
              bottom: padding80(context),
              left: padding15(context),
              right: padding15(context)),
          child: Container(
            color: LibColors.whiteColor,
            child: Column(
              children: [


                Container(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  width: double.infinity,
                  height: height200(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(padding8(context)),
                        child: widget.amharicLanguageMode
                            ? Text(
                          LibAmharicStrings.selectYear,
                          textAlign: TextAlign.start,
                          style: LibFont.textFont().copyWith(
                              fontSize: textFont025(context),
                              color: LibColors.white70),
                        )
                            : Text(
                          LibEnglishStrings.selectYear,
                          textAlign: TextAlign.start,
                          style: LibFont.textFont().copyWith(
                              fontSize: textFont025(context),
                              color: LibColors.white70),

                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: EdgeInsets.all(padding8(context)),
                          child: Text(
                            " ${state.currentMoment.year}",
                            textAlign: TextAlign.start,
                            style: LibFont.textFont().copyWith(
                                fontSize: textFont025(context),
                                fontWeight: FontWeight.bold,
                                color: LibColors.whiteColor),

                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(padding8(context)),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            dayName.isEmpty
                                ? Text(
                              "${state.currentMoment.day}, ${state.currentMoment
                                  .monthName}",
                              style: LibFont.textFont().copyWith(
                                  fontSize: textFont025(context),
                                  fontWeight: FontWeight.bold,
                                  color: LibColors.whiteColor),

                            )
                                : Text(
                              "$dayName, ${state.currentMoment.day}, ${state
                                  .currentMoment
                                  .monthName}",
                              style: LibFont.textFont().copyWith(
                                  fontSize: textFont025(context),
                                  fontWeight: FontWeight.bold,
                                  color: LibColors.whiteColor),
                            ),
                            Material(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              child: IconButton(
                                iconSize: iconSize20(context),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                // the method which is called
                                // when button is pressed
                                onPressed: () {
                                  BlocProvider.of<AlertCalenderControllerBloc>(
                                      context)
                                      .add(GetYearList(
                                      widget.startYear, widget.endYear));
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
                        // yearSelectMode==true?Container():
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child:
                            _Actions(context, state.currentMoment)),
                        abbrivatedDaysList(),

                        Expanded(
                          child: GestureDetector(
                            onPanEnd: (e) {
                              if (e.velocity.pixelsPerSecond.dx < 0) {
                                BlocProvider.of<AlertCalenderControllerBloc>(
                                    context)
                                    .add(
                                    NextMonthCalendar(state.currentMoment));
                              } else if (e.velocity.pixelsPerSecond.dx >
                                  0) {
                                BlocProvider.of<AlertCalenderControllerBloc>(
                                    context)
                                    .add(
                                    PrevMonthCalendar(state.currentMoment));
                              }
                            },
                            child: _daysListGridList(
                                context, state.currentMoment, tappedDates),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.amharicLanguageMode
                                  ? Text(
                                LibAmharicStrings.cancel,
                                style: LibFont.textFont().copyWith(
                                    fontSize: textFont025(context),
                                    color: Theme
                                        .of(context)
                                        .primaryColor),
                              )
                                  : Text(
                                LibEnglishStrings.cancel,
                                style: LibFont.textFont().copyWith(
                                    fontSize: textFont025(context),
                                    color: Theme
                                        .of(context)
                                        .primaryColor),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                  onTap: () {
                                    if (comparsionTapedDates.isNotEmpty) {
                                      /// working fine
                                      pickedValues = comparsionTapedDates;
                                    }
                                    if (longTappedComparisionDates
                                        .isNotEmpty) {
                                      /// adding to end of it
                                      pickedValues = rangeForUser;
                                    }
                                    Navigator.pop(context, pickedValues);
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color:
                                      Theme
                                          .of(context)
                                          .primaryColor,
                                    ),
                                  ))
                            ],
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
        )
            : Padding(
          padding: EdgeInsets.only(
              top: padding80(context),
              bottom: padding80(context),
              left: padding15(context),
              right: padding15(context)),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  width: double.infinity,
                  height: height200(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(padding8(context)),
                        child: widget.amharicLanguageMode
                            ? Text(
                          LibAmharicStrings.selectYear,
                          textAlign: TextAlign.start,
                          style: LibFont.textFont().copyWith(
                              fontSize: textFont025(context),
                              color: LibColors.whiteColor),
                        )
                            : Text(
                          LibEnglishStrings.selectYear,
                          textAlign: TextAlign.start,
                          style: LibFont.textFont().copyWith(
                              fontSize: textFont025(context),
                              color: LibColors.whiteColor),

                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: EdgeInsets.all(padding8(context)),
                          child: Text(
                            " ${state.currentMoment.year}",
                            textAlign: TextAlign.start,
                            style: LibFont.textFont().copyWith(
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
                                BlocProvider.of<AlertCalenderControllerBloc>(
                                    context)
                                    .add(
                                    GetSelectedIndex(index, widget.startYear,
                                        widget.endYear, yearsList[index]));
                              },
                              child: Text(
                                yearsList[index].toString(),
                                style: LibFont.textFont().copyWith(
                                    fontSize: textFont025(context),
                                    color: LibColors.blackColor),
                              )),
                        );
                      }),
                )
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
            BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                PrevMonthCalendar(currentMoment));
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
            BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                NextMonthCalendar(currentMoment));
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
          (currentMoment
              .monthDays()
              .toList()
              .length + currentMoment.monthDays().toList()[0][3]).toInt(),
              (index) {
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
              if (currentMoment.monthDays().toList()[(index -
                  currentMoment.monthDays().toList()[0][3]).toInt()][0] ==
                  EtDatetime
                      .now()
                      .year &&
                  currentMoment.monthDays().toList()[(index -
                      currentMoment.monthDays().toList()[0][3]).toInt()][1] ==
                      EtDatetime
                          .now()
                          .month &&
                  currentMoment.monthDays().toList()[(index -
                      currentMoment.monthDays().toList()[0][3]).toInt()][2] ==
                      EtDatetime
                          .now()
                          .day) {
                BlocProvider.of<AlertCalenderControllerBloc>(context)
                    .add(GetDayName(index, crossAxisCount));
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: verticalPadding098(context),
                      horizontal: horizontalPadding18(context)),
                  child: InkWell(
                    onTap: () {

                    },
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
                              "${currentMoment.monthDays().toList()[(index -
                                  currentMoment.monthDays().toList()[0][3])
                                  .toInt()][2]}",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ethiopianToGregorianDateConvertor(
                                  currentMoment.monthDays().toList()[
                                  (index -
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
                    vertical: 1,
                    horizontal: horizontalPadding18(context)),
                child: GestureDetector(
                  onTap: () {
                    ///user will tap means user will select days without range
                    String date = currentMoment
                        .monthDays()
                        .toList()[(index -
                        currentMoment.monthDays().toList()[0][3]).toInt()][2]
                        .toString();
                    String month = currentMoment
                        .monthDays()
                        .toList()[(index -
                        currentMoment.monthDays().toList()[0][3]).toInt()][1]
                        .toString();
                    String year = currentMoment
                        .monthDays()
                        .toList()[(index -
                        currentMoment.monthDays().toList()[0][3]).toInt()][0]
                        .toString();

                    if (tappedDates.contains(int.parse(date + month + year))) {
                      BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                          RemoveItemFromList(
                              '$date-$month-$year', currentMoment,
                              int.parse(date + month + year)));
                    } else {
                      BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                          AddSingleValues(
                              '$date-$month-$year',
                              currentMoment,
                              int.parse(date + month + year)));
                    }
                  },
                  onLongPress: () {
                    String date = currentMoment
                        .monthDays()
                        .toList()[(index - currentMoment.monthDays()
                        .toList()[0][3]).toInt()][2]
                        .toString();
                    String month = currentMoment
                        .monthDays()
                        .toList()[(index - currentMoment.monthDays()
                        .toList()[0][3]).toInt()][1]
                        .toString();
                    String year = currentMoment
                        .monthDays()
                        .toList()[(index - currentMoment.monthDays()
                        .toList()[0][3]).toInt()][0]
                        .toString();
                    //BlocProvider.of<MyCalenderBloc>(context)
                    //    .add(AddSingleValues(date + month + year, a));

                    /// user will long press on numbers to make selection and draw picker
                    /// moving from tap to values will be reseted
                    /// add first value

                    /// user untapped first number this means number is removed and enddate will be firstDate--> firstvalueadded added will be true---> second value added will be false
                    /// user long pressed endNumber remove end number --->second value added will be false
                    /// user long pressed new number new number will be second number

                    //
                    ///-----> add the first Value-------->///
                    if (firstDateAdded == false && endDateAdded == false) {
                      /// add first value
                      if (intialDate == -1) {
                        BlocProvider.of<AlertCalenderControllerBloc>(context)
                            .add(
                            AddInitalValue(
                                '$date-$month-$year',
                                int.parse(date),
                                int.parse(month),
                                int.parse(year),
                                int.parse(date + month + year),
                                currentMoment));
                      }
                    }

                    ///-----> add the second Value-------->///
                    ///
                    if (firstDateAdded == true && endDateAdded == false) {
                      ///user clicks the first date so remove first date or initial number
                      //RemoveInitalValue
                      if (intialDate == int.parse(date + month + year)) {
                        BlocProvider.of<AlertCalenderControllerBloc>(context)
                            .add(
                            RemoveInitalValue('$date-$month-$year',
                                int.parse(date + month + year), currentMoment));
                      }

                      /// user is clicking another number which is user is adding second number
                      if (intialDate != int.parse(date + month + year)) {
                        ////AddSecondValue
                        BlocProvider.of<AlertCalenderControllerBloc>(context)
                            .add(
                            AddSecondValue(
                                '$date-$month-$year',
                                int.parse(date),
                                int.parse(month),
                                int.parse(year),
                                int.parse(date + month + year),
                                currentMoment));
                      }

                      /// user reclicked second value
                      if (secondNumberClickCounter >= 1) {
                        /// now remove second value
                        BlocProvider.of<AlertCalenderControllerBloc>(context)
                            .add(
                            RemoveSecondValue(date + '-' + month + '-' + year,
                                int.parse(date + month + year), currentMoment));
                      }
                    }

                    /// now user added both first and end values
                    if (firstDateAdded == true && endDateAdded == true) {
                      /// remove second value
                      if (endDate == int.parse(date + month + year)) {
                        BlocProvider.of<AlertCalenderControllerBloc>(context)
                            .add(
                            RemoveSecondValue('$date-$month-$year',
                                int.parse(date + month + year), currentMoment));
                      }

                      /// after adding both user clicked first number
                      if (intialDate == int.parse(date + month + year)) {
                        /// in this logic user clicked the first number
                        /// this means untill user clicks another value
                        /// endDate will become intialDate first value add will be true
                        /// and second value added  will be false
                        BlocProvider.of<AlertCalenderControllerBloc>(context)
                            .add(
                            RemoveSecondValueAfterBothAdded(
                                '$date-$month-$year',
                                int.parse(date + month + year),
                                currentMoment));
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: height12(context),
                    width: width203(context),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            "${currentMoment.monthDays().toList()[(index -
                                currentMoment.monthDays().toList()[0][3])
                                .toInt()][2]}",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            ethiopianToGregorianDateConvertor(
                                currentMoment.monthDays().toList()[
                                (index -
                                    currentMoment.monthDays().toList()[0][3])
                                    .toInt()][2],
                                currentMoment,
                                true),
                            style: TextStyle(color: Colors.black, fontSize: 7),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: tappedDates.isNotEmpty
                          ? tappedDates.contains(int.parse(currentMoment
                          .monthDays()
                          .toList()[(index -
                          currentMoment.monthDays().toList()[0][3]).toInt()]
                      [2]
                          .toString() +
                          currentMoment
                              .monthDays()
                              .toList()[(index -
                              currentMoment.monthDays().toList()[0][3]).toInt()]
                          [1]
                              .toString() +
                          currentMoment
                              .monthDays()
                              .toList()[(index -
                              currentMoment.monthDays().toList()[0][3]).toInt()]
                          [0]
                              .toString()))
                          ? Theme
                          .of(context)
                          .primaryColor
                          : Colors.grey[300]
                          : firstDateAndLastDate.contains(
                          int.parse(currentMoment
                              .monthDays()
                              .toList()[(index -
                              currentMoment.monthDays().toList()[0][3]).toInt()]
                          [2]
                              .toString() +
                              currentMoment
                                  .monthDays()
                                  .toList()[(index -
                                  currentMoment.monthDays().toList()[0][3])
                                  .toInt()]
                              [1]
                                  .toString() +
                              currentMoment
                                  .monthDays()
                                  .toList()[(index -
                                  currentMoment.monthDays().toList()[0][3])
                                  .toInt()][0]
                                  .toString()))
                          ? Theme
                          .of(context)
                          .primaryColor
                          : longTapPickedRange.contains(int.parse(currentMoment
                          .monthDays()
                          .toList()[(index -
                          currentMoment.monthDays().toList()[0][3]).toInt()][2]
                          .toString() + currentMoment.monthDays()
                          .toList()[(index -
                          currentMoment.monthDays().toList()[0][3]).toInt()][1]
                          .toString() + currentMoment
                          .monthDays()
                          .toList()[(index -
                          currentMoment.monthDays().toList()[0][3]).toInt()][0]
                          .toString()))
                          ? Theme
                          .of(context)
                          .primaryColor
                          .withOpacity(0.5)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
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
        children:

        days
            .asMap()
            .entries
            .map((MapEntry map) {
          return Text(map.value,
            style: LibFont.textFont().copyWith(
                color: LibColors.blackColor, fontWeight: FontWeight.bold),);
        }).toList()

    );
  }

}
