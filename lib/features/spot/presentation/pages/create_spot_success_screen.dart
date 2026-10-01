import 'package:lastspot_app/core/base_import.dart';

class CreateSpotSuccessScreen extends StatelessWidget {
  final String? requestId;

  const CreateSpotSuccessScreen({super.key, this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.r24.dynamicW),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Icon(
                Icons.check_circle_outline,
                color: context.primaryColor,
                size: Dimensions.r48.dynamicH,
              ),
              SizedBox(height: Dimensions.r24.dynamicH),
              Text(
                'Activity Created!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.r24.dynamicSP,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.r8.dynamicH),
              Text(
                'Your activity is now live. People can start requesting to join.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.r14.dynamicSP,
                  color: context.textSecondary,
                ),
              ),
              Spacer(),
              if (requestId != null)
                AppButton(
                  label: 'View Activity',
                  onPressed: () {
                    context.go('/activity/$requestId');
                  },
                ),
              if (requestId != null) SizedBox(height: Dimensions.r16.dynamicH),
              AppButton(
                label: 'Back to Home',
                onPressed: () {
                  context.go('/home');
                },
                type: AppButtonType.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
