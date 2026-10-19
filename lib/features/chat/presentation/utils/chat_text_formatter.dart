import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Parses WhatsApp-style formatting for display while leaving message storage
/// and the message itself unchanged.
class ChatTextFormatter {
  ChatTextFormatter._();

  static final RegExp _urlStart = RegExp(r'https?://', caseSensitive: false);
  static final RegExp _asciiWordCharacter = RegExp(r'[A-Za-z0-9_]');
  static const String _urlTrailingPunctuation = '.,!?;:)]}';

  static List<InlineSpan> buildSpans({
    required String text,
    required TextStyle baseStyle,
    required Color linkColor,
    required Color codeBackground,
    required void Function(String url) onUrlTap,
    TapGestureRecognizer Function(String url)? recognizerForUrl,
  }) {
    if (text.isEmpty) return const [];
    return _parse(
      text,
      baseStyle,
      linkColor,
      codeBackground,
      onUrlTap,
      recognizerForUrl,
      isForPreview: false,
    );
  }

  /// Builds lightweight formatted InlineSpans for conversation preview tiles,
  /// rendering bold, italic, and strikethrough without tap recognizers or heavy widgets.
  static List<InlineSpan> buildPreviewSpans({
    required String text,
    required TextStyle baseStyle,
  }) {
    if (text.isEmpty) return const [];
    return _parse(
      text,
      baseStyle,
      baseStyle.color ?? Colors.transparent,
      Colors.transparent,
      (_) {},
      null,
      isForPreview: true,
    );
  }

  /// Strips formatting delimiter characters (*, _, ~, `) for plain-text notification
  /// and system previews (e.g. *yess* -> yess).
  static String cleanPreview(String text) {
    if (text.isEmpty) return text;
    var result = text.replaceAll('```', '');
    result = result.replaceAllMapped(
      RegExp(r'([*_~`])(.+?)\1'),
      (match) => match.group(2) ?? '',
    );
    return result.trim();
  }

  static List<InlineSpan> _parse(
    String text,
    TextStyle style,
    Color linkColor,
    Color codeBackground,
    void Function(String url) onUrlTap,
    TapGestureRecognizer Function(String url)? recognizerForUrl, {
    bool isForPreview = false,
  }) {
    final spans = <InlineSpan>[];
    final plain = StringBuffer();

    void flushPlain() {
      if (plain.isNotEmpty) {
        spans.add(TextSpan(text: plain.toString(), style: style));
        plain.clear();
      }
    }

    var cursor = 0;
    while (cursor < text.length) {
      if (!isForPreview) {
        final url = _urlStart.matchAsPrefix(text, cursor);
        if (url != null) {
          var end = cursor;
          while (end < text.length && !_isWhitespace(text[end])) {
            end++;
          }
          while (end > cursor &&
              _urlTrailingPunctuation.contains(text[end - 1])) {
            end--;
          }
          if (end > url.end) {
            flushPlain();
            final value = text.substring(cursor, end);
            spans.add(
              TextSpan(
                text: value,
                style: style.copyWith(
                  color: linkColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer:
                    recognizerForUrl?.call(value) ??
                    (TapGestureRecognizer()..onTap = () => onUrlTap(value)),
              ),
            );
            cursor = end;
            continue;
          }
        }
      }

      if (text[cursor] == '`') {
        final markerLength = text.startsWith('```', cursor) ? 3 : 1;
        final marker = '`' * markerLength;
        final closing = text.indexOf(marker, cursor + markerLength);
        if (closing >= 0 && closing > cursor + markerLength) {
          flushPlain();
          final codeText = text.substring(cursor + markerLength, closing);
          if (markerLength == 3 && !isForPreview) {
            spans.add(
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: codeBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    codeText,
                    style: style.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ),
            );
          } else {
            spans.add(
              TextSpan(
                text: codeText,
                style: style.copyWith(
                  fontFamily: 'monospace',
                  backgroundColor: isForPreview ? null : codeBackground,
                ),
              ),
            );
          }
          cursor = closing + markerLength;
          continue;
        }
        plain.write(marker);
        cursor += markerLength;
        continue;
      }

      final marker = text[cursor];
      if ('*_~'.contains(marker) && _canOpen(text, cursor)) {
        final closing = _findClosing(text, cursor + 1, marker);
        if (closing != -1 && closing > cursor + 1) {
          flushPlain();
          final inner = text.substring(cursor + 1, closing);
          final nestedStyle = switch (marker) {
            '*' => style.copyWith(fontWeight: FontWeight.bold),
            '_' => style.copyWith(fontStyle: FontStyle.italic),
            '~' => style.copyWith(decoration: TextDecoration.lineThrough),
            _ => style,
          };
          spans.addAll(
            _parse(
              inner,
              nestedStyle,
              linkColor,
              codeBackground,
              onUrlTap,
              recognizerForUrl,
            ),
          );
          cursor = closing + 1;
          continue;
        }
      }

      plain.write(text[cursor]);
      cursor++;
    }

    flushPlain();
    return spans;
  }

  static int _findClosing(String text, int start, String marker) {
    for (var index = start; index < text.length; index++) {
      if (text[index] == marker &&
          index > start &&
          !_isWhitespace(text[index - 1]) &&
          _hasWordBoundary(text, index + 1)) {
        return index;
      }
    }
    return -1;
  }

  static bool _canOpen(String text, int index) {
    if (index + 1 >= text.length || _isWhitespace(text[index + 1])) {
      return false;
    }
    return !_isWordCharacterBefore(text, index);
  }

  static bool _hasWordBoundary(String text, int index) =>
      !_isWordCharacterAt(text, index);

  static bool _isWordCharacterBefore(String text, int index) =>
      index > 0 && _isWordCharacter(text[index - 1]);

  static bool _isWordCharacterAt(String text, int index) =>
      index < text.length && _isWordCharacter(text[index]);

  static bool _isWordCharacter(String character) {
    if (_asciiWordCharacter.hasMatch(character)) return true;
    // Scripts without letter case (including Gujarati and Hindi) are word
    // characters too, so a delimiter attached to them stays literal.
    return character.toUpperCase() == character.toLowerCase() &&
        character.runes.first > 0x7f &&
        !_isWhitespace(character) &&
        !_isPunctuationOrSymbol(character);
  }

  static bool _isPunctuationOrSymbol(String character) {
    final rune = character.runes.first;
    return (rune >= 0x2000 && rune <= 0x206f) ||
        (rune >= 0x20a0 && rune <= 0x2bff) ||
        (rune >= 0x1f000 && rune <= 0x1faff);
  }

  static bool _isWhitespace(String character) => character.trim().isEmpty;
}
