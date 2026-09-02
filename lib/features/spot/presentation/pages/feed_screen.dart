import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lastspot_app/core/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/dimensions.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _currentIndex = 0;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(LoadFeedEvent());
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? null : category;
    });
    context.read<FeedBloc>().add(LoadFeedEvent(category: _selectedCategory));
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {})],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW, vertical: Dimensions.r8.dynamicH),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: context.surfaceColor,
                contentPadding: EdgeInsets.symmetric(vertical: Dimensions.r12.dynamicH),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                  borderSide: BorderSide(color: context.borderColor),
                ),
              ),
            ),
          ),

          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW, vertical: Dimensions.r8.dynamicH),
            child: Row(
              children: [
                _CategoryPill(
                  title: '🏏 Cricket',
                  isSelected: _selectedCategory == 'Cricket',
                  onTap: () => _onCategorySelected('Cricket'),
                ),
                SizedBox(width: Dimensions.r8.dynamicW),
                _CategoryPill(
                  title: '⚽ Football',
                  isSelected: _selectedCategory == 'Football',
                  onTap: () => _onCategorySelected('Football'),
                ),
                SizedBox(width: Dimensions.r8.dynamicW),
                _CategoryPill(
                  title: '🏸 Badminton',
                  isSelected: _selectedCategory == 'Badminton',
                  onTap: () => _onCategorySelected('Badminton'),
                ),
              ],
            ),
          ),

          // Feed Content
          Expanded(
            child: BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FeedError) {
                  return Center(
                    child: Text(state.message, style: TextStyle(color: AppColor.errorColor)),
                  );
                } else if (state is FeedLoaded) {
                  if (state.posts.isEmpty) {
                    return Center(child: Text('No active spots found.'));
                  }

                  final urgentPosts = state.posts
                      .where((p) => p.matchTime.difference(DateTime.now()).inHours < 24)
                      .toList();
                  final recentPosts = state.posts.where((p) => !urgentPosts.contains(p)).toList();

                  return ListView(
                    padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                    children: [
                      if (urgentPosts.isNotEmpty) ...[
                        Text(
                          l10n.urgentMatches,
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: context.textSecondary),
                        ),
                        SizedBox(height: Dimensions.r12.dynamicH),
                        ...urgentPosts.map(
                          (post) => PostCard(
                            post: post,
                            onTap: () => context.push('/spot/${post.id}'),
                            onMapTap: () {
                              if (post.googleMapsUrl != null) {
                                _launchMap(post.googleMapsUrl!);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: Dimensions.r16.dynamicH),
                      ],

                      if (recentPosts.isNotEmpty) ...[
                        Text(
                          l10n.recentPosts,
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: context.textSecondary),
                        ),
                        SizedBox(height: Dimensions.r12.dynamicH),
                        ...recentPosts.map(
                          (post) => PostCard(
                            post: post,
                            onTap: () => context.push('/spot/${post.id}'),
                            onMapTap: () {
                              if (post.googleMapsUrl != null) {
                                _launchMap(post.googleMapsUrl!);
                              }
                            },
                          ),
                        ),
                      ],
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/create-spot');
          if (context.mounted) {
            context.read<FeedBloc>().add(LoadFeedEvent());
          }
        },
        backgroundColor: AppColor.primaryColor,
        child: const Icon(Icons.add, color: AppColor.whiteColor),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: context.textSecondary,
        backgroundColor: context.surfaceColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: l10n.homeTab),
          BottomNavigationBarItem(icon: Icon(Icons.sports), label: l10n.myMatchesTab),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: l10n.profileTab),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryPill({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW, vertical: Dimensions.r8.dynamicH),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
          border: Border.all(color: isSelected ? AppColor.primaryColor : context.borderColor),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColor.whiteColor : context.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
