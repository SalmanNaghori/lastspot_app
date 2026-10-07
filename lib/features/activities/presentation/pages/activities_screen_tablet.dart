import 'package:lastspot_app/core/base_import.dart';

import '../bloc/activities_bloc.dart';
import '../bloc/activities_state.dart';
import '../bloc/activities_event.dart';
import 'package:lastspot_app/core/widgets/custom_segmented_control.dart';
import '../widgets/activities_list_section.dart';
import '../widgets/activity_empty_state.dart';
import '../widgets/requests_tab_section.dart';
import '../widgets/tab_preview_row.dart';
import 'package:lastspot_app/core/widgets/custom_app_bar.dart';

class ActivitiesScreenTablet extends StatefulWidget {
  const ActivitiesScreenTablet({super.key});

  @override
  State<ActivitiesScreenTablet> createState() => _ActivitiesScreenTabletState();
}

class _ActivitiesScreenTabletState extends State<ActivitiesScreenTablet> {
  final ValueNotifier<int> _selectedTab = ValueNotifier<int>(0);

  @override
  void dispose() {
    _selectedTab.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.dashboard(
        context: context,
        title: loc.navActivities,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 850),
            margin: const EdgeInsets.all(Dimensions.r24),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(Dimensions.r20),
              border: Border.all(
                color: AppColor.helpCardBorderColor,
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blackColor.withValues(alpha: 0.04),
                  blurRadius: Dimensions.r20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.r20),
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<ActivitiesBloc>().add(
                    const RefreshActivitiesEvent(),
                  );
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: BlocConsumer<ActivitiesBloc, ActivitiesState>(
                  listener: (context, state) {
                    if (state is ActivitiesActionMessage) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: state.isError
                              ? context.errorColor
                              : context.primaryColor,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ActivitiesError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              state.isNetworkError
                                  ? Icons.wifi_off
                                  : Icons.error_outline,
                              size: Dimensions.r48.dynamicH,
                              color: context.errorColor,
                            ),
                            SizedBox(height: Dimensions.r16.dynamicH),
                            Text(state.message, style: context.bodyLarge),
                            SizedBox(height: Dimensions.r16.dynamicH),
                            FilledButton(
                              onPressed: () => context
                                  .read<ActivitiesBloc>()
                                  .add(const LoadActivitiesEvent()),
                              child: Text(loc.retry),
                            ),
                          ],
                        ),
                      );
                    } else if (state is ActivitiesLoaded) {
                      return ValueListenableBuilder<int>(
                        valueListenable: _selectedTab,
                        builder: (context, tabIndex, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.r32.dynamicW,
                                  vertical: Dimensions.r24.dynamicH,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomSegmentedControl(
                                      selectedIndex: tabIndex,
                                      onTabChanged: (index) {
                                        _selectedTab.value = index;
                                        if (index == 2) {
                                          context.read<ActivitiesBloc>().add(
                                            const LoadActivitiesEvent(),
                                          );
                                        }
                                      },
                                      tabs: [
                                        loc.tabMyActivitiesCount(state.hosted.length.toString()),
                                        loc.tabJoinedCount(state.joined.length.toString()),
                                        loc.tabRequestsCount(state.receivedRequests.length.toString()),
                                      ],
                                    ),

                                    SizedBox(height: Dimensions.r16.dynamicH),
                                    Text(
                                      loc.manageActivitiesDesc,
                                      style: context.bodySmall?.copyWith(
                                        color: context.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CustomScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    if (tabIndex == 0) ...[
                                      if (state.hosted.isEmpty && !state.isRefreshing)
                                        ActivityEmptyState(
                                          title: loc.emptyHostedTitle,
                                          message: loc.emptyHostedDesc,
                                          actionText: loc.generateActivity,
                                          onAction: () =>
                                              context.push(AppRoutes.create),
                                        )
                                      else
                                        ActivitiesListSection(
                                          activities: state.hosted,
                                          horizontalPadding: Dimensions.r32.dynamicW,
                                          isLoading: state.hosted.isEmpty && state.isRefreshing,
                                        )
                                    ] else if (tabIndex == 1) ...[
                                      if (state.joined.isEmpty && !state.isRefreshing)
                                        ActivityEmptyState(
                                          title: loc.emptyJoinedTitle,
                                          message: loc.emptyJoinedDesc,
                                          actionText:
                                              loc.exploreActivitiesAction,
                                          onAction: () =>
                                              context.go(AppRoutes.explore),
                                        )
                                      else
                                        ActivitiesListSection(
                                          activities: state.joined,
                                          horizontalPadding: Dimensions.r32.dynamicW,
                                          isLoading: state.joined.isEmpty && state.isRefreshing,
                                        )
                                    ] else ...[
                                      RequestsTabSection(
                                        receivedRequests: state.receivedRequests,
                                        sentRequests: state.sentRequests,
                                        horizontalPadding: Dimensions.r32.dynamicW,
                                        isLoading: state.receivedRequests.isEmpty && state.sentRequests.isEmpty && state.isRefreshing,
                                      ),
                                    ],
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          Dimensions.r32.dynamicW,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: Dimensions.r24.dynamicH,
                                            ),
                                            Text(
                                              loc.tabPreviewData,
                                              style: context.titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: Dimensions.r12.dynamicH,
                                            ),
                                            TabPreviewRow(
                                              text: loc.previewJoined,
                                            ),
                                            SizedBox(
                                              height: Dimensions.r8.dynamicH,
                                            ),
                                            TabPreviewRow(
                                              text: loc.previewRequests,
                                            ),
                                            SizedBox(
                                              height: Dimensions.r32.dynamicH,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
