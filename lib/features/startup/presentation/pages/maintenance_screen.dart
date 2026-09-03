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
      mobile: _buildContent(context),
      tablet: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.r24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.build_circle_outlined,
                size: Dimensions.r64,
                color: AppColor.warningColor,
              ),
              const SizedBox(height: Dimensions.r24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.r24,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.r16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.r16,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
