import '../base_import.dart';

/// Item descriptor for [LastSpotBottomNavigationBar].
class LastSpotNavItem {
  final String label;
  final AssetGenImage iconGen;
  final IconData fallbackIcon;
  final bool isSpecialAction;

  const LastSpotNavItem({
    required this.label,
    required this.iconGen,
    required this.fallbackIcon,
    this.isSpecialAction = false,
  });
}

/// Premium Fareeq-inspired interactive 3D bottom navigation bar.
///
/// Design Highlights:
/// - Consistent 3D equipment/navigation asset family (House, Compass, Plus Button, Calendar, Speech Bubble).
/// - Floating pill-style white surface with subtle ambient elevation.
/// - 5 destinations: Home, Explore, Create, Activities, Chats.
/// - Smooth animated soft-green pill selection transition (180–220ms).
/// - Subtle 3D icon scale (1.12×) on active selection with reduced-motion respect.
/// - Center prominent green 3D plus coin button for "Create".
/// - Dynamic unread badge for Chats when reported by the backend.
/// - Strict SafeArea bottom handling protecting Android gesture navigation & iOS home bar.
class LastSpotBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final int chatsUnreadCount;

  const LastSpotBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.chatsUnreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final items = [
      LastSpotNavItem(
        label: loc.navHome,
        iconGen: Assets.navigation.home3d,
        fallbackIcon: Icons.home_rounded,
      ),
      LastSpotNavItem(
        label: loc.navExplore,
        iconGen: Assets.navigation.explore3d,
        fallbackIcon: Icons.explore_rounded,
      ),
      LastSpotNavItem(
        label: loc.navCreate,
        iconGen: Assets.navigation.create3d,
        fallbackIcon: Icons.add_rounded,
        isSpecialAction: true,
      ),
      LastSpotNavItem(
        label: loc.navActivities,
        iconGen: Assets.navigation.activities3d,
        fallbackIcon: Icons.sports_soccer_rounded,
      ),
      LastSpotNavItem(
        label: loc.navChats,
        iconGen: Assets.navigation.chats3d,
        fallbackIcon: Icons.chat_bubble_rounded,
      ),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navSurfaceColor = isDark
        ? const Color(0xFF171D2A)
        : context.surfaceColor;
    final navBorderColor = isDark
        ? const Color(0xFF2A3447)
        : context.colorScheme.outlineVariant.withValues(alpha: 0.35);

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final effectiveBottomBuffer = bottomPadding > 0
        ? bottomPadding
        : Dimensions.r8.dynamicH;

    final navBarHeight = (Dimensions.r72.dynamicH + 8).clamp(78.0, 84.0);

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(
        Dimensions.r16.dynamicW,
        0,
        Dimensions.r16.dynamicW,
        effectiveBottomBuffer,
      ),
      child: Container(
        height: navBarHeight,
        decoration: BoxDecoration(
          color: navSurfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r28.dynamicR),
          border: Border.all(color: navBorderColor, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? AppColor.blackColor.withValues(alpha: 0.40)
                  : AppColor.blackColor.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            if (!isDark)
              BoxShadow(
                color: context.primaryColor.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = selectedIndex == index;
            final isChatTab = index == 4;

            return Expanded(
              child: item.isSpecialAction
                  ? LastSpotNavCreateItem(
                      item: item,
                      isSelected: isSelected,
                      onTap: () => onDestinationSelected(index),
                    )
                  : LastSpotNavBarItem(
                      item: item,
                      isSelected: isSelected,
                      badgeCount: isChatTab ? chatsUnreadCount : 0,
                      onTap: () => onDestinationSelected(index),
                    ),
            );
          }),
        ),
      ),
    );
  }
}

