import 'package:abushakir/abushakir.dart';
import 'package:ethiopiandatepickerandconvertor/const/lib_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ethiopiandatepickerandconvertor/const/app_strings.dart';

part 'alert_calender_controller_event.dart';
part 'alert_calender_controller_state.dart';

class AlertCalenderControllerBloc extends Bloc<AlertCalenderControllerEvent, AlertCalenderControllerState> {

  AlertCalenderControllerBloc() : super(AlertCalenderControllerInitial(ETC.today())) {
    on<AlertIntialEvent>((event, emit) {
      emit(AlertCalenderControllerInitial(ETC.today()));
    });
    on<RemoveSecondValueAfterBothAdded>((event, emit) {
      _removeSecondValueAfterBoth(event, emit);
    });
    on<RemoveSecondValue>((event, emit) {
      _removeSecondValue(event, emit);
    });
    on<AddSecondValue>((event, emit) {

      _addSecondValue(event, emit);
    });

    on<RemoveInitialValue>((event, emit) {
      _removeInitialValue(event, emit);
    });
    on<AddInitialValue>((event, emit) {
      _addInitialValue(event, emit);
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
      _getDayName(event, emit,  ETC.today());
    });
    on<NextMonthCalendar>((event, emit) {
      // TODO: implement event handler
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

    emit(MonthsState(getCalenderSpecificYear(event.year)));
  }

  void _getNextYear(NextYearCalendar event, Emitter<AlertCalenderControllerState> emit) {}

  void _getPreviousYear(
      PrevYearCalendar event, Emitter<AlertCalenderControllerState> emit) {}

  void _getDayName(
      GetDayName event, Emitter<AlertCalenderControllerState> emit, ETC currentMoment) {
    if ((event.dayIndex % event.crossAxisCount) + 1 == 1) {
      if(event.userLanguage=="am")
        {
          emit(SetDayNameState(currentMoment, LibAmharicStrings.monday));
        }
      if(event.userLanguage=="ao")
      {
        emit(SetDayNameState(currentMoment, LibOromoStrings.monday));
      }
      else{
        emit(SetDayNameState(currentMoment, LibEnglishStrings.monday));
      }

    }
    if ((event.dayIndex % event.crossAxisCount) + 1 == 2) {
      if(event.userLanguage=="am")
      {
        emit(SetDayNameState(currentMoment, LibAmharicStrings.tuesday));
      }
      if(event.userLanguage=="ao")
      {
        emit(SetDayNameState(currentMoment, LibOromoStrings.tuesday));
      }
      else{
        emit(SetDayNameState(currentMoment, LibEnglishStrings.tuesday));
      }
    }

    if ((event.dayIndex % event.crossAxisCount) + 1 == 3) {

      if(event.userLanguage=="am")
      {
        emit(SetDayNameState(currentMoment, LibAmharicStrings.wednesday));
      }
      if(event.userLanguage=="ao")
      {
        emit(SetDayNameState(currentMoment, LibOromoStrings.wednesday));
      }
      else{
        emit(SetDayNameState(currentMoment, LibEnglishStrings.wednesday));
      }
    }

    if ((event.dayIndex % event.crossAxisCount) + 1 == 4) {
      if(event.userLanguage=="am")
      {
        emit(SetDayNameState(currentMoment, LibAmharicStrings.thursday));
      }
      if(event.userLanguage=="ao")
      {
        emit(SetDayNameState(currentMoment, LibOromoStrings.thursday));
      }
      else{
        emit(SetDayNameState(currentMoment, LibEnglishStrings.thursday));
      }
    }

    if ((event.dayIndex % event.crossAxisCount) + 1 == 5) {
      if(event.userLanguage=="am")
      {
        emit(SetDayNameState(currentMoment, LibAmharicStrings.friday));
      }
      if(event.userLanguage=="ao")
      {
        emit(SetDayNameState(currentMoment, LibOromoStrings.friday));
      }
      else{
        emit(SetDayNameState(currentMoment, LibEnglishStrings.friday));
      }
    }

    if ((event.dayIndex % event.crossAxisCount) + 1 == 6) {
      if(event.userLanguage=="am")
      {
        emit(SetDayNameState(currentMoment, LibAmharicStrings.saturday));
      }
      if(event.userLanguage=="ao")
      {
        emit(SetDayNameState(currentMoment, LibOromoStrings.saturday));
      }
      else{
        emit(SetDayNameState(currentMoment, LibEnglishStrings.saturday));
      }

    }

    if ((event.dayIndex % event.crossAxisCount) + 1 == 7) {
      if(event.userLanguage=="am")
      {
        emit(SetDayNameState(currentMoment, LibAmharicStrings.sunday));
      }
      if(event.userLanguage=="ao")
      {
        emit(SetDayNameState(currentMoment, LibOromoStrings.sunday));
      }
      else{
        emit(SetDayNameState(currentMoment, LibEnglishStrings.sunday));
      }

    }
  }

  void _getYearsList(GetYearList event, Emitter<AlertCalenderControllerState> emit) {

    List yearsList = [];
    for (int i = event.startYear; i <= event.endYear; i++) {
      yearsList.add(i);
    }
    emit(GetYearsListState(ETC.today(), yearsList));
  }

  void _getSelectedIndex(
      GetSelectedIndex event, Emitter<AlertCalenderControllerState> emit) {
    List yearsList = [];
    for (int i = event.startYear; i <= event.endYear; i++) {
      yearsList.add(i);
    }
    emit(SetSelectedIndexState(
        event.selectedYear, ETC.today(), event.selectedIndex, yearsList));
  }

  void _addSingleValuesToList(
      AddSingleValues event, Emitter<AlertCalenderControllerState> emit) {

    emit(SingleValuesIndexState(
        event.currentMoment, event.singleDate, event.dateForComparision));
  }

  void _removeValueFromList(
      RemoveItemFromList event, Emitter<AlertCalenderControllerState> emit) {
    emit(RemoveValueFromListState(
        event.currentMoment, event.singleDate, event.dateForComparsion));
  }

  void _addInitialValue(AddInitialValue event, Emitter<AlertCalenderControllerState> emit) {


    emit(AddFirstValueState(event.day, event.month, event.year,event.currentMoment,event.firstDate, event.firstDateForComparision));
  }

  void _removeInitialValue(RemoveInitialValue event, Emitter<AlertCalenderControllerState> emit) {
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

