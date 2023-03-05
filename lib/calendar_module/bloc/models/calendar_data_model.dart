import 'package:custom_calendar/calendar_module/utils/calendar_utils.dart';

enum WeekDays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class CalendarDataBlocModel {
  /// Dni dostepne do edytowania
  final List<DateTime> listAllAvailableDaysToEdit;

  /// Lista wybranych dni i dostepnych do edytowania
  final List<DateTime> listSelectedDays;

  /// Lista wykluczonych dni z edytowania
  final List<WeekDays> excludedWeekDays;

  CalendarDataBlocModel({
    required this.listAllAvailableDaysToEdit,
    required this.listSelectedDays,
    required this.excludedWeekDays,
  });

  CalendarDataBlocModel copyWith({
    List<DateTime>? listAllAvailableDaysToEdit,
    required List<DateTime> listSelectedDays,
    List<WeekDays>? excludedWeekDays,
  }) {
    return CalendarDataBlocModel(
      listAllAvailableDaysToEdit: listAllAvailableDaysToEdit ?? this.listAllAvailableDaysToEdit,
      listSelectedDays: listSelectedDays,
      excludedWeekDays: excludedWeekDays ?? this.excludedWeekDays,
    );
  }

  List<DateTime> get getAllReadyToSelect => listAllAvailableDaysToEdit.where((availableDay) => notSelectedDayAndReadyToEdit(availableDay)).toList();

  List<DateTime> get getAllReadyToRemove => listSelectedDays.where((availableDay) => selectedDayAndReadyToEdit(availableDay)).toList();

  ///
  /// Dostepne dni do wyboru
  ///
  bool notSelectedDayAndReadyToEdit(DateTime dateTimeForDay) {
    return !listSelectedDays.any(
          (element) => CalendarUtils.isSameDay(element, dateTimeForDay),
        ) &&
        listAllAvailableDaysToEdit.any(
          (element) => CalendarUtils.isSameDay(element, dateTimeForDay),
        ) &&
        !excludedWeekDays.any((element) => (WeekDays.values.indexOf(element) + 1) == dateTimeForDay.weekday);
  }

  ///
  /// Dostepne dni do usuniecia
  ///
  bool selectedDayAndReadyToEdit(DateTime dateTimeForDay) {
    return listSelectedDays.any(
          (element) => CalendarUtils.isSameDay(element, dateTimeForDay),
        ) &&
        listAllAvailableDaysToEdit.any(
          (element) => CalendarUtils.isSameDay(element, dateTimeForDay),
        ) &&
        !excludedWeekDays.any((element) => (WeekDays.values.indexOf(element) + 1) == dateTimeForDay.weekday);
  }

  ///
  /// Wybrany dzien bez mozliwosci edycji
  ///
  bool selectedDayAndNotReadyToEdit(DateTime dateTimeForDay) {
    return listSelectedDays.any(
          (element) => CalendarUtils.isSameDay(element, dateTimeForDay),
        ) &&
        (!listAllAvailableDaysToEdit.any(
              (element) => CalendarUtils.isSameDay(element, dateTimeForDay),
            ) ||
            excludedWeekDays.any((element) => (WeekDays.values.indexOf(element) + 1) == dateTimeForDay.weekday));
  }
}
