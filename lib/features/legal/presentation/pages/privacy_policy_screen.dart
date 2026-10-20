import 'package:lastspot_app/core/base_import.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: KhelBhaiBackButton.leading(context),
        title: Text(context.loc.privacyPolicy),
        backgroundColor: context.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: context.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.r16.dynamicW),
          child: Container(
            padding: EdgeInsets.all(Dimensions.r20.dynamicW),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
              border: Border.all(
                color: context.borderColor.withValues(alpha: 0.6),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Dimensions.r8.dynamicW),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          Dimensions.r10.dynamicR,
                        ),
                      ),
                      child: Icon(
                        Icons.privacy_tip_outlined,
                        size: Dimensions.r20.dynamicH,
                        color: context.primaryColor,
                      ),
                    ),
                    SizedBox(width: Dimensions.r12.dynamicW),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: Dimensions.r20.dynamicSP,
                        fontWeight: FontWeight.w800,
                        color: context.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.r16.dynamicH),
                Text(
                  'Your privacy is important to us. This privacy policy explains what personal data we collect from you, through our interactions with you and through our products, and how we use that data.\n\nWe collect data to operate effectively and provide you the best experiences with our services. You provide some of this data directly, such as when you create an account, administer your organization\'s licensing account, submit a search query, register for an activity, or contact us for support.',
                  style: TextStyle(
                    fontSize: Dimensions.r14.dynamicSP,
                    color: context.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
