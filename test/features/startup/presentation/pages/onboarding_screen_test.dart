import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/startup/presentation/pages/onboarding_screen.dart';
import 'package:lastspot_app/features/startup/presentation/widgets/onboarding_action_buttons.dart';
import 'package:lastspot_app/features/startup/presentation/widgets/onboarding_page_indicator.dart';
import 'package:lastspot_app/features/startup/presentation/widgets/onboarding_slide_item.dart';
import 'package:lastspot_app/features/startup/presentation/widgets/onboarding_top_bar.dart';

Widget _buildWrapper({
  Locale locale = const Locale('en'),
  ThemeMode themeMode = ThemeMode.light,
}) {
  return MaterialApp(
    locale: locale,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: themeMode,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: const MediaQueryData(
        size: Size(390, 844),
        padding: EdgeInsets.only(top: 44, bottom: 34),
      ),
      child: Builder(
        builder: (context) {
          Dimensions.init(context);
          return const OnboardingScreen();
        },
      ),
    ),
  );
}

void main() {
  group('OnboardingScreen — KhelBhai 4-Slide Experience', () {
    testWidgets(
      'renders Slide 1 (Welcome) with correct branding and Get Started CTA',
      (tester) async {
        await tester.pumpWidget(_buildWrapper());
        await tester.pumpAndSettle();

        // Top bar branding
        expect(find.byType(OnboardingTopBar), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (w) => w is RichText && w.text.toPlainText().contains('KhelBhai'),
          ),
          findsOneWidget,
        );

        // Slide 1 elements
        expect(find.text('Your Game. Your Gang.'), findsOneWidget);
        expect(find.text('Bhai, Team Banao! Match Jamao!'), findsOneWidget);
        expect(
          find.text(
            'Find players, make teams, and turn plans into real games.',
          ),
          findsOneWidget,
        );

        // CTA button text for first slide
        expect(find.text('Get Started'), findsOneWidget);

        // Skip button present, Back button not present on page 0
        expect(find.text('Skip'), findsOneWidget);
        expect(find.byType(KhelBhaiBackButton), findsNothing);

        // Indicator and Action buttons present
        expect(find.byType(OnboardingPageIndicator), findsOneWidget);
        expect(find.byType(OnboardingActionButtons), findsOneWidget);
      },
    );

    testWidgets('advances through all 4 slides and shows correct content', (
      tester,
    ) async {
      await tester.pumpWidget(_buildWrapper());
      await tester.pumpAndSettle();

      // Tap Get Started -> advances to Slide 2
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Slide 2: Find Players
      expect(find.text('Players Kam Hai? KhelBhai Hai Na!'), findsOneWidget);
      expect(
        find.text('Find people nearby who are ready to join your next game.'),
        findsOneWidget,
      );
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byType(KhelBhaiBackButton), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);

      // Tap Continue -> advances to Slide 3
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Slide 3: Create or Join Activities
      expect(find.text('Game Banao. Gang Bulao.'), findsOneWidget);
      expect(
        find.text('Host a match, discover activities, and join the action.'),
        findsOneWidget,
      );
      expect(find.text('Continue'), findsOneWidget);

      // Tap Continue -> advances to Slide 4 (Final Screen)
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Slide 4: Connect With Your Team
      expect(find.text('Team Bani? Ab Game Jamao!'), findsOneWidget);
      expect(
        find.text(
          'Chat with teammates, coordinate plans, and get ready to play.',
        ),
        findsOneWidget,
      );
      expect(find.text("Ready, Bhai? Let's Play!"), findsOneWidget);

      // Final CTA: Let's Play
      expect(find.text("Let's Play"), findsOneWidget);

      // Skip is hidden on the final screen
      expect(find.text('Skip'), findsNothing);

      // Back button allows returning to previous slide
      await tester.tap(find.byType(KhelBhaiBackButton));
      await tester.pumpAndSettle();
      expect(find.text('Game Banao. Gang Bulao.'), findsOneWidget);
    });

    testWidgets('renders in Dark Theme cleanly without overflow', (
      tester,
    ) async {
      await tester.pumpWidget(_buildWrapper(themeMode: ThemeMode.dark));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingSlideItem), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders in Gujarati locale', (tester) async {
      await tester.pumpWidget(_buildWrapper(locale: const Locale('gu')));
      await tester.pumpAndSettle();

      expect(find.text('તમારી રમત. તમારી ટોળી.'), findsOneWidget);
      expect(find.text('શરૂ કરો'), findsOneWidget);
      expect(find.text('છોડો'), findsOneWidget);
    });

    testWidgets('renders in Hindi locale', (tester) async {
      await tester.pumpWidget(_buildWrapper(locale: const Locale('hi')));
      await tester.pumpAndSettle();

      expect(find.text('आपका खेल। आपकी टीम।'), findsOneWidget);
      expect(find.text('शुरू करें'), findsOneWidget);
      expect(find.text('छोड़ें'), findsOneWidget);
    });
  });
}
