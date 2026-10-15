import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/chat/presentation/widgets/chat_welcome_banner.dart';

Widget _buildWrapper(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) {
        Dimensions.init(context);
        return Scaffold(body: child);
      },
    ),
  );
}

void main() {
  group('ChatWelcomeBanner', () {
    testWidgets(
      'renders cricket welcome banner with emoji and activity title',
      (tester) async {
        await tester.pumpWidget(
          _buildWrapper(
            const ChatWelcomeBanner(activityTitle: 'Sunday Cricket Match'),
          ),
        );
        await tester.pumpAndSettle();

        // Check cricket emoji
        expect(find.text('🏏'), findsOneWidget);

        // Check title contains activity title and emoji
        expect(find.textContaining('Sunday Cricket Match'), findsOneWidget);

        // Check informational coordination message
        expect(
          find.textContaining('coordinating the activity'),
          findsOneWidget,
        );

        // Check lock icon
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      },
    );

    testWidgets('renders football welcome banner with soccer emoji', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildWrapper(
          const ChatWelcomeBanner(activityTitle: 'Night Football Tournament'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('⚽'), findsOneWidget);
      expect(find.textContaining('Night Football Tournament'), findsOneWidget);
    });

    testWidgets('renders fallback trophy emoji when category unknown', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildWrapper(
          const ChatWelcomeBanner(activityTitle: 'Board Games Evening'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('🏆'), findsOneWidget);
      expect(find.textContaining('Board Games Evening'), findsOneWidget);
    });
  });
}
