import 'package:flutter/material.dart';

extension StringExtension on String {
  bool get isNetworkImage {
    if (!isNotNullOrEmpty()) return false;
    final uri = Uri.tryParse(this);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  bool get isLocalFile {
    if (!isNotNullOrEmpty()) return false;
    return startsWith('/');
  }

  bool get isLocalAsset {
    if (!isNotNullOrEmpty()) return false;
    return !isNetworkImage && !isLocalFile;
  }

  /// Capital first letter
  /// Ex: james bond => James bond
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Remove whitespace
  String removeAllWhitespace() {
    return replaceAll(' ', '');
  }

  String toTitleCase() {
    if (trim().isEmpty) return this;

    // Normalize to replace underscores/dashes with spaces
    String cleaned = replaceAllMapped(RegExp(r'[_\-]'), (match) => ' ');

    // Insert space after comma if directly followed by a letter (e.g. "Ahmedabad,India" -> "Ahmedabad, India")
    cleaned = cleaned.replaceAllMapped(
      RegExp(r',([A-Za-z])'),
      (match) => ', ${match.group(1)}',
    );

    // Insert space before camelCase/PascalCase transitions
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'(?<=[a-z])(?=[A-Z])'),
      (match) => ' ',
    );

    // Capitalize each word
    List<String> list = cleaned.split(RegExp(r'\s+'));
    return list
        .where((e) => e.isNotEmpty)
        .map((element) {
          if (element.isEmpty) return element;
          return element[0].toUpperCase() + element.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Convert hex code to color
  Color hexToColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Combine Country code & Mobile number
  String withCountryCode({required String countryDialCode}) {
    return "$countryDialCode $this";
  }
}

extension StringNullablity on String? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  bool isNotNullOrEmpty() {
    return !isNullOrEmpty();
  }

  String orEmpty() {
    if (isNullOrEmpty()) return "";
    return this!;
  }

  String orDash() {
    if (isNullOrEmpty()) {
      return "-";
    } else {
      return this!;
    }
  }

  String ifEmpty(String another) {
    if (isNullOrEmpty()) {
      return another;
    } else {
      return this!;
    }
  }

  bool isEqualIgnoreCase(String? another) {
    if (isNullOrEmpty() || another.isNullOrEmpty()) return this == another;
    return this!.toLowerCase() == another!.toLowerCase();
  }

  /// Capitalizes first letter if non-null, else returns null or empty
  String? capitalizeFirst() {
    if (this == null || this!.isEmpty) return this;
    return this!.capitalizeFirst();
  }

  /// Converts to title case if non-null, else returns null
  String? toTitleCase() {
    if (this == null || this!.isEmpty) return this;
    return this!.toTitleCase();
  }

  /// Capitalizes first letter if present, or returns empty string
  String capitalizeFirstOrEmpty() {
    if (isNullOrEmpty()) return "";
    return this!.capitalizeFirst();
  }

  /// Converts to title case if present, or returns empty string
  String toTitleCaseOrEmpty() {
    if (isNullOrEmpty()) return "";
    return this!.toTitleCase();
  }
}