/// Standard interactive 3D navigation item widget for [LastSpotBottomNavigationBar].
class LastSpotNavBarItem extends StatelessWidget {
  final LastSpotNavItem item;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const LastSpotNavBarItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = context.primaryColor;
    final inactiveColor = isDark
        ? const Color(0xFF94A3B8)
        : context.textSecondary;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final animDuration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 200);

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Tooltip(
        message: item.label,
        child: InkResponse(
          onTap: onTap,
          highlightShape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
          containedInkWell: true,
          child: AnimatedContainer(
            duration: animDuration,
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.symmetric(
              horizontal: Dimensions.r2.dynamicW,
              vertical: Dimensions.r4.dynamicH,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.r4.dynamicW,
              vertical: Dimensions.r4.dynamicH,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.primaryColor.withValues(alpha: 0.06)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      AnimatedScale(
                        scale: isSelected ? 1.08 : 1.0,
                        duration: animDuration,
                        curve: Curves.easeOutCubic,
                        child: AnimatedOpacity(
                          duration: animDuration,
                          opacity: isSelected ? 1.0 : 0.90,
                          child: SizedBox(
                            width: Dimensions.r32.dynamicW,
                            height: Dimensions.r32.dynamicH,
                            child: item.iconGen.image(
                              width: Dimensions.r32.dynamicW,
                              height: Dimensions.r32.dynamicH,
                              cacheWidth: 128,
                              cacheHeight: 128,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  item.fallbackIcon,
                                  size: Dimensions.r24.dynamicH,
                                  color: isSelected
                                      ? activeColor
                                      : inactiveColor,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      if (badgeCount > 0)
                        Positioned(
                          top: -Dimensions.r2.dynamicH,
                          right: -Dimensions.r6.dynamicW,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.r4.dynamicW,
                              vertical: Dimensions.r2.dynamicH,
                            ),
                            decoration: BoxDecoration(
                              color: context.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.surfaceColor,
                                width: 1.5,
                              ),
                            ),
                            constraints: BoxConstraints(
                              minWidth: Dimensions.r14.dynamicW,
                              minHeight: Dimensions.r14.dynamicH,
                            ),
                            child: Center(
                              child: Text(
                                badgeCount > 9 ? '9+' : '$badgeCount',
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: Dimensions.r8.dynamicSP,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: Dimensions.r2.dynamicH),
                  Text(
                    item.label,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: Dimensions.r11.dynamicSP,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isSelected ? activeColor : inactiveColor,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: Dimensions.r2.dynamicH),
                  AnimatedContainer(
                    duration: animDuration,
                    curve: Curves.easeOutCubic,
                    width: isSelected ? Dimensions.r12.dynamicW : 0,
                    height: Dimensions.r2.dynamicH + 1,
                    decoration: BoxDecoration(
                      color: isSelected ? activeColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        Dimensions.r2.dynamicR,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Elevated prominent center 3D "Create" navigation item for [LastSpotBottomNavigationBar].
class LastSpotNavCreateItem extends StatelessWidget {
  final LastSpotNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const LastSpotNavCreateItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final animDuration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 200);

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Tooltip(
        message: item.label,
        child: InkResponse(
          onTap: onTap,
          highlightShape: BoxShape.circle,
          containedInkWell: false,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.06 : 1.0,
                  duration: animDuration,
                  curve: Curves.easeOutCubic,
                  child: Container(
                    width: Dimensions.r40.dynamicW,
                    height: Dimensions.r40.dynamicH,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.blackColor.withValues(alpha: 0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: item.iconGen.image(
                      width: Dimensions.r40.dynamicW,
                      height: Dimensions.r40.dynamicH,
                      cacheWidth: 256,
                      cacheHeight: 256,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: context.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: AppColor.whiteColor,
                            size: Dimensions.r24.dynamicH,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.r2.dynamicH),
                Text(
                  item.label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: Dimensions.r11.dynamicSP,
                    fontWeight: FontWeight.w800,
                    color: context.primaryColor,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: Dimensions.r2.dynamicH),
                SizedBox(height: Dimensions.r2.dynamicH + 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
