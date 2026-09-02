import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastspot_app/core/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../bloc/manage_requests_bloc.dart';

class ManageRequestsScreen extends StatefulWidget {
  final String postId;
  const ManageRequestsScreen({super.key, required this.postId});

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ManageRequestsBloc>().add(LoadManageRequestsEvent(widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final content = Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.manageMatchRequests, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: BlocBuilder<ManageRequestsBloc, ManageRequestsState>(
          builder: (context, state) {
            if (state is ManageRequestsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ManageRequestsError) {
              return Center(child: Text(state.message, style: const TextStyle(color: AppColor.errorColor)));
            } else if (state is ManageRequestsLoaded) {
              final post = state.post;
              final pendingRequests = state.pendingRequests;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Match: ${post.sportCategory} at ${post.venueName}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: Dimensions.r8.dynamicH),
                        Text(
                          l10n.openSpotsRemaining(post.neededSpots, post.totalSpots),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: post.neededSpots == 0 ? AppColor.errorColor : AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                    child: Text(
                      l10n.pendingRequests(pendingRequests.length),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: pendingRequests.isEmpty
                        ? const Center(child: Text("No pending requests."))
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
                            itemCount: pendingRequests.length,
                            itemBuilder: (context, index) {
                              final req = pendingRequests[index];
                              return Card(
                                color: context.surfaceColor,
                                margin: EdgeInsets.only(bottom: Dimensions.r12.dynamicH),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                  side: BorderSide(color: context.borderColor),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const CircleAvatar(child: Icon(Icons.person)),
                                          SizedBox(width: Dimensions.r12.dynamicW),
                                          Expanded(
                                            child: Text(
                                              req.userProfile?.fullName ?? 'Player',
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (req.message != null && req.message!.isNotEmpty) ...[
                                        SizedBox(height: Dimensions.r8.dynamicH),
                                        Text('"${req.message}"', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
                                      ],
                                      SizedBox(height: Dimensions.r16.dynamicH),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {
                                              context.read<ManageRequestsBloc>().add(UpdateRequestStatusEvent(requestId: req.id, status: 'rejected'));
                                            },
                                            icon: const Icon(Icons.close, color: AppColor.errorColor),
                                            label: Text(l10n.reject, style: const TextStyle(color: AppColor.errorColor)),
                                          ),
                                          SizedBox(width: Dimensions.r8.dynamicW),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              context.read<ManageRequestsBloc>().add(UpdateRequestStatusEvent(requestId: req.id, status: 'accepted'));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColor.successColor,
                                              foregroundColor: AppColor.whiteColor,
                                            ),
                                            icon: const Icon(Icons.check),
                                            label: Text(l10n.accept),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.r16.dynamicW),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat),
              label: Text(l10n.openMatchChat, style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.surfaceColor,
                foregroundColor: AppColor.primaryColor,
                minimumSize: Size(double.infinity, Dimensions.r48.dynamicH),
                side: const BorderSide(color: AppColor.primaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR)),
              ),
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
