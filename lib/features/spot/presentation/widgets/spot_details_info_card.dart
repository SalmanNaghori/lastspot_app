import 'package:lastspot_app/core/base_import.dart';

/// Shared schedule/venue treatment within the activity details view.
class SpotDetailsInfoCard extends StatelessWidget {
  final IconData icon;
  final String? assetPath;
  final String title;
  final String value;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SpotDetailsInfoCard({
    super.key,
    required this.icon,
    this.assetPath,
    required this.title,
    required this.value,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.mdLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(
                  assetPath != null
                      ? Dimensions.r8.dynamicH
                      : AppSpacing.smLg,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: AppRadius.lgBorderRadius,
                ),
                child: assetPath != null
                    ? Image.asset(
                        assetPath!,
                        width: Dimensions.r24.dynamicW,
                        height: Dimensions.r24.dynamicH,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(icon, color: colors.onPrimaryContainer),
                      )
                    : Icon(icon, color: colors.onPrimaryContainer),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(value, style: context.titleMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: context.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.smLg),
            AppButton.text(
              label: actionLabel!,
              icon: Icons.arrow_outward_rounded,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
