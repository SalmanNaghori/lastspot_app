import '../../../../core/base_import.dart';

/// Single interactive action button for [SportsQuickActions].
class SportsQuickActionItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const SportsQuickActionItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.r12.dynamicW,
            vertical: Dimensions.r10.dynamicH,
          ),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
            border: Border.all(
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: Dimensions.r28.dynamicW,
                height: Dimensions.r28.dynamicH,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.primaryColor.withValues(alpha: 0.12),
                ),
                child: Icon(
                  icon,
                  size: Dimensions.r16.dynamicH,
                  color: context.primaryColor,
                ),
              ),
              SizedBox(width: Dimensions.r6.dynamicW),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: Dimensions.r12.dynamicSP,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
