import 'package:abushakir/abushakir.dart';
import 'package:ethiopiandatepickerandconvertor/const/app_strings.dart';
import 'package:ethiopiandatepickerandconvertor/const/lib_colors.dart';
import 'package:ethiopiandatepickerandconvertor/const/lib_fonts.dart';
import 'package:ethiopiandatepickerandconvertor/const/lib_functions.dart';
import 'package:ethiopiandatepickerandconvertor/const/ui_helper.dart';
import 'package:flutter/material.dart';

class SimpleDatePicker extends StatefulWidget {
  final bool displayGregorianCalender;
  final String userLanguage;
  final Color todaysDateBackgroundColor;
  final int startYear;
  final int endYear;
  final Function(List<String>) onDatesSelected;

  const SimpleDatePicker({
    Key? key,
    required this.displayGregorianCalender,
    required this.userLanguage,
    required this.startYear,
    required this.endYear,
    required this.todaysDateBackgroundColor,
    required this.onDatesSelected,
  }) : super(key: key);

  @override
  State<SimpleDatePicker> createState() => _SimpleDatePickerState();
}

class _SimpleDatePickerState extends State<SimpleDatePicker> {
  late ETC currentMoment;
  List<String> selectedDates = [];
  List<int> selectedDateComparisons = [];
  List<String> rangeSelectedDates = [];
  List<int> rangeComparisons = [];

  String? firstRangeDate;
  String? endRangeDate;
  int initialRangeDate = -1;
  int endRangeDateInt = -1;
  bool firstDateAdded = false;
  bool endDateAdded = false;

  @override
  void initState() {
    super.initState();
    currentMoment = ETC.today();
    _generateYearsList();
  }

  @override
  void didUpdateWidget(SimpleDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild when language changes
    if (oldWidget.userLanguage != widget.userLanguage) {
      setState(() {
        // Force rebuild with new language
      });
    }
  }

  bool showYearPicker = false;
  List<int> yearsList = [];
  int selectedYearIndex = -1;
  String dayName = '';



  void _generateYearsList() {
    yearsList.clear();
    for (int i = widget.startYear; i <= widget.endYear; i++) {
      yearsList.add(i);
    }
  }

  void _nextMonth() {
    setState(() {
      currentMoment = currentMoment.nextMonth;
    });
  }

