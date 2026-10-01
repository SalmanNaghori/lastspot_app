import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final String symbol;

  CurrencyInputFormatter({this.symbol = '₹'});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new value is empty, return an empty string
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Extract only digits from the new value
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // If there are no digits after stripping, return empty
    if (digitsOnly.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    // Prevent starting with multiple zeros unless it's just '0'
    if (digitsOnly.length > 1 && digitsOnly.startsWith('0')) {
      digitsOnly = int.parse(digitsOnly).toString();
    }

    // Format the value with the currency symbol
    final String newText = '$symbol$digitsOnly';

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
