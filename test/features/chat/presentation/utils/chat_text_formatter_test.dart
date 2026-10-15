import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/features/chat/presentation/utils/chat_text_formatter.dart';

void main() {
  const baseStyle = TextStyle(fontSize: 14, color: Colors.black);
  const linkColor = Colors.blue;
  const codeBackground = Colors.grey;

  group('ChatTextFormatter WhatsApp-Style Formatting', () {
    test('renders plain text as a simple TextSpan', () {
      final spans = ChatTextFormatter.buildSpans(
        text: 'Hello world',
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (_) {},
      );

      expect(spans.length, 1);
      expect((spans[0] as TextSpan).text, 'Hello world');
      expect((spans[0] as TextSpan).style?.fontWeight, isNull);
    });

    test('parses *hello* as bold', () {
      final spans = ChatTextFormatter.buildSpans(
        text: '*hello*',
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (_) {},
      );

      expect(spans.length, 1);
      expect((spans[0] as TextSpan).text, 'hello');
      expect((spans[0] as TextSpan).style?.fontWeight, FontWeight.bold);
    });

    test('parses _hello_ as italic', () {
      final spans = ChatTextFormatter.buildSpans(
        text: '_hello_',
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (_) {},
      );

      expect(spans.length, 1);
      expect((spans[0] as TextSpan).text, 'hello');
      expect((spans[0] as TextSpan).style?.fontStyle, FontStyle.italic);
    });

    test('parses ~hello~ as strikethrough', () {
      final spans = ChatTextFormatter.buildSpans(
        text: '~hello~',
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (_) {},
      );

      expect(spans.length, 1);
      expect((spans[0] as TextSpan).text, 'hello');
      expect(
        (spans[0] as TextSpan).style?.decoration,
        TextDecoration.lineThrough,
      );
    });

    test('parses backticks `hello` as monospace', () {
      final spans = ChatTextFormatter.buildSpans(
        text: 'Run `flutter test` now',
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (_) {},
      );

      expect(spans.length, 3);
      expect((spans[0] as TextSpan).text, 'Run ');
      expect((spans[1] as TextSpan).text, 'flutter test');
      expect((spans[1] as TextSpan).style?.fontFamily, 'monospace');
      expect((spans[2] as TextSpan).text, ' now');
    });

    test('parses formatting within sentences: Hi *Salman*, how are _you_?', () {
      final spans = ChatTextFormatter.buildSpans(
        text: 'Hi *Salman*, how are _you_?',
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (_) {},
      );

      expect(spans.length, 5);
      expect((spans[0] as TextSpan).text, 'Hi ');
      expect((spans[1] as TextSpan).text, 'Salman');
      expect((spans[1] as TextSpan).style?.fontWeight, FontWeight.bold);
      expect((spans[2] as TextSpan).text, ', how are ');
      expect((spans[3] as TextSpan).text, 'you');
      expect((spans[3] as TextSpan).style?.fontStyle, FontStyle.italic);
      expect((spans[4] as TextSpan).text, '?');
    });

    test('handles unmatched symbols as normal plain text', () {
      final spans = ChatTextFormatter.buildSpans(
        text: 'Calculation: 5 * 4 = 20, item_price and ~discount',
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (_) {},
      );

      expect(spans.length, 1);
      expect(
        (spans[0] as TextSpan).text,
        'Calculation: 5 * 4 = 20, item_price and ~discount',
      );
    });

    test('preserves Gujarati, Hindi, Emojis, and currency symbols', () {
      const unicodeSample =
          'નમસ્તે! नमस्ते! 👋🏏 Price: ₹500, \$20, €15, £10 & 100% fine.';

      final spans = ChatTextFormatter.buildSpans(
        text: unicodeSample,
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (_) {},
      );

      expect(spans.length, 1);
      expect((spans[0] as TextSpan).text, unicodeSample);
    });

    test('formats Unicode words with bold and strikethrough', () {
      final spans = ChatTextFormatter.buildSpans(
        text: '*નમસ્તે* 🙏 and *नमस्ते* with ~₹500~ *₹100*',
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (_) {},
      );

      expect(spans.length, 7);
      expect((spans[0] as TextSpan).text, 'નમસ્તે');
      expect((spans[0] as TextSpan).style?.fontWeight, FontWeight.bold);
      expect((spans[1] as TextSpan).text, ' 🙏 and ');
      expect((spans[2] as TextSpan).text, 'नमस्ते');
      expect((spans[2] as TextSpan).style?.fontWeight, FontWeight.bold);
      expect((spans[3] as TextSpan).text, ' with ');
      expect((spans[4] as TextSpan).text, '₹500');
      expect(
        (spans[4] as TextSpan).style?.decoration,
        TextDecoration.lineThrough,
      );
      expect((spans[5] as TextSpan).text, ' ');
      expect((spans[6] as TextSpan).text, '₹100');
      expect((spans[6] as TextSpan).style?.fontWeight, FontWeight.bold);
    });

    test('parses URLs with clickable recognizer', () {
      String? tappedUrl;
      final spans = ChatTextFormatter.buildSpans(
        text: 'Check this: https://lastspot.app/match/123 see ya',
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (url) => tappedUrl = url,
      );

      expect(spans.length, 3);
      expect((spans[0] as TextSpan).text, 'Check this: ');
      final urlSpan = spans[1] as TextSpan;
      expect(urlSpan.text, 'https://lastspot.app/match/123');
      expect(urlSpan.style?.color, linkColor);
      expect(urlSpan.style?.decoration, TextDecoration.underline);
      expect((spans[2] as TextSpan).text, ' see ya');

      // Test tap
      (urlSpan.recognizer as TapGestureRecognizer).onTap?.call();
      expect(tappedUrl, 'https://lastspot.app/match/123');
    });

    test('parses triple backtick code blocks into WidgetSpan', () {
      final spans = ChatTextFormatter.buildSpans(
        text: 'Before ```final x = 42;``` After',
        baseStyle: baseStyle,
        linkColor: linkColor,
        codeBackground: codeBackground,
        onUrlTap: (_) {},
      );

      expect(spans.length, 3);
      expect((spans[0] as TextSpan).text, 'Before ');
      expect(spans[1], isA<WidgetSpan>());
      expect((spans[2] as TextSpan).text, ' After');
    });
  });
}
