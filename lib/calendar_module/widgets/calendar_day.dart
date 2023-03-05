import 'package:flutter/material.dart';

enum CalendarDayType {
  blackCircle,
  greyCircle,
  onlyBorder,
  available,
  standard,
}

class CalendarDay extends StatelessWidget {
  final DateTime dateTime;
  final CalendarDayType calendarDayType;
  final VoidCallback? onClick;

  const CalendarDay({
    required this.dateTime,
    this.calendarDayType = CalendarDayType.standard,
    this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 4.0,
      ),
      child: LayoutBuilder(
        builder: (context, BoxConstraints boxConstraints) {
          return ElevatedButton(
            onPressed: onClick,
            style: getElevatedButtonStyle(calendarDayType),
            child: Container(
              alignment: Alignment.center,
              height: boxConstraints.maxWidth,
              child: Text(
                dateTime.day.toString(),
              ),
            ),
          );
        },
      ),
    );
  }

  ButtonStyle getElevatedButtonStyle(CalendarDayType calendarDayType) {
    switch (calendarDayType) {
      case CalendarDayType.available:
        return availableStyle();
      case CalendarDayType.blackCircle:
        return blackCircleStyle();
      case CalendarDayType.greyCircle:
        return greyCircleStyle();
      case CalendarDayType.onlyBorder:
        return onlyBorderStyle();
      case CalendarDayType.standard:
        return standardStyle();
      default:
        return ElevatedButton.styleFrom();
    }
  }

  ButtonStyle availableStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: Colors.white,
      foregroundColor: Colors.white,
    );
  }

  ButtonStyle blackCircleStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.white,
      disabledBackgroundColor: Colors.white,
      disabledForegroundColor: Colors.black,
      foregroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
    );
  }

  ButtonStyle greyCircleStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.grey,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.white,
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
    );
  }

  ButtonStyle onlyBorderStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: null,
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
    );
  }

  ButtonStyle standardStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.black,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: Colors.white24,
      foregroundColor: Colors.white,
    );
  }
}
