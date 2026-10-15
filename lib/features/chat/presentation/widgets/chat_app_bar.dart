import '../../../../core/base_import.dart';

/// WhatsApp-inspired chat app bar with avatar, title, and context subtitle.
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool isDirect;
  final VoidCallback onBack;
  final VoidCallback? onGroupInfoTap;

  const ChatAppBar({
    super.key,
    required this.title,
    this.subtitle,
    required this.isDirect,
    required this.onBack,
    this.onGroupInfoTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final displayTitle = title.trim().isNotEmpty
        ? title.trim()
        : (isDirect ? context.loc.navProfile : context.loc.groupChat);

    final initial = displayTitle.isNotEmpty
        ? displayTitle.characters.first.toUpperCase()
        : '?';

    final categoryIcon = isDirect
        ? Icons.person
        : AppUtils.getCategoryIcon(displayTitle);

    return AppBar(
      backgroundColor: context.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 1,
      leadingWidth: 40,
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back),
      ),
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
              CircleAvatar(
                radius: 20,
                backgroundColor: isDirect
                    ? colors.primaryContainer
                    : colors.secondaryContainer,
                child: isDirect
                    ? Text(
                        initial,
                        style: context.titleMedium?.copyWith(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Icon(
                        categoryIcon,
                        size: 20,
                        color: colors.onSecondaryContainer,
                      ),
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
                    if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                      Text(
                        subtitle!.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontSize: 11,
                        ),
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
