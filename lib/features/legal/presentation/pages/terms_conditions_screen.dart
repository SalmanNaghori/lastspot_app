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
                        Icons.article_outlined,
                        size: Dimensions.r20.dynamicH,
                        color: context.primaryColor,
                      ),
                    ),
                    SizedBox(width: Dimensions.r12.dynamicW),
                    Text(
                      'Terms & Conditions',
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
                  'Welcome to ${AppString.appName}! These terms and conditions outline the rules and regulations for the use of ${AppString.appName}\'s community platform.\n\nBy accessing this app we assume you accept these terms and conditions. Do not continue to use ${AppString.appName} if you do not agree to take all of the terms and conditions stated on this page.\n\nAll users agree to treat other players and activity hosts with courtesy and respect during all matches and community events.',
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
