import 'package:lastspot_app/core/base_import.dart';

import '../bloc/activities_bloc.dart';
import '../bloc/activities_state.dart';
import '../bloc/activities_event.dart';
import '../widgets/activities_tab_bar.dart';
import '../widgets/activities_list_section.dart';
import '../widgets/activity_empty_state.dart';
import '../widgets/requests_tab_section.dart';
import 'package:lastspot_app/core/widgets/custom_app_bar.dart';

class ActivitiesScreenMobile extends StatefulWidget {
  const ActivitiesScreenMobile({super.key});

  @override
  State<ActivitiesScreenMobile> createState() => _ActivitiesScreenMobileState();
}

class _ActivitiesScreenMobileState extends State<ActivitiesScreenMobile> {
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
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<ActivitiesBloc>().add(const RefreshActivitiesEvent());
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
              if (state is ActivitiesInitial || state is ActivitiesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ActivitiesError) {
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
                        onPressed: () => context.read<ActivitiesBloc>().add(
                          const LoadActivitiesEvent(),
                        ),
                        child: Text(loc.retry),
                      ),
                    ],
                  ),
                );
              } else if (state is ActivitiesLoaded) {
                return ValueListenableBuilder<int>(
                  valueListenable: _selectedTab,
                  builder: (context, tabIndex, child) {
                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.r16.dynamicW,
                              vertical: Dimensions.r12.dynamicH,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ActivitiesTabBar(
                                  selectedIndex: tabIndex,
                                  onTabChanged: (index) {
                                    _selectedTab.value = index;
                                    if (index == 2) {
                                      context.read<ActivitiesBloc>().add(
                                        const LoadActivitiesEvent(),
                                      );
                                    }
                                  },
                                  tab1Label: loc.tabMyActivitiesCount(
                                    state.hosted.length.toString(),
                                  ),
                                  tab2Label: loc.tabJoinedCount(
                                    state.joined.length.toString(),
                                  ),
                                  tab3Label: loc.tabRequestsCount(
                                    state.receivedRequests.length.toString(),
                                  ),
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
                        ),
                        if (tabIndex == 0) ...[
                          if (state.hosted.isEmpty)
                            ActivityEmptyState(
                              title: loc.emptyHostedTitle,
                              message: loc.emptyHostedDesc,
                              actionText: loc.generateActivity,
                              onAction: () => context.push(AppRoutes.create),
                            )
                          else
                            ActivitiesListSection(
                              activities: state.hosted,
                              horizontalPadding: Dimensions.r16.dynamicW,
                            ),
                        ] else if (tabIndex == 1) ...[
                          if (state.joined.isEmpty)
                            ActivityEmptyState(
                              title: loc.emptyJoinedTitle,
                              message: loc.emptyJoinedDesc,
                              actionText: loc.exploreActivitiesAction,
                              onAction: () => context.go(AppRoutes.explore),
                            )
                          else
                            ActivitiesListSection(
                              activities: state.joined,
                              horizontalPadding: Dimensions.r16.dynamicW,
                            ),
                        ] else ...[
                          SliverToBoxAdapter(
                            child: RequestsTabSection(
                              receivedRequests: state.receivedRequests,
                              sentRequests: state.sentRequests,
                              horizontalPadding: Dimensions.r16.dynamicW,
                            ),
                          ),
                        ],
                        SliverToBoxAdapter(
                          child: SizedBox(height: Dimensions.r32.dynamicH),
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
    );
  }
}
