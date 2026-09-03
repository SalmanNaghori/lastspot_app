import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/base_import.dart';
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
    context.read<SpotDetailsBloc>().add(LoadSpotDetailsEvent(spotId: widget.postId));
  }

  Future<void> _launchMap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    final content = Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text(l10n.matchOverviewTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
      ),
      body: BlocConsumer<SpotDetailsBloc, SpotDetailsState>(
        listener: (context, state) {
          if (state is RequestJoinSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColor.successColor));
          } else if (state is SpotDetailsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColor.errorColor));
          }
        },
        buildWhen: (previous, current) => current is SpotDetailsLoaded || current is SpotDetailsLoading,
        builder: (context, state) {
          if (state is SpotDetailsLoading) {
            return LoadingState.shimmerCard();
          } else if (state is SpotDetailsLoaded) {
            final post = state.post;

            return SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.r16.dynamicW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Carousel
                  if (post.images.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                      child: SizedBox(
                        height: Dimensions.r64.dynamicH * 3,
                        width: double.infinity,
                        child: PageView.builder(
                          itemCount: post.images.length,
                          itemBuilder: (context, index) {
                            return AppCachedNetworkImage(
                              imageUrl: post.images[index].storagePath,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.r16.dynamicH),
                  ],

                  // Title Header
                  Text(
                    post.title.trim().isNotEmpty ? post.title.trim() : post.locationName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  Text(
                    l10n.statusActiveNeeded(post.currentParticipants),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColor.primaryColor, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Dimensions.r4.dynamicH),
                  Text(
                    l10n.hostedBy(post.hostProfile?.fullName ?? 'Anonymous'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.textSecondary),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  // Schedule
                  Text(
                    'SCHEDULE',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: Dimensions.r20.dynamicH, color: context.textPrimary),
                      SizedBox(width: Dimensions.r12.dynamicW),
                      Text(
                        '${post.eventDateTime.day}/${post.eventDateTime.month}/${post.eventDateTime.year} at ${post.eventDateTime.hour}:${post.eventDateTime.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  // Location
                  Text(
                    l10n.locationAndDirections,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold),
                  ),
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
                            Expanded(child: Text(post.locationName, style: Theme.of(context).textTheme.titleMedium)),
                          ],
                        ),
                        SizedBox(height: Dimensions.r4.dynamicH),
                        Text(
                          l10n.tapForNavigation,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.textSecondary),
                        ),
                        SizedBox(height: Dimensions.r16.dynamicH),
                        if (post.locationName.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.map, color: AppColor.primaryColor),
                            title: const Text('View on Map'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Can integrate maps URL later
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  // Confirmed Players
                  Text(
                    l10n.confirmedPlayers(state.confirmedPlayers.length, post.maxParticipants),
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Dimensions.r12.dynamicH),
                  Wrap(
                    spacing: Dimensions.r8.dynamicW,
                    runSpacing: Dimensions.r8.dynamicH,
                    children: state.confirmedPlayers
                        .map(
                          (req) => Chip(
                            avatar: const CircleAvatar(child: Icon(Icons.person, size: 16)),
                            label: Text(req.userProfile?.fullName ?? 'Player'),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  // Safety
                  Text(
                    l10n.safetyAndConduct,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold),
                  ),
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
                final isHost = state.post.userId == currentUserId;
                if (isHost) {
                  return ElevatedButton(
                    onPressed: () => context.push(AppRoutes.manageRequestsPath(state.post.id)),
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
                    onPressed: state.post.currentParticipants > 0
                        ? () => context.read<SpotDetailsBloc>().add(RequestToJoinEvent(spotId: state.post.id))
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
    return ResponsiveLayout(mobile: content, tablet: content);
  }
}
