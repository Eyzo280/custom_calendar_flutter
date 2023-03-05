class CalendarWeek {
  final List<DateTime> daysInWeek;

  CalendarWeek({required this.daysInWeek});
}

class CalendarMonth {
  final List<CalendarWeek> weeks;

  CalendarMonth({required this.weeks});

  DateTime get getFirstDayForMonth => weeks.first.daysInWeek.first;

  static CalendarMonth generateCalendarMonth(List<DateTime> listDaysInMonth) {
    List<CalendarWeek> generatedListWeeks = [];

    List<DateTime> daysInWeek = [];

    for (DateTime day in listDaysInMonth) {
      if (daysInWeek.isNotEmpty && daysInWeek.any((element) => element.weekday == day.weekday) ||
          listDaysInMonth.last == day ||
          (daysInWeek.isNotEmpty && daysInWeek.last.weekday > day.weekday)) {
        if (listDaysInMonth.last == day) {
          daysInWeek.add(day);
        }

        generatedListWeeks.add(CalendarWeek(daysInWeek: daysInWeek));
        daysInWeek = [];
      }

      daysInWeek.add(day);
    }

    return CalendarMonth(weeks: generatedListWeeks);
  }
}
