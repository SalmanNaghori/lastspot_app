import 'package:lastspot_app/core/base_import.dart';

class MaintenanceScreen extends StatelessWidget {
  final String title;
  final String message;

  const MaintenanceScreen({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: MaintenanceContent(title: title, message: message),
      tablet: MaintenanceContent(
        title: title,
        message: message,
        isTablet: true,
      ),
    );
  }
}

class MaintenanceContent extends StatelessWidget {
  final String title;
  final String message;
  final bool isTablet;

  const MaintenanceContent({
    super.key,
    required this.title,
    required this.message,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.r24.dynamicW),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isTablet ? 500 : 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: Dimensions.r80.dynamicW,
                      height: Dimensions.r80.dynamicH,
                      decoration: BoxDecoration(
                        color: context.warningColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.build_circle_outlined,
                        size: Dimensions.r40.dynamicH,
                        color: context.warningColor,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r24.dynamicSP,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.r12.dynamicH),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r15.dynamicSP,
                      color: context.textSecondary,
                      height: 1.4,
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
