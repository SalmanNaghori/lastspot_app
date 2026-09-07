import 'package:lastspot_app/core/base_import.dart';

class SportGradientBackground extends StatelessWidget {
  final String categoryId;

  const SportGradientBackground({super.key, required this.categoryId});

  (Color, Color, IconData) get _style {
    switch (categoryId.toLowerCase()) {
      case 'cricket':
        return (CategoryColors.cricketDark, CategoryColors.cricketLight, Icons.sports_cricket);
      case 'football':
        return (CategoryColors.footballDark, CategoryColors.footballLight, Icons.sports_soccer);
      case 'basketball':
        return (CategoryColors.basketballDark, CategoryColors.basketballLight, Icons.sports_basketball);
      case 'tennis':
        return (CategoryColors.tennisDark, CategoryColors.tennisLight, Icons.sports_tennis);
      case 'badminton':
        return (CategoryColors.badmintonDark, CategoryColors.badmintonLight, Icons.sports_tennis);
      default:
        return (CategoryColors.defaultDark, CategoryColors.defaultLight, Icons.sports);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (darkColor, lightColor, icon) = _style;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [darkColor, lightColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Center(
        child: Icon(icon, size: Dimensions.r64.dynamicH * 1.25, color: AppColor.whiteColor.withValues(alpha: 0.12)),
      ),
    );
  }
}
