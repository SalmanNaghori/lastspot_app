import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastspot_app/core/base_import.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../../cities/presentation/bloc/city_cubit.dart';
import '../../../cities/presentation/bloc/city_state.dart';
import '../../../../core/di/service_locator.dart';

class CityPickerBottomSheet extends StatefulWidget {
  final CityEntity? selectedCity;

  const CityPickerBottomSheet({super.key, this.selectedCity});

  static Future<CityEntity?> show(BuildContext context, {CityEntity? selectedCity}) {
    return showModalBottomSheet<CityEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.r24)),
      ),
      builder: (context) => BlocProvider(
        create: (context) => sl<CityCubit>()..fetchCities(),
        child: CityPickerBottomSheet(selectedCity: selectedCity),
      ),
    );
  }

  @override
  State<CityPickerBottomSheet> createState() => _CityPickerBottomSheetState();
}

class _CityPickerBottomSheetState extends State<CityPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(Dimensions.r16),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: Dimensions.r48,
            height: Dimensions.r4,
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(Dimensions.r2),
            ),
          ),
          const SizedBox(height: Dimensions.r16),
          // Title
          Text(
            'Select City',
            style: TextStyle(
              fontSize: Dimensions.r20,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.r16),
          // Search Field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search city',
              prefixIcon: Icon(Icons.search, color: context.textSecondary),
              filled: true,
              fillColor: context.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.r12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          const SizedBox(height: Dimensions.r16),
          // List
          Expanded(
            child: BlocBuilder<CityCubit, CityState>(
              builder: (context, state) {
                if (state is CityLoading || state is CityInitial) {
                  return Center(child: CircularProgressIndicator(color: AppColor.primaryColor));
                } else if (state is CityError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message, textAlign: TextAlign.center, style: TextStyle(color: context.textSecondary)),
                        const SizedBox(height: Dimensions.r16),
                        ElevatedButton(
                          onPressed: () => context.read<CityCubit>().fetchCities(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                            foregroundColor: AppColor.whiteColor,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is CityLoaded) {
                  final filteredCities = state.cities
                      .where((city) => city.name.toLowerCase().contains(_searchQuery))
                      .toList();

                  if (filteredCities.isEmpty) {
                    return Center(
                      child: Text('No cities found', style: TextStyle(color: context.textSecondary)),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = filteredCities[index];
                      final isSelected = widget.selectedCity?.id == city.id;

                      return ListTile(
                        title: Text(
                          city.name,
                          style: TextStyle(
                            color: isSelected ? AppColor.primaryColor : context.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected ? Icon(Icons.check, color: AppColor.primaryColor) : null,
                        onTap: () {
                          Navigator.of(context).pop(city);
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
