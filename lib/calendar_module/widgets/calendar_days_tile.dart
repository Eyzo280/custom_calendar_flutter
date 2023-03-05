import 'package:collection/collection.dart';
import 'package:custom_calendar/calendar_module/bloc/calendar_bloc.dart';
import 'package:custom_calendar/calendar_module/bloc/models/calendar_data_model.dart';
import 'package:custom_calendar/calendar_module/bloc/models/calendar_month_week.dart';
import 'package:custom_calendar/calendar_module/utils/calendar_utils.dart';
import 'package:custom_calendar/calendar_module/widgets/calendar_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarDaysTile extends StatelessWidget {
  final CalendarMonth? previousMonth;
  final CalendarMonth calendarMonth;
  final CalendarMonth? nextMonth;

  const CalendarDaysTile({
    this.previousMonth,
    required this.calendarMonth,
    this.nextMonth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: calendarMonth.weeks
          .map(
            (CalendarWeek calendarWeek) => _buildWeek(calendarWeek.daysInWeek),
          )
          .toList(),
    );
  }

  Widget _buildWeek(List<DateTime> daysInWeek) {
    List<int> weekDays = List.generate(7, (index) => index);

    return Row(
      children: weekDays.map(
        (index) {
          Widget widgetToBuild;

          var dayConstains = daysInWeek.firstWhereOrNull((DateTime dateTime) => dateTime.weekday - 1 == index);

          if (dayConstains == null) {
            if (CalendarUtils.isSameMonth(daysInWeek.first.subtract(const Duration(days: 1)), previousMonth?.getFirstDayForMonth)) {
              dayConstains = previousMonth?.weeks.last.daysInWeek.lastWhereOrNull((DateTime dateTime) => dateTime.weekday - 1 == index);
            } else if (CalendarUtils.isSameMonth(daysInWeek.last.add(const Duration(days: 1)), nextMonth?.getFirstDayForMonth)) {
              dayConstains = nextMonth?.weeks.first.daysInWeek.firstWhereOrNull((DateTime dateTime) => dateTime.weekday - 1 == index);
            }
          }

          if (dayConstains == null) {
            widgetToBuild = const SizedBox.shrink();
          } else {
            widgetToBuild = _buildDay(dayConstains);
          }

          return Expanded(
            child: widgetToBuild,
          );
        },
      ).toList(),
    );
  }

  Widget _buildDay(DateTime dateTimeForDay) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state is CalendarLoaded) {
          CalendarDataBlocModel calendarDataBlocModel = state.calendarDataBlocModel;

          if (calendarDataBlocModel.selectedDayAndNotReadyToEdit(dateTimeForDay)) {
            return CalendarDay(
              calendarDayType: CalendarDayType.greyCircle,
              dateTime: dateTimeForDay,
            );
          }

          if (calendarDataBlocModel.selectedDayAndReadyToEdit(dateTimeForDay)) {
            return CalendarDay(
              calendarDayType: CalendarDayType.blackCircle,
              dateTime: dateTimeForDay,
            );
          }

          if (calendarDataBlocModel.notSelectedDayAndReadyToEdit(dateTimeForDay)) {
            return CalendarDay(
              calendarDayType: CalendarDayType.available,
              dateTime: dateTimeForDay,
            );
          }
        }

        if (state is CalendarAddDay) {
          if (state.readyToEdit(dateTimeForDay)) {
            return CalendarDay(
              calendarDayType: state.isSelected(dateTimeForDay) ? CalendarDayType.blackCircle : CalendarDayType.onlyBorder,
              dateTime: dateTimeForDay,
              onClick: () => context.read<CalendarBloc>().add(
                    CalendarAvailableDayClicked(clickedDate: dateTimeForDay),
                  ),
            );
          }

          if (state.addedEarlier(dateTimeForDay)) {
            return CalendarDay(
              calendarDayType: CalendarDayType.greyCircle,
              dateTime: dateTimeForDay,
              onClick: null,
            );
          }
        }

        if (state is CalendarRemoveDay) {
          if (state.readyToEdit(dateTimeForDay)) {
            return CalendarDay(
              calendarDayType: !state.isRemoved(dateTimeForDay) ? CalendarDayType.blackCircle : CalendarDayType.onlyBorder,
              dateTime: dateTimeForDay,
              onClick: () => context.read<CalendarBloc>().add(
                    CalendarAvailableDayClicked(clickedDate: dateTimeForDay),
                  ),
            );
          }

          if (state.isSelectedAndNotEditableDay(dateTimeForDay)) {
            return CalendarDay(
              calendarDayType: CalendarDayType.greyCircle,
              dateTime: dateTimeForDay,
              onClick: null,
            );
          }
        }

        return CalendarDay(
          dateTime: dateTimeForDay,
          calendarDayType: CalendarDayType.standard,
        );
      },
    );
  }
}
