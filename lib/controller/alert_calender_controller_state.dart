part of 'alert_calender_controller_bloc.dart';

abstract class AlertCalenderControllerState extends Equatable {
  final ETC currentMoment;

  const AlertCalenderControllerState(this.currentMoment);
}

/// calender intialState
class AlertCalenderControllerInitial extends AlertCalenderControllerState {
  const AlertCalenderControllerInitial(super.currentMoment);

  @override
  List<Object> get props => [currentMoment];
}

/// first value selected

class SelectedFirstValueState extends AlertCalenderControllerState{
  final int firstNumber;

  const SelectedFirstValueState(ETC moment,this.firstNumber) : super(moment);

  @override
  // TODO: implement props
  List<Object> get props => [firstNumber];

}

/// second value selected

class SelectedSecondValueState extends AlertCalenderControllerState{
  final int secondValue;

  const SelectedSecondValueState(ETC moment,this.secondValue) : super(moment);

  @override
  // TODO: implement props
  List<Object> get props => [secondValue];

}

/// first value remove from list
class RemoveFirstValueState extends AlertCalenderControllerState{
  final int firstNumber;

  const RemoveFirstValueState(ETC moment,this.firstNumber) : super(moment);

  @override
  // TODO: implement props
  List<Object> get props => [firstNumber];

}
/// state used for displaying months on <>
class MonthsState extends AlertCalenderControllerState {
  final ETC currentMonth;
  const MonthsState(this.currentMonth) : super(currentMonth);

  @override
  List<Object> get props => [currentMonth];

}
/// help us to get name from columns division
class SetDayNameState extends AlertCalenderControllerState{
  final String dayName;

  const SetDayNameState(ETC moment, this.dayName) : super(moment);

  @override
  // TODO: implement props
  List<Object?> get props => [dayName];
}
/// this will list calender depeding on selected year
class GetYearsListState extends AlertCalenderControllerState{
  final List yearsList;

  const GetYearsListState(ETC moment, this.yearsList) : super(moment);

  @override
  // TODO: implement props
  List<Object?> get props => [yearsList];

}
/// index selection
class SetSelectedIndexState extends AlertCalenderControllerState{
  final List yearsList;
  final int selectedIndex;
  final int selectedYear;

  const SetSelectedIndexState(this.selectedYear, ETC moment, this.selectedIndex, this.yearsList) : super(moment);

  @override
  // TODO: implement props
  List<Object?> get props => [yearsList, selectedIndex, selectedYear];
}

class SingleValuesIndexState extends AlertCalenderControllerState{
  final String singleDatesList;
  final int dateForComparsion;
  const SingleValuesIndexState(ETC moment, this.singleDatesList, this.dateForComparsion) : super(moment);

  @override
  // TODO: implement props
  List<Object?> get props => [singleDatesList, dateForComparsion];
}

class RemoveValueFromListState extends AlertCalenderControllerState{
  final String singleDatesList;
  final int dateForcomparsion;


  const RemoveValueFromListState( ETC currentMoment,
      this.singleDatesList, this.dateForcomparsion) :
        super(currentMoment);

  @override
  // TODO: implement props
  List<Object?> get props => [singleDatesList,dateForcomparsion];

}
