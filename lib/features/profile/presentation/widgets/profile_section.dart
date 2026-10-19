import 'package:lastspot_app/core/base_import.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const ProfileSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.r8.dynamicW,
            vertical: Dimensions.r8.dynamicH,
          ),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: Dimensions.r12.dynamicSP,
              color: context.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Material(
          color: context.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
            side: BorderSide(color: context.borderColor.withValues(alpha: 0.6)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: items),
        ),
        SizedBox(height: Dimensions.r24.dynamicH),
      ],
    );
  }
}
