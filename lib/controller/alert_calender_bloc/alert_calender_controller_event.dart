part of 'alert_calender_controller_bloc.dart';

abstract class AlertCalenderControllerEvent extends Equatable {
  const AlertCalenderControllerEvent();
}

/// select first value
class GetFirstValueEvent extends AlertCalenderControllerEvent{
  /// we are on range mode
  final int firstValue;

  GetFirstValueEvent(this.firstValue);

  @override
  // TODO: implement props
  List<Object> get props => [firstValue];

}
/// select second value
class GetSecondValueEvent extends AlertCalenderControllerEvent{
  /// we are on range mode
  final int secondValue;

  GetSecondValueEvent(this.secondValue);

  @override
  // TODO: implement props
  List<Object> get props => [secondValue];

}
/// remove first value
class RemoveFirstValueEvent extends AlertCalenderControllerEvent{
  /// we are on range mode
  final int firstValue;

  RemoveFirstValueEvent(this.firstValue);

  @override
  // TODO: implement props
  List<Object> get props => [firstValue];

}
/// remove second value
class RemoveSecondValueEvent extends AlertCalenderControllerEvent{
  /// we are on range mode
  final int secondValue;

  RemoveSecondValueEvent(this.secondValue);

  @override
  // TODO: implement props
  List<Object> get props => [secondValue];

}
///get selected values will respond lists of user selected values
class GetSelectedValuesEvent extends AlertCalenderControllerEvent{
  final List selectedValues;

  GetSelectedValuesEvent(this.selectedValues);

  @override
  // TODO: implement props
  List<Object> get props => [selectedValues];
}
class TodayCalendar extends AlertCalenderControllerEvent {
  final ETC currentMonth;

  const TodayCalendar(this.currentMonth);

  @override
  List<Object> get props => [currentMonth];

  @override
  String toString() => "Today's Calendar { Calendar: $currentMonth }";
}
class NextMonthCalendar extends AlertCalenderControllerEvent {
  final ETC currentMonth;

  const NextMonthCalendar(this.currentMonth);

  @override
  List<Object> get props => [currentMonth.nextMonth ];

  @override
  String toString() => "Next Month's Calendar { Calendar: ${currentMonth.nextMonth} }";
}
class PrevMonthCalendar extends AlertCalenderControllerEvent {
  final ETC currentMonth;

  const PrevMonthCalendar(this.currentMonth);

  @override
  List<Object> get props => [currentMonth.prevMonth ];

  @override
  String toString() => "Previous Month's Calendar { Calendar: ${currentMonth.prevMonth} }";
}
class CalenderByYear extends AlertCalenderControllerEvent{
  final int year;
  final ETC currentMonth;

  CalenderByYear(this.currentMonth, this.year);

  @override
  // TODO: implement props
  List<Object> get props => [currentMonth, year];

}
class NextYearCalendar extends AlertCalenderControllerEvent{
  final ETC currentMonth;

  const NextYearCalendar(this.currentMonth);

  @override
  List<Object> get props => [currentMonth.nextMonth ];

  @override
  String toString() => "Next Month's Calendar { Calendar: ${currentMonth.nextMonth} }";
}
class PrevYearCalendar extends AlertCalenderControllerEvent {
  final ETC currentMonth;

  const PrevYearCalendar(this.currentMonth);

  @override
  List<Object> get props => [currentMonth.prevMonth ];

  @override
  String toString() => "Previous Month's Calendar { Calendar: ${currentMonth.prevMonth} }";
}
class GetDayName extends AlertCalenderControllerEvent{
  final int DayIndex;
  final int CrossAxisCount;

  const GetDayName(this.DayIndex, this.CrossAxisCount);

  @override
  // TODO: implement props
  List<Object?> get props => [DayIndex, CrossAxisCount];

}
//GetSelectedIndex
class GetYearList extends AlertCalenderControllerEvent{
  final int startYear;
  final int endYear;

  const GetYearList(this.startYear, this.endYear);

  @override
  // TODO: implement props
  List<Object?> get props => [startYear,endYear];



}
class GetSelectedIndex extends AlertCalenderControllerEvent{
  final int selectedIndex;
  final int startYear;
  final int endYear;
  final int selectedYear;

  const GetSelectedIndex(this.selectedIndex, this.startYear, this.endYear, this.selectedYear);

  @override
  // TODO: implement props
  List<Object?> get props => [selectedIndex, startYear, endYear, selectedYear];


}
//GetSelectedIndex
// single dates selection mode
class AddSingleValues extends AlertCalenderControllerEvent{
  final String singleDate;
  final  ETC currentMoment;
  final int dateForcomparsion;

  const AddSingleValues(this.singleDate, this.currentMoment, this.dateForcomparsion);

  @override
  // TODO: implement props
  List<Object?> get props => [singleDate, currentMoment, dateForcomparsion];
}
class RemoveItemFromList extends AlertCalenderControllerEvent{
  final String singleDate;
  final  ETC currentMoment;
  final int dateForcomparsion;

  const RemoveItemFromList(this.singleDate, this.currentMoment, this.dateForcomparsion);

  @override
  // TODO: implement props
  List<Object?> get props => [singleDate, currentMoment, dateForcomparsion];
}
/// long press action add firstValue
class AddInitalValue extends AlertCalenderControllerEvent{
  final  String firstDate;
  final int day;
  final int month;
  final int year;
  final int firstDateForComparision;
  final ETC currentMoment;

  const AddInitalValue(this.firstDate,this.day, this.month, this.year, this.firstDateForComparision, this.currentMoment);

  @override
  // TODO: implement props
  List<Object?> get props => [firstDate, day, month,year, firstDateForComparision,currentMoment];
}
/// remove initial
class RemoveInitalValue extends AlertCalenderControllerEvent{
  final  String firstDate;
  final int firstDateForComparision;
  final ETC currentMoment;

  const RemoveInitalValue(this.firstDate, this.firstDateForComparision, this.currentMoment);

  @override
  // TODO: implement props
  List<Object?> get props => [firstDate,firstDateForComparision,currentMoment];

}
class AddSecondValue extends AlertCalenderControllerEvent{
  final  String secondDate;
  final int day;
  final int month;
  final int year;
  final int firstDateForComparision;
  final ETC currentMoment;
  const AddSecondValue(this.secondDate,this.day, this.month, this.year, this.firstDateForComparision, this.currentMoment);

  @override
  // TODO: implement props
 List<Object?> get props => [secondDate, day, month,year, firstDateForComparision,currentMoment];

}
class RemoveSecondValue extends AlertCalenderControllerEvent{
  final  String secondDate;
  final int firstDateForComparision;
  final ETC currentMoment;

  const RemoveSecondValue(this.secondDate, this.firstDateForComparision, this.currentMoment);

  @override
  // TODO: implement props
  List<Object?> get props => [secondDate, firstDateForComparision, currentMoment];

}
//AddSecondValue  RemoveSecondValue
class RemoveSecondValueAfterBothAdded extends AlertCalenderControllerEvent{
  final  String secondDate;
  final int firstDateForComparision;
  final ETC currentMoment;

  const RemoveSecondValueAfterBothAdded(this.secondDate, this.firstDateForComparision, this.currentMoment);

  @override
  // TODO: implement props
  List<Object?> get props => [secondDate, firstDateForComparision, currentMoment];
}