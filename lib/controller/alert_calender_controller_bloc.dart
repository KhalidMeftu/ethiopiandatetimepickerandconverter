import 'dart:async';

import 'package:abushakir/abushakir.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'alert_calender_controller_event.dart';
part 'alert_calender_controller_state.dart';

class AlertCalenderControllerBloc extends Bloc<AlertCalenderControllerEvent, AlertCalenderControllerState> {
  AlertCalenderControllerBloc() : super(AlertCalenderControllerInitial()) {
    on<AlertCalenderControllerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
