import '../../../../core/base_import.dart';

/// Informational, deterministic welcome banner displayed at the beginning of an
/// activity group chat. Presentation-only; never saved to database.
class ChatWelcomeBanner extends StatelessWidget {
  final String activityTitle;

  const ChatWelcomeBanner({super.key, required this.activityTitle});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final loc = context.loc;
    final cleanTitle = activityTitle.trim().isNotEmpty
        ? activityTitle.trim()
        : loc.groupChat;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.r20.dynamicW,
        vertical: Dimensions.r16.dynamicH,
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.88,
          ),
          padding: EdgeInsets.all(Dimensions.r16.dynamicW),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.25),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Category3DIcon(
                category: cleanTitle,
                size: Dimensions.r40.dynamicH,
              ),
              SizedBox(height: Dimensions.r8.dynamicH),
              Text(
                loc.welcomeToActivity(cleanTitle, '').trim(),
                textAlign: TextAlign.center,
                style: context.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              SizedBox(height: Dimensions.r6.dynamicH),
              Text(
                loc.groupWelcomeSubtitle,
                textAlign: TextAlign.center,
                style: context.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              SizedBox(height: Dimensions.r10.dynamicH),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: Dimensions.r12.dynamicH,
                    color: colors.primary,
                  ),
                  SizedBox(width: Dimensions.r4.dynamicW),
                  Flexible(
                    child: Text(
                      loc.groupOnlyParticipantsCanChat,
                      textAlign: TextAlign.center,
                      style: context.labelSmall?.copyWith(
                        color: colors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
