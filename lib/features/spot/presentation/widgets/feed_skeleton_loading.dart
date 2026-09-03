import '../../../../core/base_import.dart';

/// Skeleton shimmer loading state for the home feed screen.
/// Matches the proportions and structure of [HomeSpotCard].
class FeedSkeletonLoading extends StatelessWidget {
  final int count;

  const FeedSkeletonLoading({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
      itemCount: count,
      separatorBuilder: (_, _) => SizedBox(height: Dimensions.r16.dynamicH),
      itemBuilder: (context, index) => const _SpotCardSkeleton(),
    );
  }
}

class _SpotCardSkeleton extends StatelessWidget {
  const _SpotCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final cardBg = isDark ? context.surfaceColor : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image placeholder
          AppShimmerBox(
            width: double.infinity,
            height: Dimensions.r64.dynamicH * 2.8,
            borderRadius: Dimensions.r20.dynamicR,
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.r16.dynamicW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & spots badge row
                Row(
                  children: [
                    AppShimmerBox(
                      width: Dimensions.r64.dynamicW * 1.2,
                      height: Dimensions.r20.dynamicH,
                      borderRadius: Dimensions.r12.dynamicR,
                    ),
                    const Spacer(),
                    AppShimmerBox(
                      width: Dimensions.r48.dynamicW * 1.2,
                      height: Dimensions.r20.dynamicH,
                      borderRadius: Dimensions.r12.dynamicR,
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.r12.dynamicH),

                // Title bar placeholder
                AppShimmerBox(
                  width: double.infinity,
                  height: Dimensions.r16.dynamicH,
                  borderRadius: Dimensions.r6.dynamicR,
                ),
                SizedBox(height: Dimensions.r8.dynamicH),

                // Subtitle / Location placeholder
                AppShimmerBox(
                  width: Dimensions.r64.dynamicW * 2.5,
                  height: Dimensions.r12.dynamicH,
                  borderRadius: Dimensions.r6.dynamicR,
                ),
                SizedBox(height: Dimensions.r16.dynamicH),

                // Host avatar and time placeholder
                Row(
                  children: [
                    AppShimmerBox(
                      width: Dimensions.r32.dynamicW,
                      height: Dimensions.r32.dynamicH,
                      isCircle: true,
                    ),
                    SizedBox(width: Dimensions.r10.dynamicW),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppShimmerBox(
                          width: Dimensions.r64.dynamicW * 1.3,
                          height: Dimensions.r12.dynamicH,
                          borderRadius: Dimensions.r4.dynamicR,
                        ),
                        SizedBox(height: Dimensions.r4.dynamicH),
                        AppShimmerBox(
                          width: Dimensions.r48.dynamicW * 1.4,
                          height: Dimensions.r10.dynamicH,
                          borderRadius: Dimensions.r4.dynamicR,
                        ),
                      ],
                    ),
                    const Spacer(),
                    AppShimmerBox(
                      width: Dimensions.r64.dynamicW * 1.4,
                      height: Dimensions.r32.dynamicH,
                      borderRadius: Dimensions.r16.dynamicR,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
