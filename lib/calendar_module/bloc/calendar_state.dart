part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {
  const CalendarState();
}

class CalendarLoaded extends CalendarState {
  final CalendarDataBlocModel calendarDataBlocModel;

  const CalendarLoaded({
    required this.calendarDataBlocModel,
  });

  bool get functionAddDaysAvailable => calendarDataBlocModel.getAllReadyToSelect.isNotEmpty;

  bool get functionRemoveDaysAvailable => calendarDataBlocModel.getAllReadyToRemove.isNotEmpty;
}

class CalendarAddDay extends CalendarState {
  final List<DateTime> listDaysReadyToEdit;
  final List<DateTime> listSelectedDays;
  final List<DateTime> listDaysAddedEarlier;

  const CalendarAddDay({
    required this.listDaysReadyToEdit,
    required this.listSelectedDays,
    required this.listDaysAddedEarlier,
  });

  CalendarAddDay copyWith({
    List<DateTime>? listDaysReadyToEdit,
    required List<DateTime> listSelectedDays,
  }) {
    return CalendarAddDay(
      listDaysReadyToEdit: listDaysReadyToEdit ?? this.listDaysReadyToEdit,
      listSelectedDays: listSelectedDays,
      listDaysAddedEarlier: listDaysAddedEarlier,
    );
  }

  bool get functionAvailable => listDaysReadyToEdit.isNotEmpty;

  bool get selectedAll => listDaysReadyToEdit.length == listSelectedDays.length;

  bool get isChanged => listSelectedDays.isNotEmpty;

  bool readyToEdit(DateTime dateTime) {
    return listDaysReadyToEdit.any((element) => CalendarUtils.isSameDay(element, dateTime));
  }

  bool isSelected(DateTime dateTime) {
    return listSelectedDays.any((element) => CalendarUtils.isSameDay(element, dateTime));
  }

  bool addedEarlier(DateTime dateTime) {
    return listDaysAddedEarlier.any((element) => CalendarUtils.isSameDay(element, dateTime));
  }
}

class CalendarRemoveDay extends CalendarState {
  final List<DateTime> listSelectedDays;
  final List<DateTime> listDaysReadyToEdit;
  final List<DateTime> listRemovedDays;

  const CalendarRemoveDay({
    required this.listSelectedDays,
    required this.listDaysReadyToEdit,
    required this.listRemovedDays,
  });

  CalendarRemoveDay copyWith({
    List<DateTime>? listDaysReadyToEdit,
    required List<DateTime> listRemovedDays,
  }) {
    return CalendarRemoveDay(
      listSelectedDays: listSelectedDays,
      listDaysReadyToEdit: listDaysReadyToEdit ?? this.listDaysReadyToEdit,
      listRemovedDays: listRemovedDays,
    );
  }

  bool get functionAvailable => listDaysReadyToEdit.isNotEmpty;

  bool get selectedAll => listDaysReadyToEdit.length == listRemovedDays.length;

  bool get isChanged => listRemovedDays.isNotEmpty;

  bool readyToEdit(DateTime dateTime) {
    return listDaysReadyToEdit.any((element) => CalendarUtils.isSameDay(element, dateTime));
  }

  bool isRemoved(DateTime dateTime) {
    return listRemovedDays.any((element) => CalendarUtils.isSameDay(element, dateTime));
  }

  bool isSelectedAndNotEditableDay(DateTime dateTime) {
    return listSelectedDays.where((selectedDays) => !listDaysReadyToEdit.contains(selectedDays)).any(
          (element) => CalendarUtils.isSameDay(element, dateTime),
        );
  }
}
