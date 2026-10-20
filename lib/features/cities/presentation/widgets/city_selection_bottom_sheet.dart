import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/city_entity.dart';
import 'city_list_tile.dart';

/// Reusable modal bottom sheet for selecting a city.
///
/// Features:
/// - Real-time search query filtering across city name and state.
/// - Shows city name along with its state when available (e.g. Vadodara, Gujarat).
/// - Highlights current selected city with active indicator.
/// - Immediate selection dismissal per app standards.
/// - Fully localized and theme-adaptive (Material 3).
class CitySelectionBottomSheet extends StatefulWidget {
  final List<CityEntity> cities;
  final String? selectedCityId;
  final ValueChanged<CityEntity> onCitySelected;

  const CitySelectionBottomSheet({
    super.key,
    required this.cities,
    this.selectedCityId,
    required this.onCitySelected,
  });

  /// Helper to show the bottom sheet via [AppBottomSheet].
  static Future<void> show({
    required BuildContext context,
    required List<CityEntity> cities,
    String? selectedCityId,
    required ValueChanged<CityEntity> onCitySelected,
  }) {
    return AppBottomSheet.show(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CitySelectionBottomSheet(
        cities: cities,
        selectedCityId: selectedCityId,
        onCitySelected: onCitySelected,
      ),
    );
  }

  @override
  State<CitySelectionBottomSheet> createState() =>
      _CitySelectionBottomSheetState();
}

class _CitySelectionBottomSheetState extends State<CitySelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _handleCityTap(CityEntity city) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
    widget.onCitySelected(city);
  }

  List<CityEntity> _getFilteredCities() {
    if (_searchQuery.isEmpty) {
      return widget.cities;
    }
    final terms = _searchQuery.split(RegExp(r'\s+'));
    return widget.cities.where((city) {
      final searchableText = '${city.name} ${city.state ?? ''}'.toLowerCase();
      return terms.every(searchableText.contains);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final filteredCities = _getFilteredCities();
    final media = MediaQuery.of(context);
    final availableHeight = media.size.height - media.viewPadding.top;
    final maxHeight = availableHeight * 0.82;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimensions.r16.dynamicW,
          Dimensions.r4.dynamicH,
          Dimensions.r16.dynamicW,
          Dimensions.r12.dynamicH,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title row
            Row(
              children: [
                ActivityMetadataIcon.location(
                  width: Dimensions.r24.dynamicW,
                  height: Dimensions.r24.dynamicH,
                ),
                SizedBox(width: Dimensions.r8.dynamicW),
                Text(
                  loc.selectCity,
                  style: TextStyle(
                    fontSize: Dimensions.r18.dynamicSP,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.r12.dynamicH),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? context.surfaceContainer
                    : AppColor.surfaceContainerLight,
                borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                border: Border.all(
                  color: context.borderColor.withValues(alpha: 0.6),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                scrollPadding: EdgeInsets.only(bottom: Dimensions.r16.dynamicH),
                style: TextStyle(
                  fontSize: Dimensions.r14.dynamicSP,
                  color: context.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: loc.searchCityHint,
                  hintStyle: TextStyle(
                    fontSize: Dimensions.r14.dynamicSP,
                    color: context.textSecondary,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: Dimensions.r20.dynamicH,
                    color: context.textSecondary,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            size: Dimensions.r18.dynamicH,
                            color: context.textSecondary,
                          ),
                          onPressed: _onClearSearch,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Dimensions.r12.dynamicH,
                    horizontal: Dimensions.r12.dynamicW,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.r12.dynamicH),

            // Cities list
            Flexible(
              child: filteredCities.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.r32.dynamicH,
                      ),
                      child: Center(
                        child: Text(
                          loc.noCitiesFound,
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: Dimensions.r14.dynamicSP,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: filteredCities.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: Dimensions.r6.dynamicH),
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        final isSelected = city.id == widget.selectedCityId;
                        return CityListTile(
                          city: city,
                          isSelected: isSelected,
                          onTap: () => _handleCityTap(city),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
