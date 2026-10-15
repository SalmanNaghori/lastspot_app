import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/base_import.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/chat_cubit.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_composer_bar.dart';
import '../widgets/chat_date_chip.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_welcome_banner.dart';
import '../widgets/jump_to_bottom_button.dart';

class ChatScreenMobile extends StatefulWidget {
  const ChatScreenMobile({super.key});

  @override
  State<ChatScreenMobile> createState() => _ChatScreenMobileState();
}

class _ChatScreenMobileState extends State<ChatScreenMobile> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showJumpButton = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasNewMessage = ValueNotifier<bool>(false);
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final isScrolledUp = position.pixels > 240;
    if (_showJumpButton.value != isScrolledUp) {
      _showJumpButton.value = isScrolledUp;
    }
    if (position.pixels > 240 &&
        position.pixels >= position.maxScrollExtent - 160) {
      unawaited(context.read<ChatCubit>().loadOlderMessages());
    }
    if (!isScrolledUp && _hasNewMessage.value) {
      _hasNewMessage.value = false;
    }
  }

  void _jumpToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    _hasNewMessage.value = false;
  }

  void _onBack() {
    context.pop();
  }

  void _onRetry() {
    context.read<ChatCubit>().retry();
  }

  Future<bool> _onSendMessage(String text) async {
    final success = await context.read<ChatCubit>().sendMessage(text);
    if (!success && mounted) {
      AppUtils.showSnackBar(
        context,
        context.loc.noInternetError,
        isError: true,
      );
    } else if (success && _scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
    return success;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _showJumpButton.dispose();
    _hasNewMessage.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    final la = a.toLocal();
    final lb = b.toLocal();
    return la.year == lb.year && la.month == lb.month && la.day == lb.day;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded) {
          if (_lastMessageCount > 0 &&
              state.messages.length > _lastMessageCount) {
            if (_showJumpButton.value) {
              _hasNewMessage.value = true;
            } else if (_scrollController.hasClients) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              );
            }
          }
          _lastMessageCount = state.messages.length;
        }
      },
      builder: (context, state) {
        final title = switch (state) {
          ChatLoaded(:final title) => title,
          _ => context.loc.groupChat,
        };

        final isDirect = switch (state) {
          ChatLoaded(:final isDirect) => isDirect,
          _ => false,
        };

        final subtitle = switch (state) {
          ChatLoaded(:final subtitle) => subtitle,
          _ => null,
        };

        final requestId = switch (state) {
          ChatLoaded(:final requestId) => requestId,
          _ => null,
        };

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: ChatAppBar(
            title: title,
            subtitle: subtitle,
            isDirect: isDirect,
            onBack: _onBack,
            onGroupInfoTap: (!isDirect && requestId != null)
                ? () => context.push(AppRoutes.groupInfoPath(requestId))
                : null,
          ),
          body: Column(
            children: [
              Expanded(
                child: currentUserId == null
                    ? Center(
                        child: Text(
                          context.loc.signInToChat,
                          style: context.bodyLarge,
                        ),
                      )
                    : switch (state) {
                        ChatLoading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        ChatError(:final message, :final isNetworkError) =>
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isNetworkError
                                        ? Icons.wifi_off
                                        : Icons.error_outline,
                                    size: Dimensions.r48.dynamicH,
                                    color: colors.error,
                                  ),
                                  SizedBox(height: Dimensions.r16.dynamicH),
                                  Text(
                                    message,
                                    textAlign: TextAlign.center,
                                    style: context.bodyMedium?.copyWith(
                                      color: colors.error,
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.r16.dynamicH),
                                  FilledButton(
                                    onPressed: _onRetry,
                                    child: Text(context.loc.retry),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ChatLoaded(:final messages, :final isLoadingOlder) =>
                          messages.isEmpty
                              ? (!isDirect
                                    ? Center(
                                        child: SingleChildScrollView(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: AppSpacing.xl,
                                          ),
                                          child: ChatWelcomeBanner(
                                            activityTitle: title,
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            AppSpacing.xl,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.chat_bubble_outline,
                                                size: Dimensions.r48.dynamicH,
                                                color: colors.onSurfaceVariant,
                                              ),
                                              SizedBox(
                                                height: Dimensions.r16.dynamicH,
                                              ),
                                              Text(
                                                context.loc.chatEmpty,
                                                textAlign: TextAlign.center,
                                                style: context.bodyMedium
                                                    ?.copyWith(
                                                      color: colors
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                              : Stack(
                                  children: [
                                    ListView.builder(
                                      controller: _scrollController,
                                      reverse: true,
                                      padding: const EdgeInsets.only(
                                        top: AppSpacing.md,
                                        bottom: AppSpacing.sm,
                                      ),
                                      itemCount:
                                          messages.length + (!isDirect ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        // Top of reverse list (oldest item) = Welcome Banner in group chat
                                        if (!isDirect &&
                                            index == messages.length) {
                                          return ChatWelcomeBanner(
                                            activityTitle: title,
                                          );
                                        }

                                        final chronoIndex =
                                            messages.length - 1 - index;
                                        final message = messages[chronoIndex];

                                        final ChatMessageEntity? prevMessage =
                                            chronoIndex > 0
                                            ? messages[chronoIndex - 1]
                                            : null;

                                        final isFirstMessageOfDay =
                                            prevMessage == null ||
                                            !_isSameDay(
                                              prevMessage.createdAt,
                                              message.createdAt,
                                            );

                                        final isFirstInStreak =
                                            prevMessage == null ||
                                            prevMessage.senderId !=
                                                message.senderId ||
                                            !_isSameDay(
                                              prevMessage.createdAt,
                                              message.createdAt,
                                            ) ||
                                            message.createdAt
                                                    .difference(
                                                      prevMessage.createdAt,
                                                    )
                                                    .inMinutes >=
                                                5;

                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isFirstMessageOfDay)
                                              ChatDateChip(
                                                date: message.createdAt,
                                              ),
                                            ChatMessageBubble(
                                              message: message,
                                              isMine:
                                                  message.senderId ==
                                                  currentUserId,
                                              isGroup: !isDirect,
                                              isFirstInStreak: isFirstInStreak,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    if (isLoadingOlder)
                                      Positioned(
                                        top: AppSpacing.sm,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: SizedBox.square(
                                            dimension: Dimensions.r20.dynamicH,
                                            child:
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ValueListenableBuilder<bool>(
                                      valueListenable: _showJumpButton,
                                      builder: (context, isVisible, _) {
                                        return ValueListenableBuilder<bool>(
                                          valueListenable: _hasNewMessage,
                                          builder: (context, hasNew, _) {
                                            return JumpToBottomButton(
                                              isVisible: isVisible,
                                              hasNewMessage: hasNew,
                                              onTap: _jumpToBottom,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                        _ => const SizedBox.shrink(),
                      },
              ),
              ChatComposerBar(
                isSending: state is ChatLoaded && state.isSending,
                onSend: _onSendMessage,
              ),
            ],
          ),
        );
      },
    );
  }
}
