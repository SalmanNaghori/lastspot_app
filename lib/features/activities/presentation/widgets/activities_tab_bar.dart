import 'package:lastspot_app/core/base_import.dart';

class ActivitiesTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final String tab1Label;
  final String tab2Label;
  final String tab3Label;

  const ActivitiesTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.tab1Label,
    required this.tab2Label,
    required this.tab3Label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0.dynamicH,
      padding: EdgeInsets.all(Dimensions.r4.dynamicW),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
      ),
      child: Row(
        children: [
          _buildTab(context, 0, tab1Label),
          _buildTab(context, 1, tab2Label),
          _buildTab(context, 2, tab3Label),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, String label) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? context.surfaceColor : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColor.blackColor.withValues(alpha: 0.04),
                      blurRadius: Dimensions.r4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: context.labelLarge?.copyWith(
              color: isSelected ? context.textPrimary : context.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
