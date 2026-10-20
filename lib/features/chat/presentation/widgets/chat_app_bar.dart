import '../../../../core/base_import.dart';
import 'chat_avatar.dart';

/// WhatsApp-inspired chat app bar with avatar, title, and context subtitle.
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool isDirect;
  final String? avatarUrl;
  final String? category;
  final VoidCallback onBack;
  final VoidCallback? onGroupInfoTap;

  const ChatAppBar({
    super.key,
    required this.title,
    this.subtitle,
    required this.isDirect,
    this.avatarUrl,
    this.category,
    required this.onBack,
    this.onGroupInfoTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final displayTitle = title.trim().isNotNullOrEmpty()
        ? title.trim()
        : (isDirect ? context.loc.navProfile : context.loc.groupChat);

    return AppBar(
      backgroundColor: context.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 1,
      leadingWidth: kToolbarHeight,
      leading: KhelBhaiBackButton(onPressed: onBack),
      titleSpacing: 0,
      title: InkWell(
        onTap: isDirect ? null : onGroupInfoTap,
        borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.r4.dynamicH,
            horizontal: Dimensions.r4.dynamicW,
          ),
          child: Row(
            children: [
              ChatAvatar(
                isDirect: isDirect,
                avatarUrl: avatarUrl,
                displayName: displayTitle,
                category: category ?? subtitle ?? displayTitle,
                size: 40,
              ),
              const SizedBox(width: AppSpacing.smLg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle?.trim().isNotNullOrEmpty() == true) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isDirect) ...[
                            Icon(
                              Icons.sports_soccer_outlined,
                              size: Dimensions.r12.dynamicH,
                              color: context.primaryColor,
                            ),
                            SizedBox(width: Dimensions.r4.dynamicW),
                          ],
                          Flexible(
                            child: Text(
                              subtitle!.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.labelSmall?.copyWith(
                                color: isDirect
                                    ? context.primaryColor
                                    : colors.onSurfaceVariant,
                                fontWeight: isDirect
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 11,
                              ),
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
        ),
      ),
      actions: [
        if (!isDirect && onGroupInfoTap != null)
          IconButton(
            tooltip: context.loc.groupInfoTitle,
            icon: const Icon(Icons.info_outline),
            onPressed: onGroupInfoTap,
          ),
        const SizedBox(width: AppSpacing.xs),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Divider(
          height: 0.5,
          thickness: 0.5,
          color: colors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
