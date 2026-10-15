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
    return list
        .map(
          (item) =>
              ChatConversationModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
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
}
