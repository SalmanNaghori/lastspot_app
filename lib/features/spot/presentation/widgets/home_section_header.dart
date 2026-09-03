import 'package:lastspot_app/core/base_import.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? viewAllLabel;
  final VoidCallback? onViewAll;
  final Widget? leadingIcon;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.viewAllLabel,
    this.onViewAll,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                SizedBox(width: Dimensions.r8.dynamicW),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.r18.dynamicSP,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (viewAllLabel != null && onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        viewAllLabel!,
                        style: TextStyle(
                          fontSize: Dimensions.r13.dynamicSP,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      SizedBox(width: Dimensions.r2.dynamicW),
                      Icon(
                        Icons.chevron_right,
                        size: Dimensions.r16.dynamicH,
                        color: AppColor.primaryColor,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: Dimensions.r2.dynamicH),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: Dimensions.r13.dynamicSP,
                color: context.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
