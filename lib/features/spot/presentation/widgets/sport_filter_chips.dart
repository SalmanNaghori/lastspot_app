import 'package:lastspot_app/core/base_import.dart';

class SportFilterChips extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const SportFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<_SportFilter> _sports = [
    _SportFilter('Cricket', Icons.sports_cricket),
    _SportFilter('Football', Icons.sports_soccer),
    _SportFilter('Badminton', Icons.sports_tennis),
    _SportFilter('Tennis', Icons.sports_tennis),
    _SportFilter('Basketball', Icons.sports_basketball),
    _SportFilter('Running', Icons.directions_run),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.r24.dynamicH * 1.67,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
        itemCount: _sports.length,
        separatorBuilder: (_, _) => SizedBox(width: Dimensions.r8.dynamicW),
        itemBuilder: (context, index) {
          final sport = _sports[index];
          final isSelected = selectedCategory == sport.name;
          return _SportChip(
            sport: sport,
            isSelected: isSelected,
            onTap: () => onCategorySelected(isSelected ? null : sport.name),
          );
        },
      ),
    );
  }
}

class _SportChip extends StatelessWidget {
  final _SportFilter sport;
  final bool isSelected;
  final VoidCallback onTap;

  const _SportChip({
    required this.sport,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.r14.dynamicW,
          vertical: Dimensions.r8.dynamicH,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : context.borderColor,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              sport.icon,
              size: Dimensions.r16.dynamicH,
              color: isSelected ? AppColor.whiteColor : context.textSecondary,
            ),
            SizedBox(width: Dimensions.r6.dynamicW),
            Text(
              sport.name,
              style: TextStyle(
                fontSize: Dimensions.r13.dynamicSP,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColor.whiteColor : context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SportFilter {
  final String name;
  final IconData icon;

  const _SportFilter(this.name, this.icon);
}
