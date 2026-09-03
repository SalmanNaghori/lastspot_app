import '../base_import.dart';

/// App-wide loading state widget supporting both branded spinners and shimmer skeletons.
class LoadingState extends StatelessWidget {
  final String? message;

  const LoadingState({super.key, this.message});

  /// Factory preset for a generic shimmering list
  static Widget shimmerList({int count = 4}) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
      itemCount: count,
      separatorBuilder: (_, _) => SizedBox(height: Dimensions.r12.dynamicH),
      itemBuilder: (_, _) => const _ShimmerListItem(),
    );
  }

  /// Factory preset for a generic shimmering card
  static Widget shimmerCard() {
    return Padding(
      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
      child: const _ShimmerCardItem(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColor.primaryColor,
          ),
          if (message != null) ...[
            SizedBox(height: Dimensions.r16.dynamicH),
            Text(
              message!,
              style: TextStyle(
                fontSize: Dimensions.r14.dynamicSP,
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ShimmerListItem extends StatelessWidget {
  const _ShimmerListItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.r12.dynamicW),
      decoration: BoxDecoration(
        color: context.isDarkMode ? context.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          AppShimmerBox(
            width: Dimensions.r48.dynamicW,
            height: Dimensions.r48.dynamicH,
            borderRadius: Dimensions.r12.dynamicR,
          ),
          SizedBox(width: Dimensions.r12.dynamicW),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerBox(
                  width: Dimensions.r64.dynamicW * 2,
                  height: Dimensions.r14.dynamicH,
                  borderRadius: Dimensions.r4.dynamicR,
                ),
                SizedBox(height: Dimensions.r8.dynamicH),
                AppShimmerBox(
                  width: Dimensions.r48.dynamicW * 2,
                  height: Dimensions.r12.dynamicH,
                  borderRadius: Dimensions.r4.dynamicR,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerCardItem extends StatelessWidget {
  const _ShimmerCardItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
      decoration: BoxDecoration(
        color: context.isDarkMode ? context.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmerBox(
            width: double.infinity,
            height: Dimensions.r64.dynamicH * 2.5,
            borderRadius: Dimensions.r16.dynamicR,
          ),
          SizedBox(height: Dimensions.r16.dynamicH),
          AppShimmerBox(
            width: Dimensions.r64.dynamicW * 2.5,
            height: Dimensions.r16.dynamicH,
            borderRadius: Dimensions.r6.dynamicR,
          ),
          SizedBox(height: Dimensions.r8.dynamicH),
          AppShimmerBox(
            width: double.infinity,
            height: Dimensions.r12.dynamicH,
            borderRadius: Dimensions.r4.dynamicR,
          ),
        ],
      ),
    );
  }
}
