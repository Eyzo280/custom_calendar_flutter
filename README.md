# Custom Calendar



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
    listAllAvailableDays: [
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