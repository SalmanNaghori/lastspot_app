import 'package:lastspot_app/core/base_import.dart';

class SpotDetailsMapPlaceholder extends StatelessWidget {
  final VoidCallback onMap;
  final String locationName;

  const SpotDetailsMapPlaceholder({super.key, required this.onMap, required this.locationName});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Container(
      height: Dimensions.h140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.lgBorderRadius,
        border: Border.all(color: context.borderColor),
        image: const DecorationImage(
          image: NetworkImage(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSq7d6u6l3U8uHXYl9vP9rOQ2xQo5FjM_k3&s',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.lgBorderRadius,
          color: context.primaryColor.withValues(alpha: 0.15),
        ),
        child: Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: onMap,
            borderRadius: AppRadius.pillBorderRadius,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mdLg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(color: context.primaryColor, borderRadius: AppRadius.pillBorderRadius),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, size: Dimensions.h16, color: context.colorScheme.onPrimary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    loc.viewOnMap,
                    style: context.bodySmall?.copyWith(
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
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
