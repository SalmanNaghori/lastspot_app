import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastspot_app/core/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../bloc/spot_details_bloc.dart';

class SpotDetailsScreen extends StatefulWidget {
  final String postId;
  const SpotDetailsScreen({super.key, required this.postId});

  @override
  State<SpotDetailsScreen> createState() => _SpotDetailsScreenState();
}

class _SpotDetailsScreenState extends State<SpotDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SpotDetailsBloc>().add(LoadSpotDetailsEvent(widget.postId));
  }

  Future<void> _launchMap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    final content = Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.matchOverviewTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocConsumer<SpotDetailsBloc, SpotDetailsState>(
          listener: (context, state) {
            if (state is RequestJoinSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColor.successColor,
              ));
            } else if (state is SpotDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColor.errorColor,
              ));
            }
          },
          buildWhen: (previous, current) => current is SpotDetailsLoaded || current is SpotDetailsLoading,
          builder: (context, state) {
            if (state is SpotDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SpotDetailsLoaded) {
              final post = state.post;
              final isHost = post.hostId == currentUserId;
              
              return SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Header
                    Text(
                      '${post.sportCategory} - ${post.venueName}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Dimensions.r8.dynamicH),
                    Text(
                      l10n.statusActiveNeeded(post.neededSpots),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Dimensions.r4.dynamicH),
                    Text(
                      l10n.hostedBy(post.hostProfile?.fullName ?? 'Anonymous'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.textSecondary),
                    ),
                    SizedBox(height: Dimensions.r24.dynamicH),
                    
                    // Schedule
                    Text('SCHEDULE', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold)),
                    SizedBox(height: Dimensions.r8.dynamicH),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: Dimensions.r20.dynamicH, color: context.textPrimary),
                        SizedBox(width: Dimensions.r12.dynamicW),
                        Text(
                          '${post.matchTime.day}/${post.matchTime.month}/${post.matchTime.year} at ${post.matchTime.hour}:${post.matchTime.minute.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.r24.dynamicH),
                    
                    // Location
                    Text(l10n.locationAndDirections, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold)),
                    SizedBox(height: Dimensions.r8.dynamicH),
                    Container(
                      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: AppColor.errorColor),
                              SizedBox(width: Dimensions.r8.dynamicW),
                              Expanded(child: Text(post.venueName, style: Theme.of(context).textTheme.titleMedium)),
                            ],
                          ),
                          SizedBox(height: Dimensions.r4.dynamicH),
                          Text(l10n.tapForNavigation, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.textSecondary)),
                          SizedBox(height: Dimensions.r16.dynamicH),
                          if (post.googleMapsUrl != null)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _launchMap(post.googleMapsUrl!),
                                icon: const Icon(Icons.explore),
                                label: Text(l10n.openInMaps),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColor.primaryColor,
                                  side: BorderSide(color: AppColor.primaryColor),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.r24.dynamicH),
                    
                    // Confirmed Players
                    Text(
                      l10n.confirmedPlayers(state.confirmedPlayers.length, post.totalSpots), 
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Dimensions.r12.dynamicH),
                    Wrap(
                      spacing: Dimensions.r8.dynamicW,
                      runSpacing: Dimensions.r8.dynamicH,
                      children: state.confirmedPlayers.map((req) => Chip(
                        avatar: const CircleAvatar(child: Icon(Icons.person, size: 16)),
                        label: Text(req.userProfile?.fullName ?? 'Player'),
                      )).toList(),
                    ),
                    SizedBox(height: Dimensions.r24.dynamicH),
                    
                    // Safety
                    Text(l10n.safetyAndConduct, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold)),
                    SizedBox(height: Dimensions.r8.dynamicH),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.flag, color: AppColor.errorColor),
                      label: Text(l10n.reportActivity, style: const TextStyle(color: AppColor.errorColor)),
                    ),
                    
                    SizedBox(height: Dimensions.r48.dynamicH), // Padding for bottom
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.r16.dynamicW),
            child: BlocBuilder<SpotDetailsBloc, SpotDetailsState>(
              builder: (context, state) {
                if (state is SpotDetailsLoaded) {
                  final isHost = state.post.hostId == currentUserId;
                  if (isHost) {
                    return ElevatedButton(
                      onPressed: () => context.push('/manage-requests/${state.post.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondaryColor,
                        foregroundColor: AppColor.whiteColor,
                        minimumSize: Size(double.infinity, Dimensions.r50.dynamicH),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR)),
                      ),
                      child: Text(l10n.manageMatchRequests, style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: state.post.neededSpots > 0
                          ? () => context.read<SpotDetailsBloc>().add(RequestToJoinEvent(state.post.id))
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: AppColor.whiteColor,
                        minimumSize: Size(double.infinity, Dimensions.r50.dynamicH),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR)),
                      ),
                      child: Text(l10n.requestToJoin, style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    return ResponsiveLayout(
      mobile: content,
      tablet: content,
    );
  }
}
