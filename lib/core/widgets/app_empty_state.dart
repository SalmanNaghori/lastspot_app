import '../base_import.dart';

/// App-wide standard empty state component powered by approved KhelBhai 3D artwork.
///
/// Provides factory constructors for all major flows:
/// - [AppEmptyState.activities]: No activities in feed/city/filter
/// - [AppEmptyState.search]: Search yielded zero results
/// - [AppEmptyState.joinRequests]: No sent or received join requests
/// - [AppEmptyState.chats]: No conversations started
/// - [AppEmptyState.notifications]: Notification tray is clear
/// - [AppEmptyState.createdSuccess]: Spot created celebration
class AppEmptyState extends StatelessWidget {
  final AssetGenImage imageGen;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryActionPressed;
  final double? imageSize;

  const AppEmptyState({
    super.key,
    required this.imageGen,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.imageSize,
  });

  AppEmptyState.activities({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.imageSize,
  }) : imageGen = Assets.images.emptyStates.noActivities;

  AppEmptyState.search({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.imageSize,
  }) : imageGen = Assets.images.emptyStates.noSearchResults;

  AppEmptyState.joinRequests({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.imageSize,
  }) : imageGen = Assets.images.emptyStates.noJoinRequests;

  AppEmptyState.chats({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.imageSize,
  }) : imageGen = Assets.images.emptyStates.noChats;

  AppEmptyState.notifications({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.imageSize,
  }) : imageGen = Assets.images.emptyStates.noNotifications;

  AppEmptyState.createdSuccess({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.imageSize,
  }) : imageGen = Assets.images.emptyStates.activityCreatedSuccess;

  @override
  Widget build(BuildContext context) {
    final size =
        imageSize ?? (Dimensions.r96.dynamicH * 1.4).clamp(110.0, 150.0);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.r24.dynamicW,
          vertical: Dimensions.r32.dynamicH,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            imageGen.image(
              width: size,
              height: size,
              fit: BoxFit.contain,
              cacheWidth: 380,
              cacheHeight: 380,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) => Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: context.primaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.inbox_outlined,
                  size: Dimensions.r48.dynamicH,
                  color: context.primaryColor,
                ),
              ),
            ),
            SizedBox(height: Dimensions.r16.dynamicH),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.r18.dynamicSP,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.r8.dynamicH),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.r14.dynamicSP,
                color: context.textSecondary,
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              SizedBox(height: Dimensions.r24.dynamicH),
              AppButton(
                label: actionLabel!,
                onPressed: onActionPressed,
                type: AppButtonType.primary,
                isFullWidth: false,
              ),
            ],
            if (secondaryActionLabel != null &&
                onSecondaryActionPressed != null) ...[
              SizedBox(height: Dimensions.r12.dynamicH),
              AppButton(
                label: secondaryActionLabel!,
                onPressed: onSecondaryActionPressed,
                type: AppButtonType.outline,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Backwards-compatibility aliases
typedef EmptyState = AppEmptyState;
typedef PremiumEmptyState = AppEmptyState;
