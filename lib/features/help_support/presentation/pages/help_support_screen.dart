import 'package:lastspot_app/core/base_import.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(context.loc.helpSupport),
        backgroundColor: context.backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help_outline, size: 64, color: context.primaryColor),
            const SizedBox(height: Dimensions.r16),
            Text(
              'Help & Support Center',
              style: context.titleLarge,
            ),
            const SizedBox(height: Dimensions.r8),
            Text(
              'Contact us at support@lastspot.com',
              style: context.bodyMedium?.copyWith(color: context.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
