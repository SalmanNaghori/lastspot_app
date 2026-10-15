import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/features/chat/data/models/chat_conversation_model.dart';
import 'package:lastspot_app/features/chat/data/models/chat_message_model.dart';

void main() {
  group('ChatConversationModel', () {
    test('parses direct conversation from json correctly', () {
      final json = {
        'conversation_id': 'conv-123',
        'request_id': 'req-456',
        'chat_type': 'direct',
        'other_user_id': 'user-789',
        'other_user_name': 'Jane Doe',
        'last_message': 'Hey, are we playing today?',
        'last_message_at': '2026-10-13T10:00:00Z',
        'unread_count': 2,
      };

      final model = ChatConversationModel.fromJson(json);

      expect(model.conversationId, 'conv-123');
      expect(model.requestId, 'req-456');
      expect(model.chatType, 'direct');
      expect(model.isDirect, isTrue);
      expect(model.otherUserId, 'user-789');
      expect(model.otherUserName, 'Jane Doe');
      expect(model.lastMessage, 'Hey, are we playing today?');
      expect(model.lastMessageAt, DateTime.parse('2026-10-13T10:00:00Z'));
      expect(model.unreadCount, 2);
    });

    test('parses group conversation with null values and fallback count', () {
      final json = {
        'conversation_id': 'conv-group-1',
        'request_id': 'req-group-1',
        'activity_title': 'Weekend Football Match',
        'chat_type': 'group',
        'other_user_id': null,
        'other_user_name': null,
        'last_message': null,
        'last_message_at': null,
        'unread_count': '0',
      };

      final model = ChatConversationModel.fromJson(json);

      expect(model.conversationId, 'conv-group-1');
      expect(model.requestId, 'req-group-1');
      expect(model.activityTitle, 'Weekend Football Match');
      expect(model.chatType, 'group');
      expect(model.isDirect, isFalse);
      expect(model.otherUserId, isNull);
      expect(model.otherUserName, isNull);
      expect(model.lastMessage, isNull);
      expect(model.lastMessageAt, isNull);
      expect(model.unreadCount, 0);
    });
  });

  group('ChatMessageModel', () {
    test('parses message from json correctly', () {
      final json = {
        'id': 'msg-001',
        'conversation_id': 'conv-123',
        'sender_id': 'user-456',
        'content': 'I will be there in 10 minutes!',
        'created_at': '2026-10-13T10:15:00Z',
        'deleted_at': null,
      };

      final model = ChatMessageModel.fromJson(json);

      expect(model.id, 'msg-001');
      expect(model.conversationId, 'conv-123');
      expect(model.senderId, 'user-456');
      expect(model.content, 'I will be there in 10 minutes!');
      expect(model.createdAt, DateTime.parse('2026-10-13T10:15:00Z'));
      expect(model.deletedAt, isNull);
    });

    test('toJson serializes model correctly', () {
      final now = DateTime.now();
      final model = ChatMessageModel(
        id: 'msg-002',
        conversationId: 'conv-123',
        senderId: 'user-me',
        content: 'See you at the court!',
        createdAt: now,
      );

      final json = model.toJson();

      expect(json['id'], 'msg-002');
      expect(json['conversation_id'], 'conv-123');
      expect(json['sender_id'], 'user-me');
      expect(json['content'], 'See you at the court!');
      expect(json['created_at'], now.toIso8601String());
    });
  });
}
