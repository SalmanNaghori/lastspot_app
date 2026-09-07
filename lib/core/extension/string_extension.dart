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
    // Normalize to lowercase and replace underscores/dashes with spaces
    String cleaned = replaceAllMapped(RegExp(r'[_\-]'), (match) => ' ');

    // Insert space before camelCase/PascalCase transitions
    cleaned = cleaned.replaceAllMapped(RegExp(r'(?<=[a-z])(?=[A-Z])'), (match) => ' ');
    // Capitalize each word
    List<String> list = cleaned.split(RegExp(r'\s+'));
    list.asMap().forEach((index, element) {
      if (index == 0) {
        list[index] = element[0].toUpperCase() + element.substring(1);
      } else {
        list[index] = element.toLowerCase();
      }
    });
    return list.join(' ');
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

  /// show snackBar (Alternative to Toast since fluttertoast isn't installed)
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    BuildContext context, {
    Color? textColor,
    Color? backgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(this, style: TextStyle(color: textColor)),
      backgroundColor: backgroundColor,
      margin: margin,
      padding: padding,
    ),
  );
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
}
