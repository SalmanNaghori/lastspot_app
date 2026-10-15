import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/chat/domain/entities/chat_message_entity.dart';
import 'package:lastspot_app/features/chat/presentation/widgets/chat_message_bubble.dart';

Widget _buildWrapper(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final testDate = DateTime(2026, 10, 13, 14, 30);
  String? mockClipboardText;

  setUp(() {
    mockClipboardText = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'Clipboard.setData') {
            mockClipboardText =
                (methodCall.arguments as Map)['text'] as String?;
            return null;
          } else if (methodCall.method == 'Clipboard.getData') {
            return <String, dynamic>{'text': mockClipboardText};
          } else if (methodCall.method == 'HapticFeedback.vibrate') {
            return null;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('ChatMessageBubble - Direct Chat', () {
    testWidgets('renders outgoing message right-aligned without sender name', (
      tester,
    ) async {
      final message = ChatMessageEntity(
        id: 'msg-direct-1',
        conversationId: 'conv-direct-1',
        senderId: 'user-me',
        senderName: 'Me',
        content: 'Hello *everyone*! Welcome to _LastSpot_ 🏏',
        createdAt: testDate,
      );

      await tester.pumpWidget(
        _buildWrapper(
          ChatMessageBubble(message: message, isMine: true, isGroup: false),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure sender name is NOT displayed in direct chat
      expect(find.text('Me'), findsNothing);

      // Verify Align is right-aligned
      final alignFinder = find.byType(Align).first;
      final alignWidget = tester.widget<Align>(alignFinder);
      expect(alignWidget.alignment, Alignment.centerRight);

      // Verify formatted text spans exist inside SelectableText
      final selectableTextFinder = find.byType(SelectableText);
      expect(selectableTextFinder, findsOneWidget);
      final selectableWidget = tester.widget<SelectableText>(
        selectableTextFinder,
      );
      final textSpan = selectableWidget.textSpan!;
      final textContent = textSpan.toPlainText();

      expect(textContent, contains('Hello everyone! Welcome to LastSpot 🏏'));

      // Check bold span for 'everyone'
      bool hasBold = false;
      bool hasItalic = false;
      textSpan.visitChildren((span) {
        if (span is TextSpan) {
          if (span.text == 'everyone' &&
              span.style?.fontWeight == FontWeight.bold) {
            hasBold = true;
          }
          if (span.text == 'LastSpot' &&
              span.style?.fontStyle == FontStyle.italic) {
            hasItalic = true;
          }
        }
        return true;
      });

      expect(hasBold, isTrue);
      expect(hasItalic, isTrue);
    });

    testWidgets(
      'renders incoming direct message left-aligned without sender name',
      (tester) async {
        final message = ChatMessageEntity(
          id: 'msg-direct-2',
          conversationId: 'conv-direct-1',
          senderId: 'user-other',
          senderName: 'Alice',
          content: 'See you at *7 PM*!',
          createdAt: testDate,
        );

        await tester.pumpWidget(
          _buildWrapper(
            ChatMessageBubble(message: message, isMine: false, isGroup: false),
          ),
        );
        await tester.pumpAndSettle();

        // In direct chat, sender name is hidden
        expect(find.text('Alice'), findsNothing);

        // Verify Align is left-aligned
        final alignFinder = find.byType(Align).first;
        final alignWidget = tester.widget<Align>(alignFinder);
        expect(alignWidget.alignment, Alignment.centerLeft);
      },
    );
  });

  group('ChatMessageBubble - Group Chat', () {
    testWidgets(
      'renders incoming group message with sender name when first in streak',
      (tester) async {
        final message = ChatMessageEntity(
          id: 'msg-group-1',
          conversationId: 'conv-group-1',
          senderId: 'user-bob',
          senderName: 'Bob Builder',
          content: 'Hello *everyone*! Welcome to _LastSpot_ 🏏',
          createdAt: testDate,
        );

        await tester.pumpWidget(
          _buildWrapper(
            ChatMessageBubble(
              message: message,
              isMine: false,
              isGroup: true,
              isFirstInStreak: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // In group chat, incoming message displays sender name
        expect(find.text('Bob Builder'), findsOneWidget);

        // Verify left alignment
        final alignFinder = find.byType(Align).first;
        final alignWidget = tester.widget<Align>(alignFinder);
        expect(alignWidget.alignment, Alignment.centerLeft);
      },
    );

    testWidgets(
      'omits sender name in consecutive group messages of same streak',
      (tester) async {
        final message = ChatMessageEntity(
          id: 'msg-group-2',
          conversationId: 'conv-group-1',
          senderId: 'user-bob',
          senderName: 'Bob Builder',
          content: 'Second message in streak',
          createdAt: testDate,
        );

        await tester.pumpWidget(
          _buildWrapper(
            ChatMessageBubble(
              message: message,
              isMine: false,
              isGroup: true,
              isFirstInStreak: false,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Suppressed for intermediate streak messages
        expect(find.text('Bob Builder'), findsNothing);
      },
    );

    testWidgets(
      'renders outgoing group message right-aligned without sender name',
      (tester) async {
        final message = ChatMessageEntity(
          id: 'msg-group-3',
          conversationId: 'conv-group-1',
          senderId: 'user-me',
          senderName: 'My Name',
          content: 'I am on my way!',
          createdAt: testDate,
        );

        await tester.pumpWidget(
          _buildWrapper(
            ChatMessageBubble(message: message, isMine: true, isGroup: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('My Name'), findsNothing);
        final alignFinder = find.byType(Align).first;
        final alignWidget = tester.widget<Align>(alignFinder);
        expect(alignWidget.alignment, Alignment.centerRight);
      },
    );
  });

  group('ChatMessageBubble - Formatting & Copy Interactions', () {
    testWidgets(
      'renders multiple formatting styles: bold, italic, strikethrough, monospace',
      (tester) async {
        final message = ChatMessageEntity(
          id: 'msg-multi-1',
          conversationId: 'conv-1',
          senderId: 'user-me',
          content: '*bold* and _italic_ and ~strike~ with `mono`',
          createdAt: testDate,
        );

        await tester.pumpWidget(
          _buildWrapper(
            ChatMessageBubble(message: message, isMine: true, isGroup: false),
          ),
        );
        await tester.pumpAndSettle();

        final selectableWidget = tester.widget<SelectableText>(
          find.byType(SelectableText),
        );
        final textSpan = selectableWidget.textSpan!;

        bool hasBold = false;
        bool hasItalic = false;
        bool hasStrike = false;
        bool hasMono = false;

        textSpan.visitChildren((span) {
          if (span is TextSpan) {
            if (span.text == 'bold' &&
                span.style?.fontWeight == FontWeight.bold) {
              hasBold = true;
            }
            if (span.text == 'italic' &&
                span.style?.fontStyle == FontStyle.italic) {
              hasItalic = true;
            }
            if (span.text == 'strike' &&
                span.style?.decoration == TextDecoration.lineThrough) {
              hasStrike = true;
            }
            if (span.text == 'mono' && span.style?.fontFamily == 'monospace') {
              hasMono = true;
            }
          }
          return true;
        });

        expect(hasBold, isTrue);
        expect(hasItalic, isTrue);
        expect(hasStrike, isTrue);
        expect(hasMono, isTrue);
      },
    );

    testWidgets('long press copies original message content to clipboard', (
      tester,
    ) async {
      const originalText = 'Hello *everyone*! Welcome to _LastSpot_ 🏏';
      final message = ChatMessageEntity(
        id: 'msg-copy-1',
        conversationId: 'conv-1',
        senderId: 'user-other',
        content: originalText,
        createdAt: testDate,
      );

      await tester.pumpWidget(
        _buildWrapper(
          ChatMessageBubble(message: message, isMine: false, isGroup: false),
        ),
      );
      await tester.pumpAndSettle();

      // Long press on the bubble
      await tester.longPress(find.byType(InkWell));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify copied snackbar appears
      expect(find.byType(SnackBar), findsOneWidget);

      // Verify clipboard content
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      expect(clipboardData?.text, originalText);

      // Clean up SnackBar timer
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
