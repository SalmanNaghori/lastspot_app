import '../base_import.dart';

/// App-wide standard user and group avatar widget.
///
/// Features:
/// - Displays network profile avatar with memory caching and fallback.
/// - Calculates clean initials from user's full name via [AppUtils.computeInitials].
/// - Displays 3D category equipment icon for group chats when [category] or [isGroup] is set.
/// - Supports customizable border, background tint, size, and optional [onTap] handler.
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? category;
  final bool isGroup;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final String? tooltip;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.category,
    this.isGroup = false,
    this.size = 40.0,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 1.5,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.tooltip,
  });

  const UserAvatar.large({
    super.key,
    this.imageUrl,
    this.name,
    this.category,
    this.isGroup = false,
    this.size = 64.0,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 2.0,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.tooltip,
  });

  const UserAvatar.small({
    super.key,
    this.imageUrl,
    this.name,
    this.category,
    this.isGroup = false,
    this.size = 28.0,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 1.0,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final cleanUrl = imageUrl?.trim();
    final hasValidUrl =
        cleanUrl != null &&
        cleanUrl.isNotEmpty &&
        (cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://'));

    final effectiveBorderColor = borderColor ?? context.primaryColor;
    final effectiveBg =
        backgroundColor ?? context.primaryColor.withValues(alpha: 0.12);
    final effectiveTextColor = textColor ?? context.primaryColor;

    Widget avatarContent;

    if (isGroup && (cleanUrl == null || cleanUrl.isEmpty)) {
      avatarContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.primaryContainer,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(size * 0.15),
        child: Category3DIcon(category: category ?? name, size: size * 0.7),
      );
    } else if (hasValidUrl) {
      avatarContent = AppNetworkImage(
        imageUrl: cleanUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        isCircle: true,
        memCacheWidth: (size * 2).round().clamp(1, 512),
        memCacheHeight: (size * 2).round().clamp(1, 512),
        errorWidget: _buildInitialsFallback(effectiveBg, effectiveTextColor),
        placeholder: _buildInitialsFallback(effectiveBg, effectiveTextColor),
      );
    } else {
      avatarContent = _buildInitialsFallback(effectiveBg, effectiveTextColor);
    }

    if (showBorder) {
      avatarContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: effectiveBorderColor, width: borderWidth),
        ),
        padding: EdgeInsets.all(borderWidth * 0.75),
        child: ClipOval(child: avatarContent),
      );
    }

    if (onTap != null) {
      avatarContent = InkResponse(
        onTap: onTap,
        radius: size * 0.6,
        highlightShape: BoxShape.circle,
        containedInkWell: true,
        child: avatarContent,
      );
    }

    if (tooltip != null && tooltip!.isNotEmpty) {
      return Tooltip(message: tooltip!, child: avatarContent);
    }

    return avatarContent;
  }

  Widget _buildInitialsFallback(Color bgColor, Color txtColor) {
    final initials = AppUtils.computeInitials(
      name,
      fallback: isGroup ? '#' : '?',
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: txtColor,
          fontSize: (size * 0.38).clamp(10.0, 26.0),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
