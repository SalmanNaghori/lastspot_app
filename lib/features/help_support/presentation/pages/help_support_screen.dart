import 'package:lastspot_app/core/base_import.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: KhelBhaiBackButton.leading(context),
        title: Text(context.loc.helpSupport),
        backgroundColor: context.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: context.textPrimary),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.r24.dynamicW),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: Dimensions.r80.dynamicW,
                      height: Dimensions.r80.dynamicH,
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.support_agent_rounded,
                        size: Dimensions.r40.dynamicH,
                        color: context.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),
                  Text(
                    'Help & Support Center',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r24.dynamicSP,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  Text(
                    'Have questions, feedback, or need assistance with your activities?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r15.dynamicSP,
                      color: context.textSecondary,
                    ),
                  ),
                  SizedBox(height: Dimensions.r32.dynamicH),
                  Container(
                    padding: EdgeInsets.all(Dimensions.r20.dynamicW),
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(
                        Dimensions.r20.dynamicR,
                      ),
                      border: Border.all(
                        color: context.borderColor.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(Dimensions.r10.dynamicW),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.r12.dynamicR,
                                ),
                              ),
                              child: Icon(
                                Icons.email_outlined,
                                size: Dimensions.r22.dynamicH,
                                color: context.primaryColor,
                              ),
                            ),
                            SizedBox(width: Dimensions.r16.dynamicW),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email Support',
                                    style: TextStyle(
                                      fontSize: Dimensions.r15.dynamicSP,
                                      fontWeight: FontWeight.w700,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.r2.dynamicH),
                                  Text(
                                    AppConstants.contactEmail,
                                    style: TextStyle(
                                      fontSize: Dimensions.r13.dynamicSP,
                                      color: context.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.r32.dynamicH),
                  SizedBox(
                    height: Dimensions.r56.dynamicH,
                    child: FilledButton.icon(
                      onPressed: () {
                        AppUtils.showSnackBar(
                          context,
                          'Opening support email...',
                        );
                      },
                      icon: const Icon(Icons.mail_outline_rounded),
                      label: const Text('Contact Support Team'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
