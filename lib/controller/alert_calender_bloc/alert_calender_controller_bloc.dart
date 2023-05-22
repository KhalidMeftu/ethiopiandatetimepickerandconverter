import 'dart:async';

import 'package:abushakir/abushakir.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'alert_calender_controller_event.dart';
part 'alert_calender_controller_state.dart';

class AlertCalenderControllerBloc extends Bloc<AlertCalenderControllerEvent, AlertCalenderControllerState> {
  final ETC currentMoment;

  AlertCalenderControllerBloc(this.currentMoment) : super(AlertCalenderControllerInitial(currentMoment)) {
    on<RemoveSecondValueAfterBothAdded>((event, emit) {
      _removeSecondValueAfterBoth(event, emit);
    });
    on<RemoveSecondValue>((event, emit) {
      _removeSecondValue(event, emit);
    });
    on<AddSecondValue>((event, emit) {

      _addSecondValue(event, emit);
    });

    on<RemoveInitalValue>((event, emit) {
      _removeInitalValue(event, emit);
    });
    on<AddInitalValue>((event, emit) {
      _addInitalValue(event, emit);
    });
    on<RemoveItemFromList>((event, emit) {
      _removeValueFromList(event, emit);
    });
    on<AddSingleValues>((event, emit) {
      _addSingleValuesToList(event, emit);
    });
    on<GetSelectedIndex>((event, emit) {
      _getSelectedIndex(event, emit);
    });
    on<GetYearList>((event, emit) {
      _getYearsList(event, emit);
    });
    on<GetDayName>((event, emit) {
      // TODO: implement event handler
      _getDayName(event, emit, currentMoment);
    });
    on<GetFirstValueEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetSecondValueEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<RemoveFirstValueEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<RemoveSecondValueEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetSelectedValuesEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<NextMonthCalendar>((event, emit) {
      // TODO: implement event handler
      print('Next month clicked');
      _getNextMonth(event, emit);
    });

    on<PrevMonthCalendar>((event, emit) {
      // TODO: implement event handler
      _getPreviousMonth(event, emit);
    });
    on<CalenderByYear>((event, emit) {
      // TODO: implement event handler
      _getCalenderByYear(event, emit);
    });
    on<NextYearCalendar>((event, emit) {
      // TODO: implement event handler

      _getNextYear(event, emit);
    });

    on<PrevYearCalendar>((event, emit) {
      // TODO: implement event handler
      _getPreviousYear(event, emit);
    });
  }

  void _getNextMonth(NextMonthCalendar event, Emitter<AlertCalenderControllerState> emit) {
    emit(MonthsState(event.currentMonth.nextMonth));
  }

  void _getPreviousMonth(
      PrevMonthCalendar event, Emitter<AlertCalenderControllerState> emit) {
    emit(MonthsState(event.currentMonth.prevMonth));
  }

  void _getCalenderByYear(CalenderByYear event, Emitter<AlertCalenderControllerState> emit) {
    emit(MonthsState(event.currentMonth.calenderbyyear(event.year)));
  }

  void _getNextYear(NextYearCalendar event, Emitter<AlertCalenderControllerState> emit) {}

  void _getPreviousYear(
      PrevYearCalendar event, Emitter<AlertCalenderControllerState> emit) {}

  void _getDayName(
      GetDayName event, Emitter<AlertCalenderControllerState> emit, ETC currentMoment) {
    if ((event.DayIndex % event.CrossAxisCount) + 1 == 1) {
      //                  print("Col${(index % crossAxisCount) + 1}");

      emit(SetDayNameState(currentMoment, 'Monday'));
    }
    if ((event.DayIndex % event.CrossAxisCount) + 1 == 2) {
      //                  print("Col${(index % crossAxisCount) + 1}");
      emit(SetDayNameState(currentMoment, 'Tuesday'));
    }

    if ((event.DayIndex % event.CrossAxisCount) + 1 == 3) {
      //                  print("Col${(index % crossAxisCount) + 1}");

      emit(SetDayNameState(currentMoment, 'Wendsday'));

      // return Text('wendsday');
    }

    if ((event.DayIndex % event.CrossAxisCount) + 1 == 4) {
      //                  print("Col${(index % crossAxisCount) + 1}");

      emit(SetDayNameState(currentMoment, 'Thursday'));

      //return Text('thrusday');
    }

    if ((event.DayIndex % event.CrossAxisCount) + 1 == 5) {
      //                  print("Col${(index % crossAxisCount) + 1}");

      emit(SetDayNameState(currentMoment, 'Friday'));

      // return Text('friday');
    }

    if ((event.DayIndex % event.CrossAxisCount) + 1 == 6) {
      //                  print("Col${(index % crossAxisCount) + 1}");

      emit(SetDayNameState(currentMoment, 'Saturday'));

      // return Text('saturday');
    }

    if ((event.DayIndex % event.CrossAxisCount) + 1 == 7) {
      //                  print("Col${(index % crossAxisCount) + 1}");

      emit(SetDayNameState(currentMoment, 'Sunday'));

    }
  }

  void _getYearsList(GetYearList event, Emitter<AlertCalenderControllerState> emit) {

    List yearsList = [];
    for (int i = event.startYear; i <= event.endYear; i++) {
      yearsList.add(i);
    }
    emit(GetYearsListState(currentMoment, yearsList));
  }

  void _getSelectedIndex(
      GetSelectedIndex event, Emitter<AlertCalenderControllerState> emit) {
    List yearsList = [];
    for (int i = event.startYear; i <= event.endYear; i++) {
      yearsList.add(i);
    }
    emit(SetSelectedIndexState(
        event.selectedYear, currentMoment, event.selectedIndex, yearsList));
  }

  void _addSingleValuesToList(
      AddSingleValues event, Emitter<AlertCalenderControllerState> emit) {

    emit(SingleValuesIndexState(
        event.currentMoment, event.singleDate, event.dateForcomparsion));
  }

  void _removeValueFromList(
      RemoveItemFromList event, Emitter<AlertCalenderControllerState> emit) {
    emit(RemoveValueFromListState(
        event.currentMoment, event.singleDate, event.dateForcomparsion));
  }

  void _addInitalValue(AddInitalValue event, Emitter<AlertCalenderControllerState> emit) {


    emit(AddFirstValueState(event.day, event.month, event.year,event.currentMoment,event.firstDate, event.firstDateForComparision));
  }

  void _removeInitalValue(RemoveInitalValue event, Emitter<AlertCalenderControllerState> emit) {
    emit(RemoveLongTapFirstValueState(event.currentMoment,event.firstDate, event.firstDateForComparision));
  }

  void _removeSecondValue(RemoveSecondValue event, Emitter<AlertCalenderControllerState> emit) {
    emit(RemoveLongTapSecondValueState(event.currentMoment,event.secondDate, event.firstDateForComparision));

  }

  void _addSecondValue(AddSecondValue event, Emitter<AlertCalenderControllerState> emit) {
    emit(AddSecondValueState(event.day, event.month, event.year,event.secondDate, event.firstDateForComparision, event.currentMoment));

  }

  void _removeSecondValueAfterBoth(RemoveSecondValueAfterBothAdded event, Emitter<AlertCalenderControllerState> emit) {
    emit(RemoveLongTapSecondValueAfterState(event.currentMoment,event.secondDate, event.firstDateForComparision));

  }
}

