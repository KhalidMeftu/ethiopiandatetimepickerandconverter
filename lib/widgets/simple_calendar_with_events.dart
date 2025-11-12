import 'package:abushakir/abushakir.dart';
import 'package:flutter/material.dart';
import '../const/lib_colors.dart';
import '../const/lib_fonts.dart';
import '../const/lib_functions.dart';
import '../const/ui_helper.dart';

class SimpleCalendarWithEvents extends StatefulWidget {
  final List<Map<String, dynamic>> eventsList;
  final Function(String) onEventTap;
  final bool displayGregorianCalender;
  final String userLanguage;
  final Color borderColor;
  final Color todaysDateColor;
  final int startYear;
  final int endYear;
  final Color? headerBackgroundColor;
  final Color? headerTextColor;
  final Color? monthNavigationColor;

  const SimpleCalendarWithEvents({
    Key? key,
    required this.startYear,
    required this.endYear,
    required this.eventsList,
    required this.onEventTap,
    required this.displayGregorianCalender,
    required this.userLanguage,
    required this.borderColor,
    required this.todaysDateColor,
    this.headerBackgroundColor,
    this.headerTextColor,
    this.monthNavigationColor,
  }) : super(key: key);

  @override
  State<SimpleCalendarWithEvents> createState() => _SimpleCalendarWithEventsState();
}

class _SimpleCalendarWithEventsState extends State<SimpleCalendarWithEvents> {
  late ETC currentMoment;
  String dayName = '';
  bool showYearPicker = false;
  List<int> yearsList = [];
  int selectedYearIndex = -1;

  @override
  void initState() {
    super.initState();
    currentMoment = ETC.today();
    _generateYearsList();
  }

  void _generateYearsList() {
    yearsList.clear();
    for (int i = widget.startYear; i <= widget.endYear; i++) {
      yearsList.add(i);
    }
  }

  void _selectYear(int year) {
    setState(() {
      currentMoment = getCalenderSpecificYear(year);
      showYearPicker = false;
    });
  }

  void _toggleYearPicker() {
    setState(() {
      showYearPicker = !showYearPicker;
    });
  }

  @override
  void didUpdateWidget(SimpleCalendarWithEvents oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild when language changes
    if (oldWidget.userLanguage != widget.userLanguage) {
      setState(() {
        // Force rebuild with new language
      });
    }
  }

  void _nextMonth() {
    setState(() {
      currentMoment = currentMoment.nextMonth;
      // Force rebuild of the calendar grid
    });
  }

  void _prevMonth() {
    setState(() {
      currentMoment = currentMoment.prevMonth;
      // Force rebuild of the calendar grid
    });
  }


  bool _hasEvent(String dateString) {
    for (int i = 0; i < widget.eventsList.length; i++) {
      final event = widget.eventsList[i];
      if (event['dates'] != null && event['dates'] is List) {
        final dates = event['dates'] as List;
        if (dates.contains(dateString)) {
          return true;
        }
      } else if (event['date'] != null && dateString == event['date']) {
        return true;
      }
    }
    return false;
  }

  int _getEventCount(String dateString) {
    int count = 0;
    for (int i = 0; i < widget.eventsList.length; i++) {
      final event = widget.eventsList[i];
      if (event['dates'] != null && event['dates'] is List) {
        final dates = event['dates'] as List;
        if (dates.contains(dateString)) {
          count++;
        }
      } else if (event['date'] != null && dateString == event['date']) {
        count++;
      }
    }
    return count;
  }

  String _getEventData(String dateString) {
    List<String> events = [];
    for (int i = 0; i < widget.eventsList.length; i++) {
      final event = widget.eventsList[i];
      bool hasThisDate = false;

      if (event['dates'] != null && event['dates'] is List) {
        final dates = event['dates'] as List;
        hasThisDate = dates.contains(dateString);
      } else if (event['date'] != null && dateString == event['date']) {
        hasThisDate = true;
      }

      if (hasThisDate) {
        String title = event['title'] ?? '';
        String description = event['description'] ?? '';
        String note = event['note'] ?? '';

        String eventText = title;
        if (description.isNotEmpty) {
          eventText += '\n$description';
        }
        if (note.isNotEmpty) {
          eventText += '\nNote: $note';
        }
        events.add(eventText);
      }
    }
    return events.join('\n\n');
  }

