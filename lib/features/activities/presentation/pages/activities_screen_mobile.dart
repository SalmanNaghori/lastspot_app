import 'package:lastspot_app/core/base_import.dart';

import '../widgets/activities_tab_bar.dart';
import '../widgets/compact_activity_card.dart';
import '../widgets/tab_preview_row.dart';
import 'package:lastspot_app/core/widgets/custom_app_bar.dart';

class ActivitiesScreenMobile extends StatefulWidget {
  const ActivitiesScreenMobile({super.key});

  @override
  State<ActivitiesScreenMobile> createState() => _ActivitiesScreenMobileState();
}

class _ActivitiesScreenMobileState extends State<ActivitiesScreenMobile> {
  int _selectedTab = 0;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r16.dynamicW,
                vertical: Dimensions.r12.dynamicH,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActivitiesTabBar(
                    selectedIndex: _selectedTab,
                    onTabChanged: (index) {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                    tab1Label: loc.tabMyActivitiesCount('4'),
                    tab2Label: loc.tabJoinedCount('2'),
                    tab3Label: loc.tabRequestsCount('3'),
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
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.r16.dynamicW,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (_selectedTab == 0) {
                            return _buildMyActivities()[index];
                          } else if (_selectedTab == 1) {
                            return Center(child: Text('Joined content here'));
                          } else {
                            return Center(child: Text('Requests content here'));
                          }
                        },
                        childCount: _selectedTab == 0
                            ? _buildMyActivities().length
                            : 1,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Dimensions.r24.dynamicH),
                          Text(
                            loc.tabPreviewData,
                            style: context.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: Dimensions.r12.dynamicH),
                          TabPreviewRow(text: loc.previewJoined),
                          SizedBox(height: Dimensions.r8.dynamicH),
                          TabPreviewRow(text: loc.previewRequests),
                          SizedBox(
                            height: Dimensions.r32.dynamicH,
                          ), // extra padding for bottom navigation
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMyActivities() {
    final loc = context.loc;
    return [
      CompactActivityCard(
        title: loc.mockGoldenGateTitle,
        date: loc.mockGoldenGateDate,
        location: loc.mockGoldenGateLoc,
        stats: loc.mockGoldenGateStats,
        status: loc.statusHosted,
        onTap: () {},
      ),
      SizedBox(height: Dimensions.r16.dynamicH),
      CompactActivityCard(
        title: loc.mockSunsetVolleyballTitle,
        date: loc.mockSunsetVolleyballDate,
        location: loc.mockSunsetVolleyballLoc,
        stats: loc.mockGoldenGateStats,
        status: loc.statusHosted,
        onTap: () {},
      ),
      SizedBox(height: Dimensions.r16.dynamicH),
      CompactActivityCard(
        title: loc.mockRooftopCookingTitle,
        date: loc.mockRooftopCookingDate,
        location: loc.mockRooftopCookingLoc,
        stats: loc.mockRooftopCookingStats,
        status: loc.statusFull,
        isFull: true,
        onTap: () {},
      ),
      SizedBox(height: Dimensions.r16.dynamicH),
      CompactActivityCard(
        title: loc.mockSalsaTitle,
        date: loc.mockSalsaDate,
        location: loc.mockSalsaLoc,
        stats: loc.mockSalsaStats,
        status: loc.statusHosted,
        onTap: () {},
      ),
    ];
  }
}
