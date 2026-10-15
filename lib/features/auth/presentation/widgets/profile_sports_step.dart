import 'package:lastspot_app/core/base_import.dart';
import '../../../categories/domain/entities/category.dart';

/// Grouped, searchable sports & traditional games selection step for onboarding & profile setup.
class ProfileSportsStep extends StatefulWidget {
  final List<CategoryEntity> categories;
  final ValueNotifier<List<String>> selectedSports;
  final Function(String) onToggleSport;
  final VoidCallback onNext;

  const ProfileSportsStep({
    super.key,
    required this.categories,
    required this.selectedSports,
    required this.onToggleSport,
    required this.onNext,
  });

  @override
  State<ProfileSportsStep> createState() => _ProfileSportsStepState();
}

class _ProfileSportsStepState extends State<ProfileSportsStep> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedGroup = 'All';
  String _searchQuery = '';

  static const List<String> _groups = [
    'All',
    'Traditional Games',
    'Team Sports',
    'Racket Sports',
    'Fitness & Adventure',
    'Community Activities',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query != _searchQuery) {
      setState(() {
        _searchQuery = query;
      });
    }
  }

  void _onGroupSelected(String group) {
    if (_selectedGroup != group) {
      setState(() {
        _selectedGroup = group;
      });
    }
  }

  void _onClearSearch() {
    _searchController.clear();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<CategoryEntity> get _filteredCategories {
    return widget.categories.where((cat) {
      // 1. Filter by group
      if (_selectedGroup != 'All') {
        final group = AppAssets.getCategoryGroup(cat.slug);
        if (group != _selectedGroup) return false;
      }
      // 2. Filter by search query
      if (_searchQuery.isNotEmpty) {
        final nameMatch = cat.name.toLowerCase().contains(_searchQuery);
        final slugMatch = cat.slug.toLowerCase().contains(_searchQuery);
        return nameMatch || slugMatch;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: Dimensions.r16.dynamicH),
        Text(
          'Choose your sports & games',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Dimensions.r24.dynamicSP,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: context.textPrimary,
          ),
        ),
        SizedBox(height: Dimensions.r6.dynamicH),
        Text(
          'Select all outdoor sports and Gujarat traditional games you play.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Dimensions.r14.dynamicSP,
            color: context.textSecondary,
            height: 1.4,
          ),
        ),
        SizedBox(height: Dimensions.r16.dynamicH),

        // Search Bar
        Container(
          height: Dimensions.r48.dynamicH,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(Dimensions.r14.dynamicR),
            border: Border.all(
              color: context.borderColor.withValues(alpha: 0.8),
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.r12.dynamicW),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: Dimensions.r20.dynamicH,
                color: context.textSecondary,
              ),
              SizedBox(width: Dimensions.r8.dynamicW),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    fontSize: Dimensions.r14.dynamicSP,
                    color: context.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search sports, kabaddi, satoliya...',
                    hintStyle: TextStyle(
                      fontSize: Dimensions.r13.dynamicSP,
                      color: context.textSecondary.withValues(alpha: 0.7),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: _onClearSearch,
                  child: Icon(
                    Icons.close_rounded,
                    size: Dimensions.r18.dynamicH,
                    color: context.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.r12.dynamicH),

        // Category Group Filter Pills
        SizedBox(
          height: Dimensions.r36.dynamicH,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _groups.length,
            separatorBuilder: (_, _) => SizedBox(width: Dimensions.r8.dynamicW),
            itemBuilder: (context, idx) {
              final group = _groups[idx];
              final isSelected = _selectedGroup == group;

              return GestureDetector(
                onTap: () => _onGroupSelected(group),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r12.dynamicW,
                    vertical: Dimensions.r6.dynamicH,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.primaryColor
                        : context.surfaceColor,
                    borderRadius: BorderRadius.circular(
                      Dimensions.r18.dynamicR,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? context.primaryColor
                          : context.borderColor.withValues(alpha: 0.7),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      group,
                      style: TextStyle(
                        fontSize: Dimensions.r12.dynamicSP,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected
                            ? AppColor.whiteColor
                            : context.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: Dimensions.r16.dynamicH),

        // Grid of Category Tiles
        ValueListenableBuilder<List<String>>(
          valueListenable: widget.selectedSports,
          builder: (context, selectedList, _) {
            if (filtered.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.r32.dynamicH,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.sports_rounded,
                        size: Dimensions.r40.dynamicH,
                        color: context.textSecondary.withValues(alpha: 0.4),
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      Text(
                        'No sports found for "$_searchQuery"',
                        style: TextStyle(
                          fontSize: Dimensions.r14.dynamicSP,
                          fontWeight: FontWeight.w600,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: Dimensions.r12.dynamicH,
                crossAxisSpacing: Dimensions.r12.dynamicW,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, index) {
                final category = filtered[index];
                final isSelected = selectedList.contains(category.name);

                return SportCategoryTile(
                  key: ValueKey(
                    'onboard_sport_${category.id}_${category.slug}',
                  ),
                  category: category,
                  isSelected: isSelected,
                  onTap: () => widget.onToggleSport(category.name),
                );
              },
            );
          },
        ),
        SizedBox(height: Dimensions.r32.dynamicH),

        // Action CTA
        ValueListenableBuilder<List<String>>(
          valueListenable: widget.selectedSports,
          builder: (context, selectedList, _) {
            final hasSelection = selectedList.isNotEmpty;

            return SizedBox(
              width: double.infinity,
              height: Dimensions.r48.dynamicH * 1.15,
              child: FilledButton(
                onPressed: hasSelection ? widget.onNext : null,
                style: FilledButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: AppColor.whiteColor,
                  disabledBackgroundColor: context.borderColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Dimensions.r16.dynamicR,
                    ),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  hasSelection
                      ? 'Next: Complete Setup (${selectedList.length} selected)'
                      : 'Select at least 1 sport or game',
                  style: TextStyle(
                    fontSize: Dimensions.r15.dynamicSP,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
