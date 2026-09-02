import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../constants/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  const ResponsiveLayout({super.key, required this.mobile, required this.tablet});

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 && MediaQuery.of(context).size.width < 1050;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1050;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 650) {
          // Wrap tablet view in the required tablet container format as per cursorrules
          return Scaffold(
            backgroundColor: context.backgroundColor,
            body: Center(
              child: Container(
                width: 600, // Constrain width for tablet view
                margin: const EdgeInsets.symmetric(vertical: Dimensions.r24),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(Dimensions.r20),
                  border: Border.all(color: AppColor.helpCardBorderColor, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.blackColor.withValues(alpha: 0.04),
                      blurRadius: Dimensions.r20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: tablet,
              ),
            ),
          );
        } else {
          return mobile;
        }
      },
    );
  }
}
