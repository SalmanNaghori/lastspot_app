import 'package:lastspot_app/core/base_import.dart';

import 'explore_screen_mobile.dart';

class ExploreScreenTablet extends StatelessWidget {
  const ExploreScreenTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 850),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.r24),
          decoration: BoxDecoration(
            color: context.backgroundColor,
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
          child: const ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(Dimensions.r20)),
            child: ExploreScreenMobile(),
          ),
        ),
      ),
    );
  }
}
