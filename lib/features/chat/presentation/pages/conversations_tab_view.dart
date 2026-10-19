import '../../../../core/base_import.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import '../bloc/conversations_cubit.dart';
import '../bloc/conversations_state.dart';
import '../widgets/conversation_tile.dart';
import '../../../../core/services/in_app_feedback_manager.dart';

class ConversationsTabView extends StatefulWidget {
  const ConversationsTabView({super.key});

  @override
  State<ConversationsTabView> createState() => _ConversationsTabViewState();
}

class _ConversationsTabViewState extends State<ConversationsTabView> {
  final ValueNotifier<int> _filterNotifier = ValueNotifier<int>(0);
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    context.read<ConversationsCubit>().loadConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchNotifier.dispose();
    _filterNotifier.dispose();
    super.dispose();
  }

  void _onConversationTap(ChatConversationEntity conversation) {
    final title = conversation.displayTitle ?? '';
    final feedback = context.read<InAppFeedbackManager>();
    feedback.clearTransient();
    feedback.dismissConversation(conversation.conversationId);
    context.read<ConversationsCubit>().markConversationReadLocally(
      conversation.conversationId,
    );
    context
        .push(
          AppRoutes.conversationChatPath(
            conversation.conversationId,
            isDirect: conversation.isDirect,
            name: title,
            avatarUrl: conversation.displayAvatarUrl,
            category: conversation.categoryOrActivity,
            activityTitle:
                conversation.getDirectActivitySubtitle(
                  fallbackActivityLabel: context.loc.activity,
                ) ??
                conversation.activityTitle,
            requestId: conversation.requestId,
          ),
        )
        .then((_) {
          if (mounted) {
            context.read<ConversationsCubit>().loadConversations(
              isRefresh: true,
            );
          }
        });
  }

  void _onRetry() {
    context.read<ConversationsCubit>().loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final loc = context.loc;

    return BlocBuilder<ConversationsCubit, ConversationsState>(
      builder: (context, state) {
        if (state is ConversationsLoading) {
          return const Center(child: AppLoading());
        }

        if (state is ConversationsError) {
          return Center(
            child: AppErrorState(
              message: loc.conversationLoadError,
              isNetwork: state.isNetworkError,
              onRetry: _onRetry,
            ),
          );
        }

        if (state is ConversationsLoaded) {
          final all = state.conversations;
          final direct = all.where((c) => c.isDirect).toList();
          final groups = all.where((c) => !c.isDirect).toList();

          return AnimatedBuilder(
            animation: Listenable.merge([_filterNotifier, _searchNotifier]),
            builder: (context, _) {
              final filterIndex = _filterNotifier.value;
              final searchQuery = _searchNotifier.value.trim().toLowerCase();

              final filterTabList = switch (filterIndex) {
                1 => direct,
                2 => groups,
                _ => all,
              };

              final displayedList = searchQuery.isEmpty
                  ? filterTabList
                  : filterTabList
                        .where((c) => c.matchesSearch(searchQuery))
                        .toList();

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      Dimensions.r16.dynamicW,
                      Dimensions.r8.dynamicH,
                      Dimensions.r16.dynamicW,
                      Dimensions.r4.dynamicH,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: loc.searchConversations,
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _searchNotifier.value = '';
                                },
                              )
                            : null,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.r16.dynamicW,
                          vertical: Dimensions.r8.dynamicH,
                        ),
                        filled: true,
                        fillColor: colors.surfaceContainerHighest.withValues(
                          alpha: 0.4,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.r12.dynamicR,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => _searchNotifier.value = val,
                    ),
                  ),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.r16.dynamicW,
                      vertical: Dimensions.r8.dynamicH,
                    ),
                    child: Row(
                      children: [
                        FilterChip(
                          label: Text(
                            all.isNotEmpty
                                ? '${loc.filterAll} (${all.length})'
                                : loc.filterAll,
                          ),
                          selected: filterIndex == 0,
                          onSelected: (_) => _filterNotifier.value = 0,
                        ),
                        SizedBox(width: Dimensions.r8.dynamicW),
                        FilterChip(
                          label: Text(
                            direct.isNotEmpty
                                ? '${loc.filterDirect} (${direct.length})'
                                : loc.filterDirect,
                          ),
                          selected: filterIndex == 1,
                          onSelected: (_) => _filterNotifier.value = 1,
                        ),
                        SizedBox(width: Dimensions.r8.dynamicW),
                        FilterChip(
                          label: Text(
                            groups.isNotEmpty
                                ? '${loc.filterGroups} (${groups.length})'
                                : loc.filterGroups,
                          ),
                          selected: filterIndex == 2,
                          onSelected: (_) => _filterNotifier.value = 2,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: colors.outlineVariant.withValues(alpha: 0.3),
                  ),

                  if (displayedList.isEmpty && searchQuery.isNotEmpty)
                    Center(
                      child: AppEmptyState.search(
                        title: loc.noConversationsFound,
                        message: loc.noConversationsFoundDesc,
                      ),
                    )
                  else if (displayedList.isEmpty)
                    Center(
                      child: AppEmptyState.chats(
                        title: filterIndex == 1
                            ? loc.noDirectConversations
                            : (filterIndex == 2
                                  ? loc.noGroupConversations
                                  : loc.noConversations),
                        message: filterIndex == 1
                            ? loc.noDirectConversationsDesc
                            : (filterIndex == 2
                                  ? loc.noGroupConversationsDesc
                                  : loc.noConversationsDesc),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedList.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        indent: Dimensions.w(72),
                        color: colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                      itemBuilder: (context, index) {
                        final conversation = displayedList[index];
                        return ConversationTile(
                          key: ValueKey(conversation.conversationId),
                          conversation: conversation,
                          onTap: () => _onConversationTap(conversation),
                        );
                      },
                    ),
                ],
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
