import '../../../../core/base_import.dart';
import '../../../auth/domain/entities/user_profile.dart';

/// Premium compact sports profile header for My Sports Space.
///
/// Features:
/// - Real user profile photo using shared [UserAvatar] with graceful initials fallback.
/// - Full name, verified email with badge, resolved city/state, and bio.
/// - Clean Edit Profile primary action button.
/// - Duplicate settings icon removed per project governance.
class SportsProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEditProfile;

  const SportsProfileHeader({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final fullName = profile.displayName(fallback: loc.navProfile);
    final displayLocation = profile.displayLocation(context);

    return Container(
      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Reusable UserAvatar
              UserAvatar.large(
                imageUrl: profile.avatarUrl,
                name: fullName,
                size: Dimensions.r64.dynamicH,
                showBorder: true,
                borderColor: context.primaryColor,
                borderWidth: 2.0,
              ),
              SizedBox(width: Dimensions.r16.dynamicW),

              // Name, Email, City & State
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: Dimensions.r18.dynamicSP,
                        fontWeight: FontWeight.w800,
                        color: context.textPrimary,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (profile.hasEmail) ...[
                      SizedBox(height: Dimensions.r4.dynamicH),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: Dimensions.r14.dynamicH,
                            color: context.textSecondary,
                          ),
                          SizedBox(width: Dimensions.r4.dynamicW),
                          Expanded(
                            child: Text(
                              profile.cleanEmail,
                              style: TextStyle(
                                fontSize: Dimensions.r12.dynamicSP,
                                fontWeight: FontWeight.w500,
                                color: context.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: Dimensions.r4.dynamicW),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.r6.dynamicW,
                              vertical: Dimensions.r2.dynamicH,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.successColor.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(
                                Dimensions.r6.dynamicR,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  size: Dimensions.r10.dynamicH,
                                  color: AppColor.successColor,
                                ),
                                SizedBox(width: Dimensions.r2.dynamicW),
                                Text(
                                  loc.verifiedEmail,
                                  style: TextStyle(
                                    fontSize: Dimensions.r8.dynamicSP,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.successColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (displayLocation.isNotEmpty) ...[
                      SizedBox(height: Dimensions.r4.dynamicH),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: Dimensions.r14.dynamicH,
                            color: context.primaryColor,
                          ),
                          SizedBox(width: Dimensions.r4.dynamicW),
                          Expanded(
                            child: Text(
                              displayLocation,
                              style: TextStyle(
                                fontSize: Dimensions.r12.dynamicSP,
                                fontWeight: FontWeight.w600,
                                color: context.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Short Bio only when available
          if (profile.hasBio) ...[
            SizedBox(height: Dimensions.r12.dynamicH),
            Text(
              profile.cleanBio,
              style: TextStyle(
                fontSize: Dimensions.r13.dynamicSP,
                color: context.textSecondary,
                height: 1.35,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          SizedBox(height: Dimensions.r14.dynamicH),

          // Edit Profile action
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onEditProfile,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.primaryColor,
                side: BorderSide(
                  color: context.primaryColor.withValues(alpha: 0.5),
                  width: 1.2,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.r10.dynamicH,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                ),
              ),
              icon: Icon(Icons.edit_outlined, size: Dimensions.r16.dynamicH),
              label: Text(
                loc.editProfile,
                style: TextStyle(
                  fontSize: Dimensions.r13.dynamicSP,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
