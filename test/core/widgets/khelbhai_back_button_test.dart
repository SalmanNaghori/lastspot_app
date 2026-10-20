import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lastspot_app/core/theme/app_color.dart';
import 'package:lastspot_app/core/widgets/khelbhai_back_button.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('48 dp labelled target and raised surface in $brightness', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              appBar: AppBar(
                leading: KhelBhaiBackButton(onPressed: () => taps++),
                title: const Text('Activity'),
              ),
            ),
          ),
        ),
      );
      expect(find.byTooltip('Back'), findsOneWidget);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Back')),
        matchesSemantics(
          label: 'Back',
          isButton: true,
          hasTapAction: true,
          isFocusable: true,
          hasFocusAction: true,
        ),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      final surface = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = surface.decoration! as BoxDecoration;
      expect(
        (decoration.gradient! as LinearGradient).colors.first,
        brightness == Brightness.dark
            ? AppColor.surfaceContainerHighDark
            : AppColor.surfaceLight,
      );
      expect(decoration.boxShadow, isNotEmpty);
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(KhelBhaiBackButton)),
      );
      await tester.pump(const Duration(milliseconds: 180));
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        lessThan(1),
      );
      await gesture.up();
      await tester.pumpAndSettle();
      expect(taps, 1);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'reduced motion and screen-reader activation use the same action',
    (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(body: KhelBhaiBackButton(onPressed: () => taps++)),
          ),
        ),
      );
      final node = tester.getSemantics(find.bySemanticsLabel('Back'));
      tester.binding.performSemanticsAction(
        SemanticsActionEvent(
          viewId: tester.view.viewId,
          nodeId: node.id,
          type: SemanticsAction.tap,
        ),
      );
      await tester.pump();
      expect(taps, 1);
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).duration,
        Duration.zero,
      );
    },
  );

  testWidgets(
    'back dismisses focus, preserves the prior route state, and stays at root',
    (tester) async {
      final controller = TextEditingController();
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              appBar: AppBar(leading: const KhelBhaiBackButton()),
              body: Column(
                children: [
                  TextField(controller: controller),
                  TextButton(
                    onPressed: () => context.push('/detail'),
                    child: const Text('Open'),
                  ),
                ],
              ),
            ),
          ),
          GoRoute(
            path: '/detail',
            builder: (context, state) => Scaffold(
              appBar: AppBar(leading: const KhelBhaiBackButton()),
              body: TextField(focusNode: focus),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.enterText(find.byType(TextField), 'Draft retained');
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.showKeyboard(find.byType(TextField));
      expect(focus.hasFocus, isTrue);
      await tester.tap(find.byType(KhelBhaiBackButton));
      await tester.pumpAndSettle();
      expect(focus.hasFocus, isFalse);
      expect(controller.text, 'Draft retained');
      expect(router.canPop(), isFalse);
      await tester.tap(find.byType(KhelBhaiBackButton));
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('button and Android back honor an unsaved-form guard', (
    tester,
  ) async {
    var blockedPops = 0;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () => context.push('/form'),
              child: const Text('Edit'),
            ),
          ),
        ),
        GoRoute(
          path: '/form',
          builder: (context, state) => Form(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) blockedPops++;
            },
            child: Scaffold(
              appBar: AppBar(leading: const KhelBhaiBackButton()),
              body: const Text('Unsaved form'),
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(KhelBhaiBackButton));
    await tester.pumpAndSettle();
    expect(blockedPops, 1);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(blockedPops, 2);
    expect(find.text('Unsaved form'), findsOneWidget);
    expect(router.canPop(), isTrue);
  });

  testWidgets(
    'conditional leading stays hidden at root and appears on a pushed route',
    (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: KhelBhaiBackButton.leading(context),
              ),
              body: TextButton(
                onPressed: () => context.push('/profile'),
                child: const Text('Profile'),
              ),
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: KhelBhaiBackButton.leading(context),
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      expect(find.byType(KhelBhaiBackButton), findsNothing);
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.byType(KhelBhaiBackButton), findsOneWidget);
      await tester.tap(find.byType(KhelBhaiBackButton));
      await tester.pumpAndSettle();
      expect(find.byType(KhelBhaiBackButton), findsNothing);
    },
  );

  testWidgets('iOS edge swipe still pops the native route', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () => context.push('/detail'),
              child: const Text('Open'),
            ),
          ),
        ),
        GoRoute(
          path: '/detail',
          builder: (context, state) => Scaffold(
            appBar: AppBar(leading: const KhelBhaiBackButton()),
            body: const Text('Detail'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        theme: ThemeData(platform: TargetPlatform.iOS),
        routerConfig: router,
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.timedDragFrom(
      const Offset(1, 250),
      const Offset(650, 0),
      const Duration(milliseconds: 500),
    );
    await tester.pumpAndSettle();
    expect(router.canPop(), isFalse);
    expect(find.text('Open'), findsOneWidget);
  });
}