  void _handleDateTap(String dateString) {
    String eventData = _getEventData(dateString);
    if (eventData.isNotEmpty) {
      widget.onEventTap(eventData);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showYearPicker) {
      return Scaffold(
        body: _buildYearPicker(),
      );
    }

    return Scaffold(
      body: Material(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            color: LibColors.whiteColor,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Column(
                    children: [
                      _buildMonthNavigation(),
                      _buildDayHeaders(),
                      Expanded(
                        child: _buildDaysGrid(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYearPicker() {
    return Padding(
      padding: EdgeInsets.only(
        top: padding80(context),
        bottom: padding80(context),
        left: padding15(context),
        right: padding15(context),
      ),
      child: Material(
        child: Container(
          color: LibColors.whiteColor,
          child: Column(
            children: [
              Container(
                color: widget.headerBackgroundColor ?? Theme.of(context).primaryColor,
                width: double.infinity,
                height: height200(context),
                child: Center(
                  child: Text(
                    "${currentMoment.year}",
                    style: EthiopianDatePickerFont.textFont().copyWith(
                      fontSize: textFont030(context),
                      color: widget.headerTextColor ?? LibColors.whiteColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 60,
                    childAspectRatio: 0.878,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: yearsList.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: LibColors.white70,
                      child: InkWell(
                        onTap: () => _selectYear(yearsList[index]),
                        child: Center(
                          child: Text(
                            yearsList[index].toString(),
                            style: EthiopianDatePickerFont.textFont().copyWith(
                              fontSize: textFont025(context),
                              color: selectedYearIndex == index
                                  ? LibColors.redColor
                                  : LibColors.blackColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showYearPicker = false;
                        });
                      },
                      child: Text(
                        'Cancel',
                        style: EthiopianDatePickerFont.textFont().copyWith(
                          fontSize: textFont025(context),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: widget.headerBackgroundColor ?? Theme.of(context).primaryColor,
      width: double.infinity,
      height: padding80(context),
      child: Padding(
        padding: EdgeInsets.all(padding8(context)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              returnDayAndMonthName(
                dayName,
                ' ${currentMoment.day}',
                '${currentMoment.monthName}',
                widget.userLanguage,
                '${currentMoment.year}',
                false,
              )!,
              style: EthiopianDatePickerFont.textFont().copyWith(
                fontSize: textFont025(context),
                fontWeight: FontWeight.bold,
                color: widget.headerTextColor ?? LibColors.whiteColor,
              ),
            ),
            Listener(
              onPointerUp: (_) => _toggleYearPicker(),
              child: Icon(
                Icons.edit,
                color: widget.headerTextColor ?? LibColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Listener(
            onPointerUp: (_) => _prevMonth(),
            child: Icon(
              Icons.chevron_left,
              color: widget.monthNavigationColor ?? LibColors.blackColor,
              size: iconSize16(context),
            ),
          ),
          Text(
            returnDayAndMonthName(
              dayName,
              '',
              '${currentMoment.monthName}',
              widget.userLanguage,
              '',
              true,
            )!,
            style: EthiopianDatePickerFont.textFont().copyWith(
              fontSize: textFont025(context),
              fontWeight: FontWeight.bold,
              color: widget.monthNavigationColor ?? LibColors.blackColor,
            ),
          ),
          Listener(
            onPointerUp: (_) => _nextMonth(),
            child: Icon(
              Icons.chevron_right,
              color: widget.monthNavigationColor ?? LibColors.blackColor,
              size: iconSize16(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeaders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.asMap().entries.map((entry) {
        return Text(
          returnAbrivateWeekNames(entry.value, widget.userLanguage)!,
          style: EthiopianDatePickerFont.textFont().copyWith(
            color: LibColors.blackColor,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid() {
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding(context),
        vertical: verticalPadding(context),
      ),
      crossAxisCount: 7,
      children: List.generate(
        (currentMoment.monthDays().toList().length +
                currentMoment.monthDays().toList()[0][3])
            .toInt(),
        (index) => _buildDayCell(index),
      ),
    );
  }

  Widget _buildDayCell(int index) {
    final monthDays = currentMoment.monthDays().toList();
    final firstDayOffset = monthDays[0][3];

    if (index < firstDayOffset) {
      return _buildEmptyCell();
    }

    final dayIndex = index - firstDayOffset;
    final dayData = monthDays[dayIndex.toInt()];
    final day = dayData[2];
    final month = dayData[1];
    final year = dayData[0];

    final dateString = '$year-$month-$day';
    final isToday = _isToday(year, month, day);
    final hasEvent = _hasEvent(dateString);

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (isToday) {
      backgroundColor = widget.todaysDateColor;
      borderColor = hasEvent ? widget.borderColor : LibColors.blackColor;
      textColor = hasEvent ? LibColors.redColor : LibColors.blackColor;
    } else {
      backgroundColor = LibColors.grey300;
      borderColor = hasEvent ? widget.borderColor : LibColors.blackColor;
      textColor = hasEvent ? LibColors.redColor : LibColors.blackColor;
    }

    return Padding(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () => _handleDateTap(dateString),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: borderColor,
              width: 2.0,
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(color: textColor),
                  ),
                  if (widget.displayGregorianCalender)
                    Text(
                      ethiopianToGregorianDateConvertor(day, currentMoment, true),
                      style: TextStyle(
                        color: textColor,
                        fontSize: textFont07(context),
                      ),
                    ),
                ],
              ),
              if (hasEvent && _getEventCount(dateString) > 1)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '${_getEventCount(dateString)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCell() {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: LibColors.grey100,
          borderRadius: BorderRadius.circular(60),
        ),
      ),
    );
  }

  bool _isToday(int year, int month, int day) {
    final today = EtDatetime.now();
    return year == today.year && month == today.month && day == today.day;
  }
}