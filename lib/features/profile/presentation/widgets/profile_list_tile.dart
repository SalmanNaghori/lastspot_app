import 'package:lastspot_app/core/base_import.dart';

class ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimensions.r16.dynamicW,
        vertical: Dimensions.r4.dynamicH,
      ),
      leading: Container(
        width: Dimensions.r36.dynamicW,
        height: Dimensions.r36.dynamicH,
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Dimensions.r10.dynamicR),
        ),
        child: Icon(
          icon,
          size: Dimensions.r20.dynamicH,
          color: context.primaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: Dimensions.r15.dynamicSP,
          fontWeight: FontWeight.w600,
          color: context.textPrimary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: Dimensions.r20.dynamicH,
        color: context.textSecondary,
      ),
      onTap: onTap,
    );
  }
}
