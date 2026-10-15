import 'package:lastspot_app/core/base_import.dart';
import '../../../cities/domain/entities/city_entity.dart';

class ProfileCityStep extends StatefulWidget {
  final List<CityEntity> cities;
  final ValueNotifier<CityEntity?> selectedCity;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onRetry;
  final VoidCallback onNext;

  const ProfileCityStep({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.isLoading,
    required this.hasError,
    required this.onRetry,
    required this.onNext,
  });

  @override
  State<ProfileCityStep> createState() => _ProfileCityStepState();
}

class _ProfileCityStepState extends State<ProfileCityStep> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCities = widget.cities.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: Dimensions.r16.dynamicH),
        Text(
          'Where do you play?',
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
          'Select your city to discover matches and spots happening nearby.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Dimensions.r14.dynamicSP,
            color: context.textSecondary,
            height: 1.4,
          ),
        ),
        SizedBox(height: Dimensions.r20.dynamicH),
        AppTextField(
          controller: _searchController,
          labelText: context.loc.cityLabel,
          hintText: 'Search city or region...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          onChanged: (val) => setState(() => _searchQuery = val.trim()),
        ),
        SizedBox(height: Dimensions.r16.dynamicH),
        if (widget.isLoading)
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.r48.dynamicH),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (widget.hasError)
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.r32.dynamicH),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: Dimensions.r40.dynamicH,
                  color: context.errorColor,
                ),
                SizedBox(height: Dimensions.r8.dynamicH),
                Text(
                  'Failed to load cities',
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: Dimensions.r14.dynamicSP,
                  ),
                ),
                SizedBox(height: Dimensions.r12.dynamicH),
                TextButton(
                  onPressed: widget.onRetry,
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
        else if (filteredCities.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.r32.dynamicH),
            child: Center(
              child: Text(
                'No cities matching "$_searchQuery"',
                style: TextStyle(
                  color: context.textSecondary,
                  fontSize: Dimensions.r14.dynamicSP,
                ),
              ),
            ),
          )
        else
          ValueListenableBuilder<CityEntity?>(
            valueListenable: widget.selectedCity,
            builder: (context, selected, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCities.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: Dimensions.r8.dynamicH),
                itemBuilder: (context, index) {
                  final city = filteredCities[index];
                  final isSelected = selected?.id == city.id;

                  return InkWell(
                    onTap: () {
                      widget.selectedCity.value = city;
                    },
                    borderRadius: BorderRadius.circular(
                      Dimensions.r16.dynamicR,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.r16.dynamicW,
                        vertical: Dimensions.r14.dynamicH,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (context.isDarkMode
                                  ? context.primaryColor.withValues(alpha: 0.18)
                                  : const Color(0xFFF0FDF4))
                            : (context.isDarkMode
                                  ? context.surfaceContainer
                                  : AppColor.surfaceContainerLight),
                        borderRadius: BorderRadius.circular(
                          Dimensions.r16.dynamicR,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? context.primaryColor
                              : context.borderColor.withValues(alpha: 0.6),
                          width: isSelected ? 2.0 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: context.primaryColor.withValues(
                                    alpha: 0.15,
                                  ),
                                  blurRadius: Dimensions.r8.dynamicR,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: Dimensions.r36.dynamicW,
                            height: Dimensions.r36.dynamicH,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.primaryColor.withValues(alpha: 0.15)
                                  : context.surfaceColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              size: Dimensions.r18.dynamicH,
                              color: isSelected
                                  ? context.primaryColor
                                  : context.textSecondary,
                            ),
                          ),
                          SizedBox(width: Dimensions.r12.dynamicW),
                          Expanded(
                            child: Text(
                              city.name,
                              style: TextStyle(
                                fontSize: Dimensions.r15.dynamicSP,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isSelected
                                    ? context.primaryColor
                                    : context.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            width: Dimensions.r24.dynamicW,
                            height: Dimensions.r24.dynamicH,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? context.primaryColor
                                    : context.borderColor,
                                width: 2.0,
                              ),
                              color: isSelected
                                  ? context.primaryColor
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check_rounded,
                                    size: Dimensions.r16.dynamicH,
                                    color: AppColor.whiteColor,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        SizedBox(height: Dimensions.r28.dynamicH),
        ValueListenableBuilder<CityEntity?>(
          valueListenable: widget.selectedCity,
          builder: (context, selected, _) {
            final hasSelection = selected != null;
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
                  'Next: Choose Sports',
                  style: TextStyle(
                    fontSize: Dimensions.r16.dynamicSP,
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
