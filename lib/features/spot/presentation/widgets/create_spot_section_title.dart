import 'package:lastspot_app/core/base_import.dart';

class CreateSpotSectionTitle extends StatelessWidget {
  final String title;

  const CreateSpotSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
