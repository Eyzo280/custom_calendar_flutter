import 'package:bloc/bloc.dart';
import 'package:custom_calendar/calendar_module/bloc/models/calendar_data_model.dart';
import 'package:custom_calendar/calendar_module/utils/calendar_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required CalendarDataBlocModel calendarDataBlocModel,
  }) : super(CalendarLoaded(
          calendarDataBlocModel: calendarDataBlocModel,
        )) {
    on<CalendarAddDayMode>((event, emit) async {
      if (state is CalendarLoaded) {
        List<DateTime> listDaysReadyToEdit = calendarDataBlocModel.getAllReadyToSelect;

        emit(
          CalendarAddDay(
            listDaysReadyToEdit: listDaysReadyToEdit,
            listSelectedDays: const [],
            listDaysAddedEarlier: calendarDataBlocModel.listSelectedDays,
          ),
        );
      }
    });
    on<CalendarRemoveDayMode>((event, emit) {
      if (state is CalendarLoaded) {
        emit(
          CalendarRemoveDay(
            listSelectedDays: calendarDataBlocModel.listSelectedDays,
            listDaysReadyToEdit: calendarDataBlocModel.getAllReadyToRemove,
            listRemovedDays: const [],
          ),
        );
      }
    });
    on<CalendarAvailableDayClicked>((event, emit) {
      if (state is CalendarAddDay) {
        final state = this.state as CalendarAddDay;

        List<DateTime> listEditedDays = List.from(state.listSelectedDays);

        if (listEditedDays.any((element) => CalendarUtils.isSameDay(element, event.clickedDate))) {
          listEditedDays.remove(event.clickedDate);
        } else {
          listEditedDays.add(event.clickedDate);
        }

        emit(
          state.copyWith(
            listSelectedDays: listEditedDays,
          ),
        );
      }

      if (state is CalendarRemoveDay) {
        final state = this.state as CalendarRemoveDay;

        List<DateTime> listRemovedDays = List.from(state.listRemovedDays);

        if (listRemovedDays.any((element) => CalendarUtils.isSameDay(element, event.clickedDate))) {
          listRemovedDays.remove(event.clickedDate);
        } else {
          listRemovedDays.add(event.clickedDate);
        }

        emit(
          state.copyWith(
            listRemovedDays: listRemovedDays,
          ),
        );
      }
    });
    on<CalendarConfirm>((event, emit) {
      if (state is CalendarAddDay) {
        final state = this.state as CalendarAddDay;

        List<DateTime> listSelectedDays = List.from(calendarDataBlocModel.listSelectedDays)..addAll(state.listSelectedDays);

        calendarDataBlocModel = calendarDataBlocModel.copyWith(listSelectedDays: listSelectedDays);

        emit(
          CalendarLoaded(
            calendarDataBlocModel: calendarDataBlocModel,
          ),
        );
      }

      if (state is CalendarRemoveDay) {
        final state = this.state as CalendarRemoveDay;

        List<DateTime> listSelectedDays = List.from(calendarDataBlocModel.listSelectedDays)
          ..removeWhere(
            (selectedDay) => state.listRemovedDays.any((removedDay) => CalendarUtils.isSameDay(selectedDay, removedDay)),
          );

        calendarDataBlocModel = calendarDataBlocModel.copyWith(listSelectedDays: listSelectedDays);

        emit(
          CalendarLoaded(
            calendarDataBlocModel: calendarDataBlocModel,
          ),
        );
      }
    });
    on<CalendarCancel>((event, emit) {
      emit(
        CalendarLoaded(calendarDataBlocModel: calendarDataBlocModel),
      );
    });
    on<CalendarCheckOrUnCheckAll>((event, emit) {
      if (state is CalendarAddDay) {
        final state = this.state as CalendarAddDay;

        List<DateTime> listSelectedDays = [];

        if (state.listDaysReadyToEdit.length != state.listSelectedDays.length) {
          listSelectedDays = state.listDaysReadyToEdit;
        } else {
          listSelectedDays = [];
        }

        emit(state.copyWith(listSelectedDays: listSelectedDays));
      }

      if (state is CalendarRemoveDay) {
        final state = this.state as CalendarRemoveDay;

        List<DateTime> listRemovedDays = [];

        if (state.listDaysReadyToEdit.length != state.listRemovedDays.length) {
          listRemovedDays = state.listDaysReadyToEdit;
        } else {
          listRemovedDays = [];
        }

        emit(state.copyWith(listRemovedDays: listRemovedDays));
      }
    });
  }
}
