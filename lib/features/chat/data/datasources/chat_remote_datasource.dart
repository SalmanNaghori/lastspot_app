import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../models/chat_conversation_model.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<String> getOrCreateDirectChat(String requestId);
  Future<String> getOrCreateGroupChat(String requestId);
  Future<List<ChatConversationModel>> getMyConversations();
  Future<List<ChatMessageModel>> getMessages(
    String conversationId, {
    ChatMessageEntity? before,
    int limit = 50,
  });
  Future<ChatMessageModel> sendMessage({
    required String conversationId,
    required String content,
  });
  Future<void> markAsRead(String conversationId);
  Stream<ChatMessageModel> streamMessages(String conversationId);
  Stream<ChatMessageModel> streamUserMessages();
}

class SupabaseChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient _client;

  SupabaseChatRemoteDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<String> getOrCreateDirectChat(String requestId) async {
    final result = await _client.rpc(
      'get_or_create_direct_chat',
      params: {'p_request_id': requestId},
    );
    if (result == null) {
      throw const PostgrestException(
        message: 'Failed to create or get direct chat',
      );
    }
    return result.toString();
  }

  @override
  Future<String> getOrCreateGroupChat(String requestId) async {
    final result = await _client.rpc(
      'get_or_create_group_chat',
      params: {'p_request_id': requestId},
    );
    if (result == null) {
      throw const PostgrestException(
        message: 'Failed to create or get group chat',
      );
    }
    return result.toString();
  }

  @override
  Future<List<ChatConversationModel>> getMyConversations() async {
    final result = await _client.rpc('get_my_chat_conversations');
    final list = (result as List<dynamic>?) ?? [];
    if (list.isEmpty) return [];
    final conversations = list
        .map(
          (item) =>
              ChatConversationModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    // Collect other_user_ids missing avatar for direct chats
    final otherUserIds = conversations
        .where(
          (item) =>
              item.isDirect &&
              item.otherUserAvatarUrl?.trim().isNotEmpty != true,
        )
        .map((item) => item.otherUserId)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final Map<String, String?> avatars = {};
    if (otherUserIds.isNotEmpty) {
      try {
        final profiles = await _client
            .from('profiles')
            .select('id, avatar_url')
            .inFilter('id', otherUserIds);
        for (final p in profiles as List<dynamic>) {
          final id = p['id']?.toString();
          final avatar = p['avatar_url']?.toString();
          if (id != null) avatars[id] = avatar;
        }
      } catch (_) {}
    }

    // Collect request_ids to enrich (missing activity_title or category details)
    final requestIdsToEnrich = conversations
        .where((item) {
          if (item.requestId.isEmpty) return false;
          final hasCategory =
              item.categorySlug != null || item.categoryId != null;
          return item.activityTitle?.trim().isNotEmpty != true ||
              (!item.isDirect && !hasCategory);
        })
        .map((item) => item.requestId)
        .toSet()
        .toList();

    final Map<
      String,
      ({String? title, String? categoryId, String? categorySlug})
    >
    requestDetails = {};
    if (requestIdsToEnrich.isNotEmpty) {
      try {
        final reqs = await _client
            .from('requests')
            .select(
              'id, title, category_id, categories:category_id(id, name, slug)',
            )
            .inFilter('id', requestIdsToEnrich);
        for (final r in reqs as List<dynamic>) {
          final id = r['id']?.toString();
          final title = r['title']?.toString();
          final catId = r['category_id']?.toString();
          final cat = r['categories'] as Map<String, dynamic>?;
          final slug = cat?['slug']?.toString() ?? cat?['name']?.toString();
          if (id != null) {
            requestDetails[id] = (
              title: title,
              categoryId: catId,
              categorySlug: slug,
            );
          }
        }
      } catch (_) {}
    }

    return conversations.map((item) {
      final details = requestDetails[item.requestId];
      return item.copyWith(
        activityTitle: item.activityTitle?.trim().isNotEmpty == true
            ? item.activityTitle
            : details?.title,
        otherUserAvatarUrl: item.otherUserAvatarUrl?.trim().isNotEmpty == true
            ? item.otherUserAvatarUrl
            : avatars[item.otherUserId],
        categoryId: item.categoryId ?? details?.categoryId,
        categorySlug: item.categorySlug ?? details?.categorySlug,
      );
    }).toList();
  }

  @override
  Future<List<ChatMessageModel>> getMessages(
    String conversationId, {
    ChatMessageEntity? before,
    int limit = 50,
  }) async {
    var query = _client
        .from('chat_messages')
        .select()
        .eq('conversation_id', conversationId)
        .filter('deleted_at', 'is', null);

    if (before != null) {
      final timestamp = before.createdAt.toUtc().toIso8601String();
      query = query.or(
        'created_at.lt.$timestamp,and(created_at.eq.$timestamp,id.lt.${before.id})',
      );
    }

    final response = await query
        .order('created_at', ascending: false)
        .order('id', ascending: false)
        .limit(limit + 1);

    final list = (response as List<dynamic>?) ?? [];
    final senderIds = list
        .map((m) => m['sender_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    final Map<String, String> senderNames = {};
    if (senderIds.isNotEmpty) {
      try {
        final profiles = await _client
            .from('profiles')
            .select('id, full_name')
            .inFilter('id', senderIds);
        for (final p in profiles as List<dynamic>) {
          final id = p['id']?.toString();
          final name = p['full_name']?.toString();
          if (id != null && name != null) {
            senderNames[id] = name;
          }
        }
      } catch (_) {
        // Fallback gracefully without names
      }
    }

    final messages = list.map((m) {
      final map = m as Map<String, dynamic>;
      final senderId = map['sender_id']?.toString() ?? '';
      return ChatMessageModel.fromJson(map, senderName: senderNames[senderId]);
    }).toList();
    return messages.reversed.toList();
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException('User not authenticated');
    }

    final response = await _client
        .from('chat_messages')
        .insert({
          'conversation_id': conversationId,
          'sender_id': userId,
          'content': content,
        })
        .select()
        .single();

    return ChatMessageModel.fromJson(response);
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    try {
      await _client.rpc(
        'mark_chat_as_read',
        params: {'p_conversation_id': conversationId},
      );
    } catch (_) {
      // Best-effort read receipt
    }
  }

  @override
  Stream<ChatMessageModel> streamMessages(String conversationId) {
    late final StreamController<ChatMessageModel> controller;
    RealtimeChannel? channel;

    controller = StreamController<ChatMessageModel>.broadcast(
      onListen: () {
        channel = _client.channel('realtime:chat_messages:$conversationId');
        channel!
            .onPostgresChanges(
              event: PostgresChangeEvent.insert,
              schema: 'public',
              table: 'chat_messages',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'conversation_id',
                value: conversationId,
              ),
              callback: (payload) async {
                final record = payload.newRecord;
                if (record.isEmpty || record['deleted_at'] != null) return;
                String? senderName;
                try {
                  final senderId = record['sender_id'] as String?;
                  if (senderId != null) {
                    final profile = await _client
                        .from('profiles')
                        .select('full_name')
                        .eq('id', senderId)
                        .maybeSingle();
                    senderName = profile?['full_name'] as String?;
                  }
                } catch (_) {
                  // Profile names are optional; the message remains readable.
                }
                final model = ChatMessageModel.fromJson(
                  record,
                  senderName: senderName,
                );
                if (!controller.isClosed) {
                  controller.add(model);
                }
              },
            )
            .subscribe();
      },
      onCancel: () {
        if (channel != null) {
          channel!.unsubscribe();
          _client.removeChannel(channel!);
        }
      },
    );

    return controller.stream;
  }

  @override
  Stream<ChatMessageModel> streamUserMessages() {
    late final StreamController<ChatMessageModel> controller;
    RealtimeChannel? channel;

    controller = StreamController<ChatMessageModel>.broadcast(
      onListen: () {
        final channelName =
            'realtime:all_user_messages:${DateTime.now().millisecondsSinceEpoch}';
        channel = _client.channel(channelName);
        channel!
            .onPostgresChanges(
              event: PostgresChangeEvent.insert,
              schema: 'public',
              table: 'chat_messages',
              callback: (payload) async {
                final record = payload.newRecord;
                if (record.isEmpty || record['deleted_at'] != null) return;
                try {
                  final model = ChatMessageModel.fromJson(record);
                  if (!controller.isClosed) {
                    controller.add(model);
                  }
                } catch (_) {}
              },
            )
            .subscribe();
      },
      onCancel: () {
        if (channel != null) {
          channel!.unsubscribe();
          _client.removeChannel(channel!);
        }
      },
    );

    return controller.stream;
  }
}
