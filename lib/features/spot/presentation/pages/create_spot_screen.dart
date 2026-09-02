import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lastspot_app/core/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../bloc/create_spot_bloc.dart';

class CreateSpotScreen extends StatefulWidget {
  const CreateSpotScreen({super.key});

  @override
  State<CreateSpotScreen> createState() => _CreateSpotScreenState();
}

class _CreateSpotScreenState extends State<CreateSpotScreen> {
  String _selectedSport = 'Cricket';
  int _playersNeeded = 2;
  DateTime _matchDate = DateTime.now();
  TimeOfDay _matchTime = TimeOfDay.now();

  final _venueNameController = TextEditingController();
  final _mapsUrlController = TextEditingController();
  final _guidelinesController = TextEditingController();

  void _submit() {
    if (_venueNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Venue name is required.')));
      return;
    }

    final matchDateTime = DateTime(
      _matchDate.year,
      _matchDate.month,
      _matchDate.day,
      _matchTime.hour,
      _matchTime.minute,
    );

    final event = SubmitSpotEvent(
      sportCategory: _selectedSport,
      totalSpots: _playersNeeded,
      neededSpots: _playersNeeded,
      matchTime: matchDateTime,
      venueName: _venueNameController.text,
      googleMapsUrl: _mapsUrlController.text.isNotEmpty ? _mapsUrlController.text : null,
      additionalNotes: _guidelinesController.text.isNotEmpty ? _guidelinesController.text : null,
    );

    context.read<CreateSpotBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final content = BlocListener<CreateSpotBloc, CreateSpotState>(
      listener: (context, state) {
        if (state is CreateSpotSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Spot published successfully!')),
          );
          context.pop();
        } else if (state is CreateSpotError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
          title: Text(l10n.hostMatchTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.r16.dynamicW),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sport Category
            Text(
              l10n.selectSportCategory,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimensions.r8.dynamicH),
            DropdownButtonFormField<String>(
              value: _selectedSport,
              decoration: InputDecoration(
                filled: true,
                fillColor: context.surfaceColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR)),
              ),
              items: ['Cricket', 'Football', 'Badminton'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedSport = val);
              },
            ),
            SizedBox(height: Dimensions.r24.dynamicH),

            // Players Needed
            Text(
              l10n.playersNeeded,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimensions.r8.dynamicH),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (_playersNeeded > 1) setState(() => _playersNeeded--);
                  },
                ),
                Text('$_playersNeeded', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() => _playersNeeded++);
                  },
                ),
              ],
            ),
            SizedBox(height: Dimensions.r24.dynamicH),

            // Schedule
            Text(l10n.schedule, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: Dimensions.r8.dynamicH),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _matchDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (date != null) setState(() => _matchDate = date);
                    },
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.r12.dynamicW),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        border: Border.all(color: context.borderColor),
                        borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                      ),
                      child: Text('${l10n.datePrefix}${_matchDate.day}/${_matchDate.month}/${_matchDate.year}'),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.r16.dynamicW),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: _matchTime);
                      if (time != null) setState(() => _matchTime = time);
                    },
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.r12.dynamicW),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        border: Border.all(color: context.borderColor),
                        borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                      ),
                      child: Text('${l10n.timePrefix}${_matchTime.format(context)}'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.r24.dynamicH),

            // Venue Details
            Text(
              l10n.venueDetails,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimensions.r8.dynamicH),
            TextField(
              controller: _venueNameController,
              decoration: InputDecoration(
                hintText: l10n.venueNameHint,
                filled: true,
                fillColor: context.surfaceColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR)),
              ),
            ),
            SizedBox(height: Dimensions.r12.dynamicH),
            TextField(
              controller: _mapsUrlController,
              decoration: InputDecoration(
                hintText: l10n.mapsLinkHint,
                filled: true,
                fillColor: context.surfaceColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR)),
              ),
            ),
            SizedBox(height: Dimensions.r8.dynamicH),
            Row(
              children: [
                Icon(Icons.info_outline, size: Dimensions.r16.dynamicH, color: context.textSecondary),
                SizedBox(width: Dimensions.r8.dynamicW),
                Expanded(
                  child: Text(
                    l10n.mapsGuidance,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.textSecondary),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.r24.dynamicH),

            // Guidelines
            Text(
              l10n.additionalGuidelines,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimensions.r8.dynamicH),
            TextField(
              controller: _guidelinesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Please bring white tennis ball kit.\nTurf fee will be split equally.',
                filled: true,
                fillColor: context.surfaceColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR)),
              ),
            ),
            SizedBox(height: Dimensions.r32.dynamicH),

            SizedBox(
              width: double.infinity,
              height: Dimensions.r48.dynamicH,
              child: BlocBuilder<CreateSpotBloc, CreateSpotState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is CreateSpotLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: AppColor.whiteColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR)),
                    ),
                    child: state is CreateSpotLoading
                        ? const CircularProgressIndicator(color: AppColor.whiteColor)
                        : Text(l10n.publishSpot, style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
          ],
        ),
        ),
      ),
    );
    return ResponsiveLayout(mobile: content, tablet: content);
  }
}
