import 'package:lastspot_app/core/base_import.dart';

class CreateSpotDatetimeSelector extends StatelessWidget {
  final ValueNotifier<DateTime> dateNotifier;
  final ValueNotifier<TimeOfDay> timeNotifier;

  const CreateSpotDatetimeSelector({
    super.key,
    required this.dateNotifier,
    required this.timeNotifier,
  });

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _getWeekdayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  String _getTimeOfDayName(BuildContext context, TimeOfDay time) {
    if (time.hour >= 5 && time.hour < 12) {
      return context.loc.morning;
    } else if (time.hour >= 12 && time.hour < 17) {
      return context.loc.afternoon;
    } else if (time.hour >= 17 && time.hour < 21) {
      return context.loc.evening;
    } else {
      return context.loc.night;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Date Selector
        Expanded(
          child: ValueListenableBuilder<DateTime>(
            valueListenable: dateNotifier,
            builder: (context, date, _) {
              return _SelectorCard(
                icon: Icons.calendar_today_outlined,
                title: context.loc.date.toUpperCase(),
                primaryText:
                    '${date.day} ${_getMonthName(date.month)} ${date.year}',
                secondaryText: _getWeekdayName(date.weekday),
                onTap: () async {
                  final newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: context.colorScheme.copyWith(
                            primary: context.primaryColor,
                            onPrimary: Colors.white,
                            onSurface: context.textPrimary,
                          ),
                        ),
                        child: child!,
                      );
                    },
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
              return _SelectorCard(
                icon: Icons.access_time_outlined,
                title: context.loc.time.toUpperCase(),
                primaryText: time.format(context),
                secondaryText: _getTimeOfDayName(context, time),
                onTap: () async {
                  final newTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: context.colorScheme.copyWith(
                            primary: context.primaryColor,
                            onPrimary: Colors.white,
                            onSurface: context.textPrimary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (newTime != null) {
                    // Check if selected time is in the past for today
                    final now = DateTime.now();
                    final selectedDate = dateNotifier.value;
                    if (selectedDate.year == now.year &&
                        selectedDate.month == now.month &&
                        selectedDate.day == now.day) {
                      if (newTime.hour < now.hour ||
                          (newTime.hour == now.hour &&
                              newTime.minute < now.minute)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.loc.pleaseSelectFutureTime),
                            ),
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

class _SelectorCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String primaryText;
  final String secondaryText;
  final VoidCallback onTap;

  const _SelectorCard({
    required this.icon,
    required this.title,
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.r16.dynamicH),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
          border: Border.all(color: context.borderColor, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: Dimensions.r16.dynamicH,
                  color: context.textSecondary,
                ),
                SizedBox(width: Dimensions.r8.dynamicW),
                Text(
                  title,
                  style: context.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.r16.dynamicH),
            Text(
              primaryText,
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.r4.dynamicH),
            Text(
              secondaryText,
              style: context.bodySmall?.copyWith(
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
