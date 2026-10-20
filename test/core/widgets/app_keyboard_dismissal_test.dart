import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lastspot_app/core/l10n/app_localizations.dart';
import 'package:lastspot_app/core/services/navigation_focus_observer.dart';
import 'package:lastspot_app/core/widgets/app_keyboard_dismissal.dart';
import 'package:lastspot_app/core/widgets/selection_bottom_sheet.dart';
import 'package:lastspot_app/features/chat/presentation/widgets/chat_composer_bar.dart';

Widget app(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  scrollBehavior: const MaterialScrollBehavior().copyWith(
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
  ),
  builder: (context, child) => AppKeyboardDismissal(child: child!),
  home: Scaffold(body: child),
);

void main() {
  testWidgets(
    'outside touch dismisses without consuming a button or field tap',
    (tester) async {
      final first = FocusNode();
      final second = FocusNode();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      var taps = 0;
      await tester.pumpWidget(
        app(
          Column(
            children: [
              TextField(
                focusNode: first,
                decoration: const InputDecoration(labelText: 'First'),
              ),
              TextField(
                focusNode: second,
                decoration: const InputDecoration(labelText: 'Second'),
              ),
              TextButton(onPressed: () => taps++, child: const Text('Action')),
              const SizedBox(key: ValueKey('outside'), height: 100, width: 300),
            ],
          ),
        ),
      );
      await tester.showKeyboard(find.byType(TextField).first);
      await tester.tap(find.byType(TextField).last);
      await tester.pump();
      expect(second.hasFocus, isTrue);
      await tester.tap(find.text('Action'));
      await tester.pump();
      expect(taps, 1);
      expect(second.hasFocus, isFalse);
      await tester.showKeyboard(find.byType(TextField).first);
      await tester.tapAt(
        tester.getCenter(find.byKey(const ValueKey('outside'))),
      );
      await tester.pump();
      expect(first.hasFocus, isFalse);
    },
  );

  testWidgets('chat Send keeps the keyboard and clears only the sent draft', (
    tester,
  ) async {
    String? sent;
    await tester.pumpWidget(
      app(
        Align(
          alignment: Alignment.bottomCenter,
          child: ChatComposerBar(
            isSending: false,
            onSend: (text) async {
              sent = text;
              return true;
            },
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Next game?');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pumpAndSettle();
    expect(sent, 'Next game?');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isTrue,
    );
    expect(tester.testTextInput.isVisible, isTrue);
  });

  testWidgets('search suggestion tap keeps focus while scrolling dismisses', (
    tester,
  ) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    var selected = false;
    await tester.pumpWidget(
      app(
        ListView(
          children: [
            TextField(focusNode: focus),
            TextFieldTapRegion(
              child: TextButton(
                onPressed: () => selected = true,
                child: const Text('Suggestion'),
              ),
            ),
            const SizedBox(height: 1200),
          ],
        ),
      ),
    );
    await tester.showKeyboard(find.byType(TextField));
    await tester.tap(find.text('Suggestion'));
    await tester.pump();
    expect(selected, isTrue);
    expect(focus.hasFocus, isTrue);
    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isFalse);
  });

  testWidgets(
    'route change clears old focus and permits destination autofocus',
    (tester) async {
      final first = FocusNode();
      final otp = FocusNode();
      addTearDown(first.dispose);
      addTearDown(otp.dispose);
      final router = GoRouter(
        observers: [NavigationFocusObserver()],
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                Scaffold(body: TextField(focusNode: first)),
          ),
          GoRoute(
            path: '/otp',
            builder: (context, state) =>
                Scaffold(body: TextField(focusNode: otp, autofocus: true)),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.showKeyboard(find.byType(TextField));
      expect(first.hasFocus, isTrue);
      router.push<void>('/otp');
      await tester.pumpAndSettle();
      expect(first.hasFocus, isFalse);
      expect(otp.hasFocus, isTrue);
      router.pop();
      await tester.pumpAndSettle();
      expect(first.hasFocus, isFalse);
      expect(otp.hasFocus, isFalse);
    },
  );

  testWidgets(
    'selection sheet fits a small screen with keyboard and returns selection',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      String? selection;
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => TextButton(
              child: const Text('Select'),
              onPressed: () async {
                selection = await SelectionBottomSheet.show<String>(
                  context,
                  title: 'City',
                  searchHint: 'Search cities',
                  items: ['Ahmedabad', 'Surat'],
                  itemText: (city) => city,
                  onSearch: (city, query) => city.toLowerCase().contains(query),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      await tester.showKeyboard(find.byType(TextField));
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        tester.getBottomRight(find.byType(TextField)).dy,
        lessThanOrEqualTo(288),
      );
      await tester.tap(find.text('Surat'));
      await tester.pumpAndSettle();
      expect(selection, 'Surat');
      expect(find.byType(SelectionBottomSheet<String>), findsNothing);
    },
  );
}
