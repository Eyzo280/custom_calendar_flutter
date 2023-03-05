import 'package:collection/collection.dart';
import 'package:custom_calendar/calendar_module/bloc/calendar_bloc.dart';
import 'package:custom_calendar/calendar_module/bloc/models/calendar_data_model.dart';
import 'package:custom_calendar/calendar_module/bloc/models/calendar_month_week.dart';
import 'package:custom_calendar/calendar_module/extensions/datetime_extension.dart';
import 'package:custom_calendar/calendar_module/utils/calendar_utils.dart';
import 'package:custom_calendar/calendar_module/widgets/calendar_control_panel.dart';
import 'package:custom_calendar/calendar_module/widgets/calendar_days_tile.dart';
import 'package:custom_calendar/calendar_module/widgets/calendar_top_tile_with_arrows.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

class CalendarModule extends StatefulWidget {
  late final DateTime firstDateTimeInCalendar;
  late final DateTime lastDateTimeInCalendar;
  late final List<DateTime> listAllAvailableDaysToEdit;
  late final List<DateTime> listSelectedDays;
  final List<WeekDays> excludedWeekDays;
  final bool viewFullMonths;
  final bool viewDaysFromPreviousMonth;
  final bool viewDaysFromNextMonth;

  late final List<DateTime> calendarDays;

  CalendarModule({
    required DateTime firstDateTimeInCalendar,
    required DateTime lastDateTimeInCalendar,
    required List<DateTime> listAllAvailableDaysToEdit,
    required List<DateTime> listSelectedDays,
    this.excludedWeekDays = const [],
    this.viewFullMonths = false,
    this.viewDaysFromPreviousMonth = false,
    this.viewDaysFromNextMonth = false,
    super.key,
  }) {
    if (viewFullMonths) {
      this.firstDateTimeInCalendar = DateTime(firstDateTimeInCalendar.year, firstDateTimeInCalendar.month, 01).clearTime().toUtc();
      this.lastDateTimeInCalendar = DateTime(
        lastDateTimeInCalendar.year,
        lastDateTimeInCalendar.month,
        Jiffy(lastDateTimeInCalendar).daysInMonth,
      );
    } else {
      this.firstDateTimeInCalendar = firstDateTimeInCalendar.clearTime().toUtc();
      this.lastDateTimeInCalendar = lastDateTimeInCalendar.clearTime().toUtc();
    }

    calendarDays = [this.firstDateTimeInCalendar];

    while (!CalendarUtils.isSameDay(calendarDays.last, this.lastDateTimeInCalendar)) {
      calendarDays.add(calendarDays.last.add(const Duration(days: 1)).clearTime().toUtc());
    }

    this.listAllAvailableDaysToEdit = List.generate(
      listAllAvailableDaysToEdit.length,
      (index) => listAllAvailableDaysToEdit[index].clearTime().toUtc(),
    )..removeWhere((element) => element.isBefore(this.firstDateTimeInCalendar));

    this.listSelectedDays = List.generate(
      listSelectedDays.length,
      (index) => listSelectedDays[index].clearTime().toUtc(),
    )..removeWhere((element) => element.isBefore(this.firstDateTimeInCalendar));
  }

  @override
  State<CalendarModule> createState() => _CalendarModuleState();
}

class _CalendarModuleState extends State<CalendarModule> {
  double? dayTileHeight;
  double? dayTileWidth;

  PageController pageControllerForTopButton = PageController();
  PageController pageControllerForCalendarDays = PageController();
  ValueNotifier<int> currentIndexForPageViewNotifier = ValueNotifier(0);

  late Map<String, CalendarMonth> mapCalendarMonth;

  @override
  void initState() {
    mapCalendarMonth = {};

    while (mapCalendarMonth.keys.lastOrNull != Jiffy(widget.lastDateTimeInCalendar.clearTime().toUtc()).yM) {
      List<String> allMonthsToGenerate = [];

      for (DateTime dateTime in widget.calendarDays) {
        if (allMonthsToGenerate.lastOrNull != Jiffy(dateTime).yM) {
          allMonthsToGenerate.add(Jiffy(dateTime).yM);
        }
      }

      for (String month in allMonthsToGenerate) {
        List<DateTime> listDaysInThisMonth = [];

        listDaysInThisMonth = widget.calendarDays.where((element) => month == Jiffy(element).yM).toList();

        mapCalendarMonth.putIfAbsent(Jiffy(listDaysInThisMonth.first).yM, () => CalendarMonth.generateCalendarMonth(listDaysInThisMonth));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarBloc(
        calendarDataBlocModel: CalendarDataBlocModel(
          listAllAvailableDaysToEdit: widget.listAllAvailableDaysToEdit,
          listSelectedDays: widget.listSelectedDays,
          excludedWeekDays: widget.excludedWeekDays,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, BoxConstraints boxConstraints) {
          dayTileHeight = boxConstraints.maxHeight / 5;
          dayTileWidth = boxConstraints.maxWidth / 7;

          return Column(
            children: [
              BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  if (state is CalendarLoaded || state is CalendarAddDay || state is CalendarRemoveDay) {
                    return Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: currentIndexForPageViewNotifier,
                          builder: (context, int pageViewCurrentIndex, Widget? child) {
                            return CalendarTopTileWithArrow(
                              pageControllerForTopButton: pageControllerForTopButton,
                              pageViewCurrentIndex: pageViewCurrentIndex,
                              mapCalendarMonth: mapCalendarMonth,
                              onClickPrevious: () {
                                changeMonth(
                                  pageViewCurrentIndex - 1,
                                  changeCalendarDays: true,
                                );
                              },
                              onClickNext: () {
                                changeMonth(
                                  pageViewCurrentIndex + 1,
                                  changeCalendarDays: true,
                                );
                              },
                            );
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: shortNamesDaysOnTop(),
                        ),
                        ExpandablePageView.builder(
                          controller: pageControllerForCalendarDays,
                          onPageChanged: (int index) {
                            changeMonth(index);
                          },
                          itemCount: mapCalendarMonth.values.length,
                          itemBuilder: (context, index) {
                            return CalendarDaysTile(
                              previousMonth: widget.viewDaysFromPreviousMonth && index > 0 ? mapCalendarMonth.values.toList()[index - 1] : null,
                              calendarMonth: mapCalendarMonth.values.toList()[index],
                              nextMonth: widget.viewDaysFromNextMonth && index + 1 < mapCalendarMonth.values.length
                                  ? mapCalendarMonth.values.toList()[index + 1]
                                  : null,
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return const Text('Error');
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const CalendarControlPanel(),
            ],
          );
        },
      ),
    );
  }

  Widget shortNamesDaysOnTop() {
    return Row(
      children: List.generate(
        7,
        (index) => Jiffy(
          DateTime(
            2023,
            02,
            27 + index,
          ),
        ).E,
      )
          .map(
            (e) => Expanded(
              child: Text(
                e.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          )
          .toList(),
    );
  }

  ///
  /// Funkcje
  ///

  void changeMonth(int newIndexForMonth, {bool changeCalendarDays = false}) {
    currentIndexForPageViewNotifier.value = newIndexForMonth;

    pageControllerForTopButton.animateToPage(
      newIndexForMonth,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    if (changeCalendarDays) {
      pageControllerForCalendarDays.animateToPage(
        newIndexForMonth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
