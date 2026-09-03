import 'package:lastspot_app/core/base_import.dart';

class HomeGreetingBanner extends StatelessWidget {
  final String? userName;

  const HomeGreetingBanner({super.key, this.userName});

  String _greeting(BuildContext context) {
    final loc = context.loc;
    final hour = DateTime.now().hour;
    if (hour < 12) return loc.goodMorning;
    if (hour < 17) return loc.goodAfternoon;
    return loc.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final firstName = userName?.split(' ').firstOrNull ?? 'Player';

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.r16.dynamicW,
        vertical: Dimensions.r8.dynamicH,
      ),
      height: Dimensions.r64.dynamicH * 1.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
        gradient: LinearGradient(
          colors: [
            AppColor.primaryColor.withValues(alpha: 0.85),
            AppColor.primaryColor.withValues(alpha: 0.6),
            AppColor.primaryContainerLight.withValues(alpha: 0.4),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative background circle
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: Dimensions.r64.dynamicW * 2.0,
              height: Dimensions.r64.dynamicH * 2.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.whiteColor.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: -30,
            child: Container(
              width: Dimensions.r48.dynamicW * 1.8,
              height: Dimensions.r48.dynamicH * 1.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.whiteColor.withValues(alpha: 0.06),
              ),
            ),
          ),
          // Sport silhouette icons (decorative)
          Positioned(
            right: Dimensions.r16.dynamicW,
            top: 0,
            bottom: 0,
            child: _SportSilhouettes(),
          ),
          // Text content
          Padding(
            padding: EdgeInsets.all(Dimensions.r20.dynamicW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _greeting(context),
                  style: TextStyle(
                    color: AppColor.whiteColor.withValues(alpha: 0.9),
                    fontSize: Dimensions.r14.dynamicSP,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: Dimensions.r4.dynamicH),
                Row(
                  children: [
                    Text(
                      firstName,
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: Dimensions.r22.dynamicSP,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(width: Dimensions.r8.dynamicW),
                    Text(
                      '👋',
                      style: TextStyle(fontSize: Dimensions.r22.dynamicSP),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.r4.dynamicH),
                Text(
                  loc.whatAreYouUpTo,
                  style: TextStyle(
                    color: AppColor.whiteColor.withValues(alpha: 0.85),
                    fontSize: Dimensions.r13.dynamicSP,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SportSilhouettes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.r64.dynamicW * 1.7,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soccer ball decoration
          Positioned(
            bottom: 20,
            left: 0,
            child: Container(
              width: Dimensions.r18.dynamicW,
              height: Dimensions.r18.dynamicW,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.whiteColor.withValues(alpha: 0.25),
              ),
            ),
          ),
          // Running person silhouette (right)
          Positioned(
            right: 0,
            bottom: 8,
            child: Icon(
              Icons.directions_run,
              size: Dimensions.r32.dynamicH * 1.75,
              color: AppColor.whiteColor.withValues(alpha: 0.3),
            ),
          ),
          // Sports person silhouette (left, slightly behind)
          Positioned(
            right: Dimensions.r20.dynamicW * 1.8,
            bottom: 10,
            child: Icon(
              Icons.sports_soccer,
              size: Dimensions.r24.dynamicH * 1.8,
              color: AppColor.whiteColor.withValues(alpha: 0.2),
            ),
          ),
          // Small sun decoration
          Positioned(
            top: 14,
            left: 20,
            child: Container(
              width: Dimensions.r14.dynamicW,
              height: Dimensions.r14.dynamicW,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFBBF24).withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
