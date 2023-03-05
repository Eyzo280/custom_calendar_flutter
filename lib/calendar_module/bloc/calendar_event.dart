part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class CalendarAvailableDayClicked extends CalendarEvent {
  final DateTime clickedDate;

  const CalendarAvailableDayClicked({
    required this.clickedDate,
  });
}

class CalendarAddDayMode extends CalendarEvent {
  const CalendarAddDayMode();
}

class CalendarRemoveDayMode extends CalendarEvent {
  const CalendarRemoveDayMode();
}

class CalendarConfirm extends CalendarEvent {
  const CalendarConfirm();
}

class CalendarCancel extends CalendarEvent {
  const CalendarCancel();
}

class CalendarCheckOrUnCheckAll extends CalendarEvent {
  const CalendarCheckOrUnCheckAll();
}
