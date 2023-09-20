import 'package:abushakir/abushakir.dart';
import 'package:ethiopiandatepickerandconvertor/const/app_strings.dart';
import 'package:ethiopiandatepickerandconvertor/const/lib_colors.dart';
import 'package:ethiopiandatepickerandconvertor/const/lib_fonts.dart';
import 'package:ethiopiandatepickerandconvertor/const/lib_functions.dart';
import 'package:ethiopiandatepickerandconvertor/const/ui_helper.dart';
import 'package:ethiopiandatepickerandconvertor/controller/alert_calender_bloc/alert_calender_controller_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AlertDatePicker extends StatefulWidget {

  /// if we want to pass user data which is user starts to save data we can pass dates here format will be
  /// [2023-12-12]
  final List? pickedValues;
  /// show gregorian calender or not
  final bool displayGregorianCalender;
  /// display calender in afan oromo amharic and english
  String userLanguage = "en";
  /// pass color code
  final bool colorStatus;
  /// define you intial year
  final int startYear;
  /// define your final year
  final int endYear;

  AlertDatePicker(
      {Key? key,
      this.pickedValues,
      required this.displayGregorianCalender,
      required this.userLanguage,
      required this.colorStatus,
      required this.startYear,
      required this.endYear})
      : super(key: key);

  @override
  State<AlertDatePicker> createState() => _AlertDatePickerState();
}

class _AlertDatePickerState extends State<AlertDatePicker> {
  /// list for storing user selection
  List selectedValues = [];
  /// years lists is for year pickers
  List yearsList = [];

  /// day name
  String dayName = '';

  /// both comparsion related lists help us to compare values and set color and etc functions
  List compareTappedDates = []; /// single tapped
  List compareLongPressedDates = [];  /// long press

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

