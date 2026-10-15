import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/core/constants/dimensions.dart';
import 'package:lastspot_app/core/l10n/app_localizations.dart';
import 'package:lastspot_app/core/theme/app_theme.dart';
import 'package:lastspot_app/core/widgets/lastspot_bottom_navigation_bar.dart';

void main() {
  Widget buildWrapper({
    int selectedIndex = 0,
    ValueChanged<int>? onDestinationSelected,
    int chatsUnreadCount = 0,
    double textScale = 1.0,
    Size screenSize = const Size(390, 844),
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(
          size: screenSize,
          textScaler: TextScaler.linear(textScale),
          padding: const EdgeInsets.only(bottom: 24),
        ),
        child: Builder(
          builder: (context) {
            Dimensions.init(context);
            return Scaffold(
              body: const Center(child: Text('Content')),
              bottomNavigationBar: LastSpotBottomNavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected ?? (_) {},
                chatsUnreadCount: chatsUnreadCount,
              ),
            );
          },
        ),
      ),
    );
  }

  group('LastSpotBottomNavigationBar Tests', () {
    testWidgets('renders exactly five destinations with correct labels', (
      tester,
    ) async {
      await tester.pumpWidget(buildWrapper(selectedIndex: 0));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Create'), findsOneWidget);
      expect(find.text('Activities'), findsOneWidget);
      expect(find.text('Chats'), findsOneWidget);
    });

    testWidgets(
      'tapping each destination triggers onDestinationSelected with correct index',
      (tester) async {
        int? tappedIndex;
        await tester.pumpWidget(
          buildWrapper(
            selectedIndex: 0,
            onDestinationSelected: (idx) => tappedIndex = idx,
          ),
        );
        await tester.pumpAndSettle();

        // Tap Explore (index 1)
        await tester.tap(find.text('Explore'));
        await tester.pumpAndSettle();
        expect(tappedIndex, 1);

        // Tap Create (index 2)
        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();
        expect(tappedIndex, 2);

        // Tap Activities (index 3)
        await tester.tap(find.text('Activities'));
        await tester.pumpAndSettle();
        expect(tappedIndex, 3);

        // Tap Chats (index 4)
        await tester.tap(find.text('Chats'));
        await tester.pumpAndSettle();
        expect(tappedIndex, 4);

        // Tap Home (index 0)
        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();
        expect(tappedIndex, 0);
      },
    );

    testWidgets('active destination reflects selected state', (tester) async {
      await tester.pumpWidget(buildWrapper(selectedIndex: 3)); // Activities
      await tester.pumpAndSettle();

      final activitiesText = tester.widget<Text>(find.text('Activities'));
      expect(activitiesText.style?.fontWeight, FontWeight.w800);

      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('provides accessible semantic labels for all tabs', (
      tester,
    ) async {
      await tester.pumpWidget(buildWrapper(selectedIndex: 0));
      await tester.pumpAndSettle();

      for (final label in [
        'Home',
        'Explore',
        'Create',
        'Activities',
        'Chats',
      ]) {
        expect(
          find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == label,
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets('does not overflow on small screens with 1.4x text scaling', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWrapper(
          selectedIndex: 0,
          textScale: 1.4,
          screenSize: const Size(320, 568), // iPhone SE 1st gen size
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(LastSpotBottomNavigationBar), findsOneWidget);
    });

    testWidgets('renders all five 3D navigation icons properly', (
      tester,
    ) async {
      await tester.pumpWidget(buildWrapper(selectedIndex: 0));
      await tester.pumpAndSettle();

      // All 5 destinations render 3D images
      expect(
        find.descendant(
          of: find.byType(LastSpotBottomNavigationBar),
          matching: find.byType(Image),
        ),
        findsNWidgets(5),
      );
    });

    testWidgets('renders subtle unread badge on Chats only when count > 0', (
      tester,
    ) async {
      // With 0 unread chats
      await tester.pumpWidget(
        buildWrapper(selectedIndex: 0, chatsUnreadCount: 0),
      );
      await tester.pumpAndSettle();
      expect(find.text('5'), findsNothing);

      // With 5 unread chats
      await tester.pumpWidget(
        buildWrapper(selectedIndex: 0, chatsUnreadCount: 5),
      );
      await tester.pumpAndSettle();
      expect(find.text('5'), findsOneWidget);

      // With > 9 unread chats, shows 9+
      await tester.pumpWidget(
        buildWrapper(selectedIndex: 0, chatsUnreadCount: 15),
      );
      await tester.pumpAndSettle();
      expect(find.text('9+'), findsOneWidget);
    });
  });
}
