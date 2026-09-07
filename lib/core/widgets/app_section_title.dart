import 'package:lastspot_app/core/base_import.dart';

class AppSectionTitle extends StatelessWidget {
  final String title;

  const AppSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.r12.dynamicH),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Dimensions.r16.dynamicSP,
          fontWeight: FontWeight.w600,
          color: context.textPrimary,
        ),
      ),
    );
  }
}
