import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'widget_calender_event.dart';
part 'widget_calender_state.dart';

class WidgetCalenderBloc extends Bloc<WidgetCalenderEvent, WidgetCalenderState> {
  WidgetCalenderBloc() : super(WidgetCalenderInitial()) {
    on<WidgetCalenderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
