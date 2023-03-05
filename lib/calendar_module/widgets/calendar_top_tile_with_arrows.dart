import 'package:custom_calendar/calendar_module/bloc/models/calendar_month_week.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class CalendarTopTileWithArrow extends StatelessWidget {
  final PageController pageControllerForTopButton;
  final int pageViewCurrentIndex;
  final Map<String, CalendarMonth> mapCalendarMonth;
  final VoidCallback onClickPrevious;
  final VoidCallback onClickNext;

  const CalendarTopTileWithArrow({
    required this.pageControllerForTopButton,
    required this.pageViewCurrentIndex,
    required this.mapCalendarMonth,
    required this.onClickPrevious,
    required this.onClickNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: pageViewCurrentIndex > 0 ? onClickPrevious : null,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        const Spacer(),
        Expanded(
          child: ExpandablePageView(
            controller: pageControllerForTopButton,
            physics: const NeverScrollableScrollPhysics(),
            children: mapCalendarMonth.values
                .map(
                  (CalendarMonth calendarMonth) => Text(
                    Jiffy(calendarMonth.weeks.first.daysInWeek.first).yMMMM,
                    textAlign: TextAlign.center,
                  ),
                )
                .toList(),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: pageViewCurrentIndex < mapCalendarMonth.values.length - 1 ? onClickNext : null,
          icon: const Icon(Icons.arrow_forward_ios_sharp),
        ),
      ],
    );
  }
}
