import 'package:lastspot_app/core/base_import.dart';
import '../bloc/achievements_cubit.dart';
import '../bloc/achievements_state.dart';
import 'achievement_card.dart';

/// Horizontally scrollable carousel showing the user's sports achievements and milestones.
class AchievementsCarousel extends StatelessWidget {
  const AchievementsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AchievementsCubit, AchievementsState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is AchievementsLoading || state is AchievementsInitial) {
          return const _AchievementsShimmer();
        }

        if (state is AchievementsLoaded) {
          if (state.achievements.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.r16.dynamicW,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Dimensions.r6.dynamicH),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.military_tech_rounded,
                        size: Dimensions.r18.dynamicH,
                        color: context.primaryColor,
                      ),
                    ),
                    SizedBox(width: Dimensions.r8.dynamicW),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.loc.achievementsSectionTitle,
                            style: context.titleMedium?.copyWith(
                              color: context.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            context.loc.achievementsSectionSubtitle,
                            style: context.bodySmall?.copyWith(
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.r12.dynamicH),

              // Carousel
              SizedBox(
                height: Dimensions.r200.dynamicH,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r16.dynamicW,
                  ),
                  itemCount: state.achievements.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: Dimensions.r12.dynamicW),
                  itemBuilder: (context, index) {
                    final achievement = state.achievements[index];
                    return AchievementCard(achievement: achievement);
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _AchievementsShimmer extends StatelessWidget {
  const _AchievementsShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
          child: AppShimmer(
            child: Container(
              width: Dimensions.r160.dynamicW,
              height: Dimensions.r20.dynamicH,
              decoration: BoxDecoration(
                color: context.surfaceContainerLow,
                borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
              ),
            ),
          ),
        ),
        SizedBox(height: Dimensions.r12.dynamicH),
        SizedBox(
          height: Dimensions.r200.dynamicH,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
            itemCount: 3,
            separatorBuilder: (context, index) =>
                SizedBox(width: Dimensions.r12.dynamicW),
            itemBuilder: (context, index) => AppShimmer(
              child: Container(
                width: Dimensions.r160.dynamicW,
                decoration: BoxDecoration(
                  color: context.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