  @override
  void initState() {
    // TODO: implement initState
    /// if we want to show events incase the user may not have some event on the some date
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
        if (state is SingleValuesIndexState) {
          tappedDates.add(state.dateForComparsion);
          compareTappedDates.add(state.singleDatesList);
        }

        /// remove value
        if (state is RemoveValueFromListState) {
          tappedDates.remove(state.dateForcomparsion);
          compareTappedDates.remove(state.singleDatesList);
        }

        ///long press user is adding the very first value
        if (state is AddFirstValueState) {
          tappedDates = [];
          compareTappedDates = [];
          initialDate = state.firstDateForComparision;
          firstDateAdded = true;
          firstDateAndLastDate.add(state.firstDateForComparision);
          /// comparsion
          compareLongPressedDates.add(state.firstDate);
          firstNumberClickCounter = firstNumberClickCounter + 1;
          firstDateForUser = '${state.day}-${state.month}-${state.year}';
          forUserOutPut.add(firstDateForUser);
        }

        /// user made already long tap and want to cancel or remove the intial value
        if (state is RemoveLongTapFirstValueState) {
          tappedDates = [];
          compareTappedDates = [];
          initialDate = -1;
          firstDateAdded = false;
          firstDateAndLastDate.remove(state.firstDateForComparision);
          compareLongPressedDates.remove(state.firstDate);
          firstNumberClickCounter = 0;
        }

        /// user adds the second value
        if (state is AddSecondValueState) {
          tappedDates = [];
          compareTappedDates = [];
          endDate = state.firstDateForComparision;
          endDateAdded = true;
          firstDateAndLastDate.add(state.firstDateForComparision);
          compareLongPressedDates.add(state.secondDate);
          secondNumberClickCounter = secondNumberClickCounter + 1;
          endDateOutPut = '${state.day}-${state.month}-${state.year}';
          forUserOutPut.add(endDateOutPut);

          if (forUserOutPut.length == 2) {
            var initialDate  = removeHyphenGetDate(forUserOutPut[0]);
            var initialMonth = removeHyphenGetMonth(forUserOutPut[0]);
            var initialYear = removeHyphenGetYear(forUserOutPut[0]);

            var endDate = removeHyphenGetDate(forUserOutPut[1]);
            var endMonth = removeHyphenGetMonth(forUserOutPut[1]);
            var endYear = removeHyphenGetYear( forUserOutPut[1]);

            /// compariso n logic
            /// compare year
            /// compare month
            /// compare day
            /// --->>>> some year<<<<<<<--
            if (int.parse(endYear) == int.parse(initialYear)) {
              /// --->>>> some month<<<<<<<--
              if (int.parse(initialMonth) == int.parse(endMonth)) {
                /// now compare date
                if (int.parse(initialDate) > int.parse(endDate)) {
                  for (int i = int.parse(endDate);
                      i <= int.parse(initialDate);
                      i++) {
                    longTapPickedRange.add(int.parse('$i$initialMonth$initialYear'));

                    /// add for response
                    rangeForUserOutPut.add('$initialYear-$initialMonth-$i');
                  }
                } else {
                  for (int i = int.parse(initialDate);
                      i <= int.parse(endDate);
                      i++) {
                    longTapPickedRange.add(int.parse('$i$initialMonth$initialYear'));

                    /// add for response
                    rangeForUserOutPut.add('$initialYear-$initialMonth-$i');
                  }
                }
              }
              if (int.parse(endMonth) > int.parse(initialMonth)) {
                ///<--- end down count to one
                ///---> init will count to 30

                for (int x = int.parse(endDate); x >= 1; x--) {
                  longTapPickedRange.add(int.parse('$x$endMonth$initialYear'));

                  /// add for response
                  rangeForUserOutPut.add('$initialYear-$endMonth-$x');
                }
                for (int y = int.parse(initialDate); y <= 30; y++) {
                  longTapPickedRange.add(int.parse('$y$initialMonth$initialYear'));

                  /// add for response
                  rangeForUserOutPut.add('$initialYear-$initialMonth-$y');
                }
              }

              if (int.parse(endMonth) < int.parse(initialMonth)) {
                for (int x = int.parse(endDate); x <= 30; x++) {
                  longTapPickedRange.add(int.parse('$x$endMonth$initialYear'));
                  rangeForUserOutPut.add('$initialYear-$endMonth-$x');
                }

                for (int y = int.parse(initialDate); y >= 1; y--) {
                  longTapPickedRange.add(int.parse('$y$initialMonth$initialYear'));
                  rangeForUserOutPut.add('$initialYear-$initialMonth-$y');
                }
              }
            }
          }
        }

        /// remove the second long tapped value
        if (state is RemoveLongTapSecondValueState) {
          /// reset range
          firstDateAndLastDate.remove(state.secondDateForComparision);
          longTapPickedRange = [];
          endDate = -1;
          secondNumberClickCounter = 0;
          endDateAdded = false;
        }

        /// remove initial value after both first and second value added
        if (state is RemoveLongTapSecondValueAfterState) {
          firstDateAndLastDate.remove(state.secondDateForComparision);
          longTapPickedRange = [];
          initialDate = endDate;
          endDate = -1;
          secondNumberClickCounter = 0;
          endDateAdded = false;
        }

        /// tap and remove second number

        ///longpress ends here
        if (state is SetDayNameState) {
          dayName = state.dayName;
        }
        if (state is GetYearsListState) {
          yearsList = state.yearsList;
        }
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
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    height: height200(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.userLanguage == "am") ...[
                          Padding(
                              padding: EdgeInsets.all(padding8(context)),
                              child: Text(
                                LibAmharicStrings.selectYear,
                                textAlign: TextAlign.start,
                                style: EthiopianDatePickerFont.textFont().copyWith(
                                    fontSize: textFont025(context),
                                    color: LibColors.white70),
                              )),
                        ],
                        if (widget.userLanguage == "ao") ...[
                          Padding(
                            padding: EdgeInsets.all(padding8(context)),
                            child: Text(
                              LibEnglishStrings.selectYear,
                              textAlign: TextAlign.start,
                              style: EthiopianDatePickerFont.textFont().copyWith(
                                  fontSize: textFont025(context),
                                  color: LibColors.white70),
                            ),
                          ),
                        ],
                        if (widget.userLanguage == "en") ...[
                          Padding(
                            padding: EdgeInsets.all(padding8(context)),
                            child: Text(
                              LibEnglishStrings.selectYear,
                              textAlign: TextAlign.start,
                              style: EthiopianDatePickerFont.textFont().copyWith(
                                  fontSize: textFont025(context),
                                  color: LibColors.white70),
                            ),
                          ),
                        ],
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: EdgeInsets.all(padding8(context)),
                            child: Text(
                              " ${state.selectedYear}",
                              textAlign: TextAlign.start,
                              style: EthiopianDatePickerFont.textFont()
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
                                                AlertCalenderControllerBloc>(
                                            context)
                                        .add(GetYearList(
                                            widget.startYear, widget.endYear));
                                  } else if (index != state.selectedIndex) {
                                    /// change the bloc
                                    BlocProvider.of<
                                                AlertCalenderControllerBloc>(
                                            context)
                                        .add(GetYearList(
                                            widget.startYear, widget.endYear));
                                    BlocProvider.of<
                                                AlertCalenderControllerBloc>(
                                            context)
                                        .add(GetSelectedIndex(
                                            index,
                                            widget.startYear,
                                            widget.endYear,
                                            state.yearsList[index]));
                                  }
                                },
                                child: Text(
                                  state.yearsList[index].toString(),
                                  style: EthiopianDatePickerFont.textFont().copyWith(
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
                        if (widget.userLanguage == "am") ...[
                          Padding(
                              padding: EdgeInsets.all(padding8(context)),
                              child: Text(
                                LibAmharicStrings.cancel,
                                textAlign: TextAlign.start,
                                style: EthiopianDatePickerFont.textFont().copyWith(
                                    fontSize: textFont025(context),
                                    color: LibColors.white70),
                              )),
                        ],
                        if (widget.userLanguage == "ao") ...[
                          Padding(
                            padding: EdgeInsets.all(padding8(context)),
                            child: Text(
                              LibOromoStrings.cancel,
                              textAlign: TextAlign.start,
                              style: EthiopianDatePickerFont.textFont().copyWith(
                                  fontSize: textFont025(context),
                                  color: LibColors.white70),
                            ),
                          ),
                        ],
                        if (widget.userLanguage == "en") ...[
                          Padding(
                            padding: EdgeInsets.all(padding8(context)),
                            child: Text(
                              LibEnglishStrings.cancel,
                              textAlign: TextAlign.start,
                              style: EthiopianDatePickerFont.textFont().copyWith(
                                  fontSize: textFont025(context),
                                  color: LibColors.white70),
                            ),
                          ),
                        ],
                        const SizedBox(
                          width: 20,
                        ),
                        Material(
                          child: InkWell(
                              onTap: () {
                                yearsList = [];
                                BlocProvider.of<AlertCalenderControllerBloc>(
                                        context)
                                    .add(CalenderByYear(state.currentMoment,
                                        state.selectedYear));
                              },
                              child: widget.userLanguage == "ao"
                                  ? Text(
                                      LibOromoStrings.okay,
                                      style: EthiopianDatePickerFont.textFont().copyWith(
                                          fontSize: textFont025(context),
                                          color:
                                              Theme.of(context).primaryColor),
                                    )
                                  : widget.userLanguage == "am"
                                      ? Text(
                                          LibAmharicStrings.okay,
                                          style: EthiopianDatePickerFont.textFont().copyWith(
                                              fontSize: textFont025(context),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )
                                      : Text(
                                          LibEnglishStrings.okay,
                                          style: EthiopianDatePickerFont.textFont().copyWith(
                                              fontSize: textFont025(context),
                                              color: Theme.of(context)
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
            ?
        Material(
          child: Padding(
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
                          color: Theme.of(context).primaryColor,
                          width: double.infinity,
                          height: height200(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(widget.userLanguage=="am")...[
                                Padding(
                                  padding: EdgeInsets.all(padding8(context)),
                                  child:  Text(
                                    LibAmharicStrings.selectYear,
                                    textAlign: TextAlign.start,
                                    style: EthiopianDatePickerFont.textFont().copyWith(
                                        fontSize: textFont025(context),
                                        color: LibColors.white70),
                                  )
                                ),
                              ],
                              if(widget.userLanguage=="ao")...[
                                Padding(
                                    padding: EdgeInsets.all(padding8(context)),
                                    child:  Text(
                                      LibOromoStrings.selectYear,
                                      textAlign: TextAlign.start,
                                      style: EthiopianDatePickerFont.textFont().copyWith(
                                          fontSize: textFont025(context),
                                          color: LibColors.white70),
                                    )
                                ),
                              ],
                              if(widget.userLanguage=="en")...[
                                Padding(
                                    padding: EdgeInsets.all(padding8(context)),
                                    child:  Text(
                                      LibEnglishStrings.selectYear,
                                      textAlign: TextAlign.start,
                                      style: EthiopianDatePickerFont.textFont().copyWith(
                                          fontSize: textFont025(context),
                                          color: LibColors.white70),
                                    )
                                ),

                              ],

                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                  padding: EdgeInsets.all(padding8(context)),
                                  child: Text(
                                    " ${state.currentMoment.year}",
                                    textAlign: TextAlign.start,
                                    style: EthiopianDatePickerFont.textFont().copyWith(
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
                                            "${state.currentMoment.day}, ${state.currentMoment.monthName}",
                                            style: EthiopianDatePickerFont.textFont().copyWith(
                                                fontSize: textFont025(context),
                                                fontWeight: FontWeight.bold,
                                                color: LibColors.whiteColor),
                                          )
                                        : Text(
                                            "$dayName, ${state.currentMoment.day}, ${state.currentMoment.monthName}",
                                            style: EthiopianDatePickerFont.textFont().copyWith(
                                                fontSize: textFont025(context),
                                                fontWeight: FontWeight.bold,
                                                color: LibColors.whiteColor),
                                          ),
                                    Material(
                                      color: Theme.of(context).primaryColor,
                                      child: IconButton(
                                        iconSize: iconSize20(context),
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
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
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child:
                                        _actions(context, state.currentMoment)),
                                abbrivatedDaysList(),

                                Expanded(
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if(widget.userLanguage=="am")...[
                                        Text(
                                          LibAmharicStrings.cancel,
                                          style: EthiopianDatePickerFont.textFont().copyWith(
                                              fontSize: textFont025(context),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )
                                      ],
                                      if(widget.userLanguage=="en")...[
                                        Text(
                                          LibEnglishStrings.cancel,
                                          style: EthiopianDatePickerFont.textFont().copyWith(
                                              fontSize: textFont025(context),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ],
                                      if(widget.userLanguage=="ao")...[
                                        Text(
                                          LibOromoStrings.cancel,
                                          style: EthiopianDatePickerFont.textFont().copyWith(
                                              fontSize: textFont025(context),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ],

                                      const SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            if (compareTappedDates.isNotEmpty) {
                                              /// working fine
                                              pickedValues = compareTappedDates;
                                            }
                                            if (compareLongPressedDates
                                                .isNotEmpty) {
                                              /// adding to end of it
                                              pickedValues = rangeForUserOutPut;
                                            }
                                            Navigator.pop(context, pickedValues);
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).primaryColor,
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
                ),
        )
            :
        Material(
          child: Padding(
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
                          color: Theme.of(context).primaryColor,
                          width: double.infinity,
                          height: height200(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.userLanguage == "am") ...[
                                Padding(
                                    padding: EdgeInsets.all(padding8(context)),
                                    child: Text(
                                      LibAmharicStrings.selectYear,
                                      textAlign: TextAlign.start,
                                      style: EthiopianDatePickerFont.textFont().copyWith(
                                          fontSize: textFont025(context),
                                          color: LibColors.whiteColor),
                                    )),
                              ],
                              if (widget.userLanguage == "ao") ...[
                                Padding(
                                    padding: EdgeInsets.all(padding8(context)),
                                    child: Text(
                                      LibOromoStrings.selectYear,
                                      textAlign: TextAlign.start,
                                      style: EthiopianDatePickerFont.textFont().copyWith(
                                          fontSize: textFont025(context),
                                          color: LibColors.whiteColor),
                                    )),
                              ] else ...[
                                Padding(
                                  padding: EdgeInsets.all(padding8(context)),
                                  child: Text(
                                    LibEnglishStrings.selectYear,
                                    textAlign: TextAlign.start,
                                    style: EthiopianDatePickerFont.textFont().copyWith(
                                        fontSize: textFont025(context),
                                        color: LibColors.whiteColor),
                                  ),
                                ),
                              ],
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                  padding: EdgeInsets.all(padding8(context)),
                                  child: Text(
                                    " ${state.currentMoment.year}",
                                    textAlign: TextAlign.start,
                                    style: EthiopianDatePickerFont.textFont().copyWith(
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
                                        style: EthiopianDatePickerFont.textFont().copyWith(
                                            fontSize: textFont025(context),
                                            color: LibColors.blackColor),
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
          color: Colors.black,
          iconSize: iconSize16(context),
          onPressed: () {
            BlocProvider.of<AlertCalenderControllerBloc>(context)
                .add(PrevMonthCalendar(currentMoment));
          },
        ),
        Text(
          "${currentMoment.monthName}, ${currentMoment.year}",
          style: EthiopianDatePickerFont.textFont().copyWith(
              fontSize: textFont025(context),
              fontWeight: FontWeight.bold,
              color: LibColors.blackColor
          ),
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
                .add(GetDayName(index, crossAxisCount,widget.userLanguage));
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
                          style: const TextStyle(color: LibColors.blackColor),
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
                          style: const TextStyle(color: LibColors.blackColor),
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
              onTap: () {
                ///user will tap means user will select days without range
                String date = currentMoment
                    .monthDays()
                    .toList()[(index - currentMoment.monthDays().toList()[0][3])
                        .toInt()][2]
                    .toString();
                String month = currentMoment
                    .monthDays()
                    .toList()[(index - currentMoment.monthDays().toList()[0][3])
                        .toInt()][1]
                    .toString();
                String year = currentMoment
                    .monthDays()
                    .toList()[(index - currentMoment.monthDays().toList()[0][3])
                        .toInt()][0]
                    .toString();

                if (tappedDates.contains(int.parse(date + month + year))) {
                  BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                      RemoveItemFromList('$date-$month-$year', currentMoment,
                          int.parse(date + month + year)));
                } else {
                  BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                      AddSingleValues('$date-$month-$year', currentMoment,
                          int.parse(date + month + year)));
                }
              },
              onLongPress: () {
                String date = currentMoment
                    .monthDays()
                    .toList()[(index - currentMoment.monthDays().toList()[0][3])
                        .toInt()][2]
                    .toString();
                String month = currentMoment
                    .monthDays()
                    .toList()[(index - currentMoment.monthDays().toList()[0][3])
                        .toInt()][1]
                    .toString();
                String year = currentMoment
                    .monthDays()
                    .toList()[(index - currentMoment.monthDays().toList()[0][3])
                        .toInt()][0]
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
                  if (initialDate == -1) {
                    BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                        AddInitialValue(
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
                  if (initialDate == int.parse(date + month + year)) {
                    BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                        RemoveInitialValue('$date-$month-$year',
                            int.parse(date + month + year), currentMoment));
                  }

                  /// user is clicking another number which is user is adding second number
                  if (initialDate != int.parse(date + month + year)) {
                    ////AddSecondValue
                    BlocProvider.of<AlertCalenderControllerBloc>(context).add(
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
                    BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                        RemoveSecondValue('$date-$month-$year',
                            int.parse(date + month + year), currentMoment));
                  }
                }

                /// now user added both first and end values
                if (firstDateAdded == true && endDateAdded == true) {
                  /// remove second value
                  if (endDate == int.parse(date + month + year)) {
                    BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                        RemoveSecondValue('$date-$month-$year',
                            int.parse(date + month + year), currentMoment));
                  }

                  /// after adding both user clicked first number
                  if (initialDate == int.parse(date + month + year)) {
                    /// in this logic user clicked the first number
                    /// this means untill user clicks another value
                    /// endDate will become intialDate first value add will be true
                    /// and second value added  will be false
                    BlocProvider.of<AlertCalenderControllerBloc>(context).add(
                        RemoveSecondValueAfterBothAdded('$date-$month-$year',
                            int.parse(date + month + year), currentMoment));
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: height12(context),
                width: width203(context),
                decoration: BoxDecoration(
                  color: tappedDates.isNotEmpty
                      ? tappedDates.contains(int.parse(currentMoment
                                  .monthDays()
                                  .toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()]
                                      [2]
                                  .toString() +
                              currentMoment
                                  .monthDays()
                                  .toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()]
                                      [1]
                                  .toString() +
                              currentMoment
                                  .monthDays()
                                  .toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()]
                                      [0]
                                  .toString()))
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]
                      : firstDateAndLastDate.contains(int.parse(currentMoment
                                  .monthDays()
                                  .toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()]
                                      [2]
                                  .toString() +
                              currentMoment
                                  .monthDays()
                                  .toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][1]
                                  .toString() +
                              currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][0].toString()))
                          ? Theme.of(context).primaryColor
                          : longTapPickedRange.contains(int.parse(currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2].toString() + currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][1].toString() + currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][0].toString()))
                              ? Theme.of(context).primaryColor.withOpacity(0.5)
                              : Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Text(
                        "${currentMoment.monthDays().toList()[(index - currentMoment.monthDays().toList()[0][3]).toInt()][2]}",
                        style: const TextStyle(color: LibColors.blackColor),
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
                        style:
                             TextStyle(color: LibColors.blackColor, fontSize: textFont07(context)),
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
            style: EthiopianDatePickerFont.textFont().copyWith(
                color: LibColors.blackColor, fontWeight: FontWeight.bold),
          );
        }).toList());
  }
}
