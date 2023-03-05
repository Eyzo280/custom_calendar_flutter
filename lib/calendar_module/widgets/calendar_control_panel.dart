import 'package:custom_calendar/calendar_module/bloc/calendar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarControlPanel extends StatelessWidget {
  const CalendarControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state is CalendarLoaded) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: state.functionAddDaysAvailable
                      ? () {
                          context.read<CalendarBloc>().add(const CalendarAddDayMode());
                        }
                      : null,
                  child: const Text('Add day'),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: state.functionRemoveDaysAvailable
                      ? () {
                          context.read<CalendarBloc>().add(const CalendarRemoveDayMode());
                        }
                      : null,
                  child: const Text('Remove day'),
                ),
              ),
            ],
          );
        }

        if (state is CalendarAddDay || state is CalendarRemoveDay) {
          bool selectedAll = false;
          bool isChanged = false;

          if (state is CalendarAddDay) {
            selectedAll = state.selectedAll;
            isChanged = state.isChanged;
          }

          if (state is CalendarRemoveDay) {
            selectedAll = state.selectedAll;
            isChanged = state.isChanged;
          }

          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<CalendarBloc>().add(const CalendarCheckOrUnCheckAll());
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    selectedAll ? 'Uncheck all' : 'Check all',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isChanged
                          ? () {
                              context.read<CalendarBloc>().add(const CalendarConfirm());
                            }
                          : null,
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CalendarBloc>().add(const CalendarCancel());
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text(''),
            ),
          ],
        );
      },
    );
  }
}
