# Custom Calendar

<div style='width: 100%'>
    <img src="https://user-images.githubusercontent.com/48450982/222988412-30ea55a8-8d41-47b2-a106-bd52987217aa.gif" width="49%"/>
    <img src="https://user-images.githubusercontent.com/48450982/222988423-943e5516-7dea-45ff-b3d3-2adeff549889.gif" width="49%"/>
</div>

## Features

- Add/remove multiple days
- Set available days to edit
- Excluded week days
- View full month
- View days from previous month
- View days from next month

## Usage

```dart
CalendarModule(
    firstDateTimeInCalendar: DateTime.now(),
    lastDateTimeInCalendar: DateTime.now().add(const Duration(days: 90)),
    listAllAvailableDaysToEdit: [
        DateTime.now().add(const Duration(days: 3)),
        DateTime.now().add(const Duration(days: 4)),
        DateTime.now().add(const Duration(days: 5)),
        DateTime.now().add(const Duration(days: 6)),
        DateTime.now().add(const Duration(days: 7)),
    ],
    listSelectedDays: [
        DateTime.now().add(const Duration(days: 2)),
        DateTime.now().add(const Duration(days: 6)),
        DateTime.now().add(const Duration(days: 7)),
    ],
    excludedWeekDays: const [WeekDays.saturday],
    viewFullMonths: true,
    viewDaysFromPreviousMonth: true,
    viewDaysFromNextMonth: true,
)
