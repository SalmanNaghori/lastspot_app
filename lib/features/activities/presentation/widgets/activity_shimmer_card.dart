import 'package:lastspot_app/core/base_import.dart';

class ActivityShimmerRow extends StatelessWidget {
  const ActivityShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppShimmerBox(
          width: Dimensions.r16.dynamicH,
          height: Dimensions.r16.dynamicH,
        ),
        SizedBox(width: Dimensions.r8.dynamicW),
        Expanded(child: AppShimmerBox(height: Dimensions.r14.dynamicH)),
      ],
    );
  }
}

class ActivityShimmerCard extends StatelessWidget {
  const ActivityShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: AppShimmerBox(height: Dimensions.r20.dynamicH)),
              SizedBox(width: Dimensions.r16.dynamicW),
              AppShimmerBox(
                width: Dimensions.r60.dynamicW,
                height: Dimensions.r24.dynamicH,
                borderRadius: Dimensions.r16.dynamicR,
              ),
            ],
          ),
          SizedBox(height: Dimensions.r16.dynamicH),
          const ActivityShimmerRow(),
          SizedBox(height: Dimensions.r12.dynamicH),
          const ActivityShimmerRow(),
          SizedBox(height: Dimensions.r12.dynamicH),
          const ActivityShimmerRow(),
        ],
      ),
    );
  }
}