  void _prevMonth() {
    setState(() {
      currentMoment = currentMoment.prevMonth;
    });
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

  void _onDateTap(String dateString, int comparison) {
    setState(() {
      if (selectedDateComparisons.contains(comparison)) {
        selectedDates.remove(dateString);
        selectedDateComparisons.remove(comparison);
      } else {
        selectedDates.add(dateString);
        selectedDateComparisons.add(comparison);
      }
    });
  }

  void _onDateLongPress(String dateString, int comparison, int day, int month, int year) {
    setState(() {
      // Reset single selections when starting range selection
      selectedDates.clear();
      selectedDateComparisons.clear();

      if (!firstDateAdded && !endDateAdded) {
        // Add first date
        initialRangeDate = comparison;
        firstRangeDate = dateString;
        firstDateAdded = true;
        rangeComparisons.add(comparison);
      } else if (firstDateAdded && !endDateAdded) {
        if (initialRangeDate == comparison) {
          // Remove first date
          _resetRangeSelection();
        } else {
          // Add second date
          endRangeDateInt = comparison;
          endRangeDate = dateString;
          endDateAdded = true;
          rangeComparisons.add(comparison);
          _generateRangeDates(firstRangeDate!, dateString, year);
        }
      } else if (firstDateAdded && endDateAdded) {
        if (comparison == initialRangeDate || comparison == endRangeDateInt) {
          // Reset if clicking on existing range endpoints
          _resetRangeSelection();
        }
      }
    });
  }

  void _resetRangeSelection() {
    initialRangeDate = -1;
    endRangeDateInt = -1;
    firstDateAdded = false;
    endDateAdded = false;
    firstRangeDate = null;
    endRangeDate = null;
    rangeSelectedDates.clear();
    rangeComparisons.clear();
  }

  void _generateRangeDates(String startDate, String endDate, int year) {
    rangeSelectedDates.clear();

    var startParts = startDate.split('-');
    var endParts = endDate.split('-');

    int startDay = int.parse(startParts[0]);
    int startMonth = int.parse(startParts[1]);
    int endDay = int.parse(endParts[0]);
    int endMonth = int.parse(endParts[1]);

    // Handle same month selection
    if (startMonth == endMonth) {
      int minDay = startDay < endDay ? startDay : endDay;
      int maxDay = startDay > endDay ? startDay : endDay;

      for (int day = minDay; day <= maxDay; day++) {
        rangeSelectedDates.add('$year-$startMonth-$day');
      }
    } else {
      // Handle cross-month selection
      int minMonth = startMonth < endMonth ? startMonth : endMonth;
      int maxMonth = startMonth > endMonth ? startMonth : endMonth;

      // Add dates from first month
      ETC firstMonth = ETC(year: year, month: minMonth, day: 1);
      int daysInFirstMonth = firstMonth.monthDays().length;

      if (minMonth == startMonth) {
        for (int day = startDay; day <= daysInFirstMonth; day++) {
          rangeSelectedDates.add('$year-$minMonth-$day');
        }
      } else {
        for (int day = endDay; day <= daysInFirstMonth; day++) {
          rangeSelectedDates.add('$year-$minMonth-$day');
        }
      }

      // Add dates from middle months (if any)
      for (int month = minMonth + 1; month < maxMonth; month++) {
        ETC middleMonth = ETC(year: year, month: month, day: 1);
        int daysInMonth = middleMonth.monthDays().length;
        for (int day = 1; day <= daysInMonth; day++) {
          rangeSelectedDates.add('$year-$month-$day');
        }
      }

      // Add dates from last month
      if (maxMonth == startMonth) {
        for (int day = 1; day <= startDay; day++) {
          rangeSelectedDates.add('$year-$maxMonth-$day');
        }
      } else {
        for (int day = 1; day <= endDay; day++) {
          rangeSelectedDates.add('$year-$maxMonth-$day');
        }
      }
    }
  }


  void _confirmSelection() {
    List<String> result = [];
    if (rangeSelectedDates.isNotEmpty) {
      result = rangeSelectedDates;
    } else {
      result = selectedDates;
    }
    widget.onDatesSelected(result);
  }

  @override
  Widget build(BuildContext context) {
    if (showYearPicker) {
      return _buildYearPicker();
    }

    return _buildCalendar();
  }

  Widget _buildYearPicker() {
    return Padding(
      padding: EdgeInsets.only(
        top: padding15(context),
        bottom: padding15(context),
        left: padding15(context),
        right: padding15(context),
      ),
      child: Material(
        child: Container(
          color: LibColors.whiteColor,
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                width: double.infinity,
                height: height200(context),
                child: Center(
                  child: Text(
                    "${currentMoment.year}",
                    style: EthiopianDatePickerFont.textFont().copyWith(
                      fontSize: textFont030(context),
                      color: LibColors.whiteColor,
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
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: padding15(context),
          vertical: padding15(context),
        ),
        child: Material(
          child: Container(
            color: LibColors.whiteColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildMonthNavigation(),
                _buildDayHeaders(),
                _buildDaysGrid(),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Theme.of(context).primaryColor,
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
                color: LibColors.whiteColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: LibColors.whiteColor),
              onPressed: _toggleYearPicker,
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
          IconButton(
            icon: const Icon(Icons.chevron_left),
            color: LibColors.blackColor,
            iconSize: iconSize16(context),
            onPressed: _prevMonth,
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
              color: LibColors.blackColor,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            iconSize: iconSize16(context),
            onPressed: _nextMonth,
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

    final dateString = '$day-$month-$year';
    final comparison = int.parse('$day$month$year');
    final isToday = _isToday(year, month, day);
    final isSelected = selectedDateComparisons.contains(comparison);
    final isInRange = rangeComparisons.contains(comparison) ||
        rangeSelectedDates.contains('$year-$month-$day');

    // Check if this is the start or end of range
    final isRangeStart = firstRangeDate == dateString ||
        (rangeSelectedDates.isNotEmpty && rangeSelectedDates.first == '$year-$month-$day');
    final isRangeEnd = endRangeDate == dateString ||
        (rangeSelectedDates.isNotEmpty && rangeSelectedDates.last == '$year-$month-$day');

    Color backgroundColor;
    if (isSelected) {
      backgroundColor = Theme.of(context).primaryColor;
    } else if (isRangeStart || isRangeEnd) {
      // Start and end dates get full opacity
      backgroundColor = Theme.of(context).primaryColor;
    } else if (isInRange) {
      // Middle dates in range get 50% opacity
      backgroundColor = Theme.of(context).primaryColor.withValues(alpha: 0.5);
    } else if (isToday) {
      backgroundColor = widget.todaysDateBackgroundColor;
    } else {
      backgroundColor = LibColors.grey300;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 1,
        horizontal: horizontalPadding18(context),
      ),
      child: GestureDetector(
        onTap: () => _onDateTap(dateString, comparison),
        onLongPress: () => _onDateLongPress(dateString, comparison, day, month, year),
        child: Container(
          alignment: Alignment.center,
          height: height12(context),
          width: width203(context),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '$day',
                  style: const TextStyle(color: LibColors.blackColor),
                ),
              ),
              if (widget.displayGregorianCalender)
                Expanded(
                  child: Text(
                    ethiopianToGregorianDateConvertor(day, currentMoment, true),
                    style: const TextStyle(color: LibColors.blackColor),
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
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding098(context),
        horizontal: horizontalPadding18(context),
      ),
      child: Container(
        alignment: Alignment.center,
        height: height12(context),
        width: width203(context),
        decoration: BoxDecoration(
          color: LibColors.grey100,
          borderRadius: BorderRadius.circular(60),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              _getCancelText(),
              style: EthiopianDatePickerFont.textFont().copyWith(
                fontSize: textFont025(context),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              _confirmSelection();
              Navigator.pop(context);
            },
            child: Text(
              _getOkayText(),
              style: EthiopianDatePickerFont.textFont().copyWith(
                fontSize: textFont025(context),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCancelText() {
    switch (widget.userLanguage) {
      case 'am':
        return LibAmharicStrings.cancel;
      case 'ao':
        return LibOromoStrings.cancel;
      default:
        return LibEnglishStrings.cancel;
    }
  }

  String _getOkayText() {
    switch (widget.userLanguage) {
      case 'am':
        return LibAmharicStrings.okay;
      case 'ao':
        return LibOromoStrings.okay;
      default:
        return LibEnglishStrings.okay;
    }
  }

  bool _isToday(int year, int month, int day) {
    final today = EtDatetime.now();
    return year == today.year && month == today.month && day == today.day;
  }
}