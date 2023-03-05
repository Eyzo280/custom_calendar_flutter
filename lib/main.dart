import 'package:custom_calendar/calendar_module/bloc/models/calendar_data_model.dart';
import 'package:custom_calendar/calendar_module/calendar_module.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Calendar',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.green.shade800,
            disabledForegroundColor: Colors.white.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        disabledColor: Colors.white60,
      ),
      home: const MyHomePage(title: 'Custom Calendar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime firstDateTimeInCalendar = DateTime.now();
  DateTime lastDateTimeInCalendar = DateTime.now().add(
    const Duration(days: 90),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CalendarModule(
          firstDateTimeInCalendar: firstDateTimeInCalendar,
          lastDateTimeInCalendar: lastDateTimeInCalendar,
          listAllAvailableDaysToEdit: List.generate(
            50,
            (index) => DateTime.now().add(Duration(days: index)),
          ).where((element) => element.isAfter(DateTime.now())).toList()
            ..removeRange(3, 5),
          listSelectedDays: List.generate(
            3,
            (index) => firstDateTimeInCalendar.add(Duration(days: 5 + index)),
          ),
          excludedWeekDays: const [WeekDays.saturday],
          viewFullMonths: true,
          viewDaysFromPreviousMonth: true,
          viewDaysFromNextMonth: true,
        ),
      ),
    );
  }
}
