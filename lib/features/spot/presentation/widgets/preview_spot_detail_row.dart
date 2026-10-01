import 'package:lastspot_app/core/base_import.dart';

class PreviewSpotDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const PreviewSpotDetailRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Icon(
          icon,
          color: iconColor ?? context.textSecondary,
          size: Dimensions.r20.dynamicW,
        ),
        SizedBox(width: Dimensions.r12.dynamicW),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: Dimensions.r14.dynamicSP,
              color: textColor ?? context.textPrimary,
              fontWeight: textColor != null
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.r4.dynamicH),
          child: row,
        ),
      );
    }

    return row;
  }
}
