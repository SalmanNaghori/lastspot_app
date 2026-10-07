import 'package:lastspot_app/core/base_import.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const ProfileSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.r8,
            vertical: Dimensions.r8,
          ),
          child: Text(
            title.toUpperCase(),
            style: context.labelMedium?.copyWith(
              color: context.isDarkMode ? AppColor.whiteColor : AppColor.textSecondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Material(
          color: context.isDarkMode ? AppColor.surfaceContainerDark : AppColor.surfaceContainerLight,
          borderRadius: BorderRadius.circular(Dimensions.r12),
          clipBehavior: Clip.antiAlias,
          child: Column(children: items),
        ),
        const SizedBox(height: Dimensions.r24),
      ],
    );
  }
}
