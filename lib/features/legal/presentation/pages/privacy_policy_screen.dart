import 'package:lastspot_app/core/base_import.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(context.loc.privacyPolicy),
        backgroundColor: context.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.r16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: context.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Dimensions.r16),
            Text(
              'Your privacy is important to us. This privacy policy explains what personal data we collect from you, through our interactions with you and through our products, and how we use that data.\n\nWe collect data to operate effectively and provide you the best experiences with our services. You provide some of this data directly, such as when you create an account, administer your organization\'s licensing account, submit a search query to Bing, register for an event, speak a voice command to Cortana, upload a document to OneDrive, purchase an MSDN subscription, sign up for Office 365, or contact us for support.',
              style: context.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
