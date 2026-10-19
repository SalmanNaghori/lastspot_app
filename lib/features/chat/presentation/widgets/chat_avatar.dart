import '../../../../core/base_import.dart';

/// Reusable chat avatar widget supporting direct user profile photos (with initial fallback)
/// and group 3D category artwork.
class ChatAvatar extends StatelessWidget {
  final bool isDirect;
  final String? avatarUrl;
  final String? displayName;
  final String? category;
  final double size;

  const ChatAvatar({
    super.key,
    required this.isDirect,
    this.avatarUrl,
    this.displayName,
    this.category,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final cleanAvatar = avatarUrl?.trim();
    final hasValidUrl =
        cleanAvatar != null &&
        cleanAvatar.isNotEmpty &&
        (cleanAvatar.startsWith('http://') ||
            cleanAvatar.startsWith('https://'));

    final initial = (displayName?.trim().isNotEmpty == true)
        ? displayName!.trim().characters.first.toUpperCase()
        : (isDirect ? 'U' : '#');

    if (isDirect) {
      if (hasValidUrl) {
        return AppCachedNetworkImage(
          imageUrl: cleanAvatar,
          width: size,
          height: size,
          fit: BoxFit.cover,
          isCircle: true,
          memCacheWidth: (size * 2).round().clamp(1, 512),
          memCacheHeight: (size * 2).round().clamp(1, 512),
          errorWidget: ChatInitialAvatar(initial: initial, size: size),
        );
      }
      return ChatInitialAvatar(initial: initial, size: size);
    }

    // Group chat
    if (hasValidUrl) {
      return AppCachedNetworkImage(
        imageUrl: cleanAvatar,
        width: size,
        height: size,
        fit: BoxFit.cover,
        isCircle: true,
        memCacheWidth: (size * 2).round().clamp(1, 512),
        memCacheHeight: (size * 2).round().clamp(1, 512),
        errorWidget: ChatGroupArtwork(
          category: category ?? displayName,
          size: size,
        ),
      );
    }

    return ChatGroupArtwork(category: category ?? displayName, size: size);
  }
}

class ChatInitialAvatar extends StatelessWidget {
  final String initial;
  final double size;

  const ChatInitialAvatar({
    super.key,
    required this.initial,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.25),
          width: 1.0,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: context.primaryColor,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ChatGroupArtwork extends StatelessWidget {
  final String? category;
  final double size;

  const ChatGroupArtwork({
    super.key,
    required this.category,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(
          color: context.borderColor.withValues(alpha: 0.6),
          width: 1.0,
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: Category3DIcon(category: category, size: size * 0.75),
      ),
    );
  }
}
