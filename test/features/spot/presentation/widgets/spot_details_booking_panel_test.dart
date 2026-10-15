import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/join_request_entity.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';
import 'package:lastspot_app/features/spot/presentation/bloc/spot_details_bloc.dart';
import 'package:lastspot_app/features/spot/presentation/widgets/spot_details_booking_panel.dart';

class _FakeSpotDetailsBloc extends Fake implements SpotDetailsBloc {
  @override
  SpotDetailsState get state => SpotDetailsInitial();

  @override
  Stream<SpotDetailsState> get stream => const Stream.empty();

  @override
  Future<void> close() async {}
}

Widget _buildWrapper(Widget child) {
  return BlocProvider<SpotDetailsBloc>(
    create: (_) => _FakeSpotDetailsBloc(),
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          Dimensions.init(context);
          return Scaffold(body: SingleChildScrollView(child: child));
        },
      ),
    ),
  );
}

void main() {
  final testPost = RequestEntity(
    id: 'req-1',
    userId: 'host-1',
    categoryId: 'cat-cricket',
    title: 'Sunday Box Cricket',
    locationName: 'Navrangpura, Ahmedabad',
    latitude: 23.03,
    longitude: 72.56,
    eventDateTime: DateTime.now().add(const Duration(days: 2)),
    maxParticipants: 10,
    currentParticipants: 4,
    pricePerPerson: 150.0,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  group('SpotDetailsBookingPanel Group Chat Button', () {
    testWidgets('shows Group Chat button when user is the activity host', (
      tester,
    ) async {
      final state = SpotDetailsLoaded(
        post: testPost,
        isHost: true,
        confirmedPlayers: const [],
        userJoinRequest: null,
      );

      await tester.pumpWidget(
        _buildWrapper(SpotDetailsBookingPanel(state: state)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Group chat'), findsOneWidget);
      expect(find.byIcon(Icons.forum_outlined), findsOneWidget);
    });

    testWidgets(
      'shows Group Chat button when user is an accepted participant',
      (tester) async {
        final acceptedRequest = JoinRequestEntity(
          id: 'jr-1',
          requestId: 'req-1',
          userId: 'user-2',
          status: JoinRequestStatus.accepted,
          createdAt: DateTime(2026, 1, 2),
        );

        final state = SpotDetailsLoaded(
          post: testPost,
          isHost: false,
          confirmedPlayers: [acceptedRequest],
          userJoinRequest: acceptedRequest,
        );

        await tester.pumpWidget(
          _buildWrapper(SpotDetailsBookingPanel(state: state)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Group chat'), findsOneWidget);
        expect(find.byIcon(Icons.forum_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'does NOT show Group Chat button when user is a stranger who can join',
      (tester) async {
        final state = SpotDetailsLoaded(
          post: testPost,
          isHost: false,
          confirmedPlayers: const [],
          userJoinRequest: null,
        );

        await tester.pumpWidget(
          _buildWrapper(SpotDetailsBookingPanel(state: state)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Group Chat'), findsNothing);
        expect(find.byIcon(Icons.forum_outlined), findsNothing);
      },
    );
  });
}
