import '../base_import.dart';

/// App-wide standard loading state widget supporting branded circular progress indicators
/// and shimmer skeleton layouts.
class AppLoading extends StatelessWidget {
  final String? message;
  final double? size;

  const AppLoading({super.key, this.message, this.size});

  /// Factory preset for shimmering list tiles
  static Widget shimmerList({int count = 4}) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
      itemCount: count,
      separatorBuilder: (_, _) => SizedBox(height: Dimensions.r12.dynamicH),
      itemBuilder: (_, _) => const AppShimmerListItem(),
    );
  }

  /// Factory preset for a single shimmering activity card
  static Widget shimmerCard() {
    return Padding(
      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
      child: const AppShimmerCardItem(),
    );
  }

  /// Factory preset for shimmering feed of activity cards
  static Widget shimmerFeed({int count = 3}) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
      itemCount: count,
      separatorBuilder: (_, _) => SizedBox(height: Dimensions.r16.dynamicH),
      itemBuilder: (_, _) => const AppShimmerCardItem(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size ?? Dimensions.r32.dynamicW,
            height: size ?? Dimensions.r32.dynamicH,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: context.primaryColor,
            ),
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

/// Shimmer list item placeholder
class AppShimmerListItem extends StatelessWidget {
  const AppShimmerListItem({super.key});

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

/// Shimmer activity card placeholder matching [ActivityCard] proportions
class AppShimmerCardItem extends StatelessWidget {
  const AppShimmerCardItem({super.key});

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

/// Backwards-compatibility alias
typedef LoadingState = AppLoading;
