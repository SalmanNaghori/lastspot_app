import '../../base_import.dart';

/// App-wide standard date and time selection field with Material 3 styling
/// and localized pickers.
class AppDateTimeField extends StatelessWidget {
  final String label;
  final String valueText;
  final String? subText;
  final IconData icon;
  final VoidCallback onTap;
  final String? errorText;
  final bool enabled;

  const AppDateTimeField({
    super.key,
    required this.label,
    required this.valueText,
    required this.icon,
    required this.onTap,
    this.subText,
    this.errorText,
    this.enabled = true,
  });

  /// Standard Material 3 Date Picker with branded primary color theme
  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? now,
      lastDate: lastDate ?? now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: context.colorScheme.copyWith(
              primary: context.primaryColor,
              onPrimary: AppColor.whiteColor,
              onSurface: context.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// Standard Material 3 Time Picker with branded primary color theme
  static Future<TimeOfDay?> pickTime(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: context.colorScheme.copyWith(
              primary: context.primaryColor,
              onPrimary: AppColor.whiteColor,
              onSurface: context.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.r16.dynamicW,
              vertical: Dimensions.r14.dynamicH,
            ),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? context.surfaceColor
                  : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
              border: Border.all(
                color: errorText != null
                    ? context.errorColor
                    : context.borderColor.withValues(alpha: 0.7),
                width: errorText != null ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.r8.dynamicW),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      Dimensions.r10.dynamicR,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: Dimensions.r20.dynamicH,
                    color: context.primaryColor,
                  ),
                ),
                SizedBox(width: Dimensions.r12.dynamicW),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: TextStyle(
                          fontSize: Dimensions.r10.dynamicSP,
                          fontWeight: FontWeight.w600,
                          color: context.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: Dimensions.r2.dynamicH),
                      Text(
                        valueText,
                        style: TextStyle(
                          fontSize: Dimensions.r15.dynamicSP,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                        ),
                      ),
                      if (subText != null && subText!.isNotEmpty) ...[
                        SizedBox(height: Dimensions.r2.dynamicH),
                        Text(
                          subText!,
                          style: TextStyle(
                            fontSize: Dimensions.r11.dynamicSP,
                            color: context.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: context.textSecondary,
                  size: Dimensions.r24.dynamicH,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: Dimensions.r4.dynamicH),
          Padding(
            padding: EdgeInsets.only(left: Dimensions.r8.dynamicW),
            child: Text(
              errorText!,
              style: TextStyle(
                fontSize: Dimensions.r12.dynamicSP,
                color: context.errorColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
