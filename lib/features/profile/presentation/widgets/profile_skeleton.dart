import 'package:lastspot_app/core/base_import.dart';

/// Shimmer skeleton loading state for the user profile screen.
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimensions.r24.dynamicH),

        // Avatar
        AppShimmerBox(
          width: Dimensions.r48.dynamicW * 2,
          height: Dimensions.r48.dynamicH * 2,
          isCircle: true,
        ),
        SizedBox(height: Dimensions.r16.dynamicH),

        // Name
        AppShimmerBox(
          width: Dimensions.r64.dynamicW * 2.5,
          height: Dimensions.r24.dynamicH,
          borderRadius: Dimensions.r6.dynamicR,
        ),
        SizedBox(height: Dimensions.r8.dynamicH),

        // Handle / Email
        AppShimmerBox(
          width: Dimensions.r64.dynamicW * 1.6,
          height: Dimensions.r16.dynamicH,
          borderRadius: Dimensions.r4.dynamicR,
        ),
        SizedBox(height: Dimensions.r16.dynamicH),

        // Bio
        AppShimmerBox(
          width: Dimensions.r64.dynamicW * 3.2,
          height: Dimensions.r14.dynamicH,
          borderRadius: Dimensions.r4.dynamicR,
        ),
        SizedBox(height: Dimensions.r24.dynamicH),

        // Edit Profile Button
        AppShimmerBox(
          width: Dimensions.r64.dynamicW * 2,
          height: Dimensions.h(36),
          borderRadius: Dimensions.r18.dynamicR,
        ),
        SizedBox(height: Dimensions.r32.dynamicH),

        // Statistics Card
        AppShimmerBox(
          width: double.infinity,
          height: Dimensions.h(80),
          borderRadius: Dimensions.r16.dynamicR,
        ),
        SizedBox(height: Dimensions.r32.dynamicH),

        // Menu items
        AppShimmerBox(
          width: double.infinity,
          height: Dimensions.h(60),
          borderRadius: Dimensions.r12.dynamicR,
        ),
        SizedBox(height: Dimensions.r16.dynamicH),
        AppShimmerBox(
          width: double.infinity,
          height: Dimensions.h(60),
          borderRadius: Dimensions.r12.dynamicR,
        ),
      ],
    );
  }
}
