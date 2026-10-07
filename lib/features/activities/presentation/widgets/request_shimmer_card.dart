import 'package:lastspot_app/core/base_import.dart';

class RequestShimmerCard extends StatelessWidget {
  const RequestShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
        side: BorderSide(color: context.dividerColor, width: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.r16.dynamicW),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppShimmerBox(
                  width: Dimensions.rad40,
                  height: Dimensions.rad40,
                  isCircle: true,
                ),
                SizedBox(width: Dimensions.r12.dynamicW),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerBox(
                        height: Dimensions.r16.dynamicH,
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      AppShimmerBox(
                        width: Dimensions.r60.dynamicW,
                        height: Dimensions.r12.dynamicH,
                      ),
                    ],
                  ),
                ),
                AppShimmerBox(
                  width: Dimensions.r60.dynamicW,
                  height: Dimensions.r14.dynamicH,
                ),
              ],
            ),
            SizedBox(height: Dimensions.r16.dynamicH),
            Row(
              children: [
                Expanded(
                  child: AppShimmerBox(
                    height: Dimensions.r32.dynamicH,
                    borderRadius: Dimensions.r20.dynamicR,
                  ),
                ),
                SizedBox(width: Dimensions.r12.dynamicW),
                Expanded(
                  child: AppShimmerBox(
                    height: Dimensions.r32.dynamicH,
                    borderRadius: Dimensions.r20.dynamicR,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
