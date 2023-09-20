part of 'alert_calender_controller_bloc.dart';

abstract class AlertCalenderControllerEvent extends Equatable {
  const AlertCalenderControllerEvent();
}
class AlertIntialEvent extends AlertCalenderControllerEvent{

  const AlertIntialEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
/// select first value
class GetFirstValue extends AlertCalenderControllerEvent{
  /// we are on range mode
  final int firstValue;

  const GetFirstValue(this.firstValue);

  @override
  // TODO: implement props
  List<Object> get props => [firstValue];

}
/// select second value
class GetSecondValueEvent extends AlertCalenderControllerEvent{
  /// we are on range mode
  final int secondValue;

  const GetSecondValueEvent(this.secondValue);

  @override
  // TODO: implement props
  List<Object> get props => [secondValue];

}
/// remove first value
class RemoveFirstValueEvent extends AlertCalenderControllerEvent{
  /// we are on range mode
  final int firstValue;

  const RemoveFirstValueEvent(this.firstValue);

  @override
  // TODO: implement props
  List<Object> get props => [firstValue];

}
/// remove second value
class RemoveSecondValueEvent extends AlertCalenderControllerEvent{
  /// we are on range mode
  final int secondValue;

  const RemoveSecondValueEvent(this.secondValue);

  @override
  // TODO: implement props
  List<Object> get props => [secondValue];

}
///get selected values will respond lists of user selected values
class GetSelectedValuesEvent extends AlertCalenderControllerEvent{
  final List selectedValues;

  const GetSelectedValuesEvent(this.selectedValues);

  @override
  // TODO: implement props
  List<Object> get props => [selectedValues];
}
class CurrentDayCalendar extends AlertCalenderControllerEvent {
  final ETC currentMonth;

  const CurrentDayCalendar(this.currentMonth);

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

  const CalenderByYear(this.currentMonth, this.year);

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
  final int dayIndex;
  final int crossAxisCount;
  final String userLanguage;

  const GetDayName(this.dayIndex, this.crossAxisCount, this.userLanguage);

  @override
  // TODO: implement props
  List<Object?> get props => [dayIndex, crossAxisCount];

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
  final int dateForComparision;

  const AddSingleValues(this.singleDate, this.currentMoment, this.dateForComparision);

  @override
  // TODO: implement props
  List<Object?> get props => [singleDate, currentMoment, dateForComparision];
}
class RemoveItemFromList extends AlertCalenderControllerEvent{
  final String singleDate;
  final  ETC currentMoment;
  final int dateForComparsion;

  const RemoveItemFromList(this.singleDate, this.currentMoment, this.dateForComparsion);

  @override
  // TODO: implement props
  List<Object?> get props => [singleDate, currentMoment, dateForComparsion];
}
/// long press action add firstValue
class AddInitialValue extends AlertCalenderControllerEvent{
  final  String firstDate;
  final int day;
  final int month;
  final int year;
  final int firstDateForComparision;
  final ETC currentMoment;

  const AddInitialValue(this.firstDate,this.day, this.month, this.year, this.firstDateForComparision, this.currentMoment);

  @override
  // TODO: implement props
  List<Object?> get props => [firstDate, day, month,year, firstDateForComparision,currentMoment];
}
/// remove initial
class RemoveInitialValue extends AlertCalenderControllerEvent{
  final  String firstDate;
  final int firstDateForComparision;
  final ETC currentMoment;

  const RemoveInitialValue(this.firstDate, this.firstDateForComparision, this.currentMoment);

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