import 'package:lastspot_app/core/base_import.dart';

class CreateSpotDatetimeSelector extends StatelessWidget {
  final ValueNotifier<DateTime> dateNotifier;
  final ValueNotifier<TimeOfDay> timeNotifier;

  const CreateSpotDatetimeSelector({
    super.key,
    required this.dateNotifier,
    required this.timeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Date Selector
        Expanded(
          child: ValueListenableBuilder<DateTime>(
            valueListenable: dateNotifier,
            builder: (context, date, _) {
              return AppDateTimeField(
                icon: Icons.calendar_today_outlined,
                label: context.loc.date,
                valueText: AppUtils.formatDate(date),
                subText: AppUtils.formatWeekday(date),
                onTap: () async {
                  final newDate = await AppDateTimeField.pickDate(
                    context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (newDate != null) {
                    dateNotifier.value = newDate;
                  }
                },
              );
            },
          ),
        ),
        SizedBox(width: Dimensions.r16.dynamicW),
        // Time Selector
        Expanded(
          child: ValueListenableBuilder<TimeOfDay>(
            valueListenable: timeNotifier,
            builder: (context, time, _) {
              return AppDateTimeField(
                icon: Icons.access_time_outlined,
                label: context.loc.time,
                valueText: time.format(context),
                subText: AppUtils.getTimeOfDayPeriod(context, time),
                onTap: () async {
                  final newTime = await AppDateTimeField.pickTime(
                    context,
                    initialTime: time,
                  );
                  if (newTime != null) {
                    final now = DateTime.now();
                    final selectedDate = dateNotifier.value;
                    if (selectedDate.year == now.year &&
                        selectedDate.month == now.month &&
                        selectedDate.day == now.day) {
                      if (newTime.hour < now.hour ||
                          (newTime.hour == now.hour &&
                              newTime.minute < now.minute)) {
                        if (context.mounted) {
                          AppUtils.showSnackBar(
                            context,
                            context.loc.pleaseSelectFutureTime,
                          );
                        }
                        return;
                      }
                    }
                    timeNotifier.value = newTime;
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
