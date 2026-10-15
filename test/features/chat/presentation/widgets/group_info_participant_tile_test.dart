import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/auth/domain/entities/user_profile.dart';
import 'package:lastspot_app/features/chat/presentation/widgets/group_info_participant_tile.dart';

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
  group('GroupInfoParticipantTile', () {
    testWidgets('renders host participant with organizer badge', (
      tester,
    ) async {
      final hostProfile = UserProfile(
        id: 'host-123',
        email: 'host@lastspot.app',
        fullName: 'Rohit Sharma',
        createdAt: DateTime(2026, 1, 1),
      );

      await tester.pumpWidget(
        _buildWrapper(
          GroupInfoParticipantTile(
            profile: hostProfile,
            isHost: true,
            isCurrentUser: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rohit Sharma'), findsOneWidget);
      expect(find.text('Host'), findsOneWidget);
      expect(find.text('Organizer'), findsOneWidget);
      expect(find.text('R'), findsOneWidget); // Initial in avatar
    });

    testWidgets('renders current user tag and joined status', (tester) async {
      final memberProfile = UserProfile(
        id: 'user-456',
        email: 'user@lastspot.app',
        fullName: 'Virat Kohli',
        createdAt: DateTime(2026, 1, 1),
      );

      await tester.pumpWidget(
        _buildWrapper(
          GroupInfoParticipantTile(
            profile: memberProfile,
            isHost: false,
            isCurrentUser: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Virat Kohli'), findsOneWidget);
      expect(find.text('(You)'), findsOneWidget);
      expect(find.text('Joined'), findsOneWidget);
      expect(find.text('ORGANIZER'), findsNothing);
    });
  });
}
