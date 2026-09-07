import 'package:lastspot_app/core/base_import.dart';

import '../../../../core/widgets/app_filter_chip.dart';
import '../../../../core/widgets/app_section_title.dart';
import '../bloc/explore_state.dart';

class ExploreFilterBottomSheet extends StatefulWidget {
  final ExploreDateFilter initialDateFilter;
  final ExplorePriceFilter initialPriceFilter;
  final ExploreParticipantsFilter initialParticipantsFilter;
  final void Function(ExploreDateFilter, ExplorePriceFilter, ExploreParticipantsFilter) onApply;

  const ExploreFilterBottomSheet({
    super.key,
    required this.initialDateFilter,
    required this.initialPriceFilter,
    required this.initialParticipantsFilter,
    required this.onApply,
  });

  @override
  State<ExploreFilterBottomSheet> createState() => _ExploreFilterBottomSheetState();
}

class _ExploreFilterBottomSheetState extends State<ExploreFilterBottomSheet> {
  late ValueNotifier<ExploreDateFilter> _dateFilter;
  late ValueNotifier<ExplorePriceFilter> _priceFilter;
  late ValueNotifier<ExploreParticipantsFilter> _participantsFilter;

  @override
  void initState() {
    super.initState();
    _dateFilter = ValueNotifier(widget.initialDateFilter);
    _priceFilter = ValueNotifier(widget.initialPriceFilter);
    _participantsFilter = ValueNotifier(widget.initialParticipantsFilter);
  }

  @override
  void dispose() {
    _dateFilter.dispose();
    _priceFilter.dispose();
    _participantsFilter.dispose();
    super.dispose();
  }

  void _reset() {
    _dateFilter.value = ExploreDateFilter.any;
    _priceFilter.value = ExplorePriceFilter.any;
    _participantsFilter.value = ExploreParticipantsFilter.any;
    _apply();
  }

  void _apply() {
    widget.onApply(_dateFilter.value, _priceFilter.value, _participantsFilter.value);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              context.loc.filters,
              style: TextStyle(
                fontSize: Dimensions.r18.dynamicSP,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
          ),
          SizedBox(height: Dimensions.r24.dynamicH),

          AppSectionTitle(title: context.loc.date),
          ValueListenableBuilder<ExploreDateFilter>(
            valueListenable: _dateFilter,
            builder: (context, dateFilterValue, child) => Wrap(
              spacing: Dimensions.r8.dynamicW,
              runSpacing: Dimensions.r8.dynamicH,
              children: [
                AppFilterChip(
                  label: context.loc.anyDate,
                  value: ExploreDateFilter.any,
                  groupValue: dateFilterValue,
                  onSelected: (v) => _dateFilter.value = v,
                ),
                AppFilterChip(
                  label: context.loc.today,
                  value: ExploreDateFilter.today,
                  groupValue: dateFilterValue,
                  onSelected: (v) => _dateFilter.value = v,
                ),
                AppFilterChip(
                  label: context.loc.tomorrow,
                  value: ExploreDateFilter.tomorrow,
                  groupValue: dateFilterValue,
                  onSelected: (v) => _dateFilter.value = v,
                ),
                AppFilterChip(
                  label: context.loc.thisWeekend,
                  value: ExploreDateFilter.thisWeekend,
                  groupValue: dateFilterValue,
                  onSelected: (v) => _dateFilter.value = v,
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.r24.dynamicH),

          AppSectionTitle(title: context.loc.price),
          ValueListenableBuilder<ExplorePriceFilter>(
            valueListenable: _priceFilter,
            builder: (context, priceFilterValue, child) => Wrap(
              spacing: Dimensions.r8.dynamicW,
              runSpacing: Dimensions.r8.dynamicH,
              children: [
                AppFilterChip(
                  label: context.loc.any,
                  value: ExplorePriceFilter.any,
                  groupValue: priceFilterValue,
                  onSelected: (v) => _priceFilter.value = v,
                ),
                AppFilterChip(
                  label: context.loc.free,
                  value: ExplorePriceFilter.free,
                  groupValue: priceFilterValue,
                  onSelected: (v) => _priceFilter.value = v,
                ),
                AppFilterChip(
                  label: context.loc.paid,
                  value: ExplorePriceFilter.paid,
                  groupValue: priceFilterValue,
                  onSelected: (v) => _priceFilter.value = v,
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.r24.dynamicH),

          AppSectionTitle(title: context.loc.participants),
          ValueListenableBuilder<ExploreParticipantsFilter>(
            valueListenable: _participantsFilter,
            builder: (context, participantsFilterValue, child) => Wrap(
              spacing: Dimensions.r8.dynamicW,
              runSpacing: Dimensions.r8.dynamicH,
              children: [
                AppFilterChip(
                  label: context.loc.any,
                  value: ExploreParticipantsFilter.any,
                  groupValue: participantsFilterValue,
                  onSelected: (v) => _participantsFilter.value = v,
                ),
                AppFilterChip(
                  label: context.loc.spots1to2,
                  value: ExploreParticipantsFilter.spots1to2,
                  groupValue: participantsFilterValue,
                  onSelected: (v) => _participantsFilter.value = v,
                ),
                AppFilterChip(
                  label: context.loc.spots3to5,
                  value: ExploreParticipantsFilter.spots3to5,
                  groupValue: participantsFilterValue,
                  onSelected: (v) => _participantsFilter.value = v,
                ),
                AppFilterChip(
                  label: context.loc.spots5plus,
                  value: ExploreParticipantsFilter.spots5plus,
                  groupValue: participantsFilterValue,
                  onSelected: (v) => _participantsFilter.value = v,
                ),
              ],
            ),
          ),

          SizedBox(height: Dimensions.r32.dynamicH),
          Divider(color: context.borderColor),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.r16.dynamicH),
            child: Row(
              children: [
                Expanded(
                  child: AppButton.outline(onPressed: _reset, label: context.loc.reset),
                ),
                SizedBox(width: Dimensions.r16.dynamicW),
                Expanded(
                  child: AppButton.primary(onPressed: _apply, label: context.loc.applyFilters),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
