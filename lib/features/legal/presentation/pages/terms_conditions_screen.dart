import 'package:lastspot_app/core/base_import.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(context.loc.termsConditions),
        backgroundColor: context.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.r16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: context.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Dimensions.r16),
            Text(
              'Welcome to LastSpot! These terms and conditions outline the rules and regulations for the use of LastSpot\'s App.\n\nBy accessing this app we assume you accept these terms and conditions. Do not continue to use LastSpot if you do not agree to take all of the terms and conditions stated on this page.\n\nThe following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: "Client", "You" and "Your" refers to you, the person log on this app and compliant to the Company\'s terms and conditions.',
              style: context.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
