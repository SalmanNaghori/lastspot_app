import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/utils/result.dart';
import 'package:lastspot_app/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:lastspot_app/features/chat/domain/usecases/get_my_conversations_usecase.dart';
import 'package:lastspot_app/features/chat/presentation/bloc/conversations_cubit.dart';
import 'package:lastspot_app/features/chat/presentation/pages/conversations_tab_view.dart';

class _FakeGetMyConversationsUseCase extends Fake
    implements GetMyConversationsUseCase {
  final List<ChatConversationEntity> conversations;

  _FakeGetMyConversationsUseCase(this.conversations);

  @override
  Future<Result<List<ChatConversationEntity>, Exception>> call() async {
    return Success(conversations);
  }
}

Widget _buildWrapper({required ConversationsCubit cubit}) {
  return BlocProvider<ConversationsCubit>.value(
    value: cubit,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          Dimensions.init(context);
          return const Scaffold(body: ConversationsTabView());
        },
      ),
    ),
  );
}

void main() {
  final testDirectConversation = ChatConversationEntity(
    conversationId: 'conv-direct-1',
    requestId: 'req-1',
    chatType: 'direct',
    otherUserName: 'Rahul Dravid',
    lastMessage: 'Are we on for tomorrow?',
    lastMessageAt: DateTime(2026, 10, 14, 10, 0),
    unreadCount: 2,
  );

  final testGroupConversation = ChatConversationEntity(
    conversationId: 'conv-group-1',
    requestId: 'req-2',
    chatType: 'group',
    activityTitle: 'Weekend Cricket League',
    lastMessage: 'Match is confirmed!',
    lastMessageAt: DateTime(2026, 10, 14, 11, 0),
    unreadCount: 0,
  );

  group('ConversationsTabView Filter Chips', () {
    testWidgets('shows All, Direct, and Groups filter chips with counts', (
      tester,
    ) async {
      final cubit = ConversationsCubit(
        getMyConversationsUseCase: _FakeGetMyConversationsUseCase([
          testDirectConversation,
          testGroupConversation,
        ]),
      );

      await tester.pumpWidget(_buildWrapper(cubit: cubit));
      await tester.pumpAndSettle();

      // Check chips exist
      expect(find.text('All (2)'), findsOneWidget);
      expect(find.text('Direct (1)'), findsOneWidget);
      expect(find.text('Groups (1)'), findsOneWidget);

      // In All tab, both conversations appear
      expect(find.text('Rahul Dravid'), findsOneWidget);
      expect(find.text('Weekend Cricket League'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('filtering by Direct shows only direct conversations', (
      tester,
    ) async {
      final cubit = ConversationsCubit(
        getMyConversationsUseCase: _FakeGetMyConversationsUseCase([
          testDirectConversation,
          testGroupConversation,
        ]),
      );

      await tester.pumpWidget(_buildWrapper(cubit: cubit));
      await tester.pumpAndSettle();

      // Tap on Direct filter chip
      await tester.tap(find.text('Direct (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Rahul Dravid'), findsOneWidget);
      expect(find.text('Weekend Cricket League'), findsNothing);

      await cubit.close();
    });

    testWidgets('filtering by Groups shows only group conversations', (
      tester,
    ) async {
      final cubit = ConversationsCubit(
        getMyConversationsUseCase: _FakeGetMyConversationsUseCase([
          testDirectConversation,
          testGroupConversation,
        ]),
      );

      await tester.pumpWidget(_buildWrapper(cubit: cubit));
      await tester.pumpAndSettle();

      // Tap on Groups filter chip
      await tester.tap(find.text('Groups (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Rahul Dravid'), findsNothing);
      expect(find.text('Weekend Cricket League'), findsOneWidget);

      await cubit.close();
    });
  });
}
