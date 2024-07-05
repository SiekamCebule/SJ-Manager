import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class CapitalizeTextFormatter extends TextInputFormatter {
  const CapitalizeTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String capitalizedText = _capitalizeEachWord(newValue.text);
    return TextEditingValue(
      text: capitalizedText,
      selection: newValue.selection,
    );
  }

  String _capitalizeEachWord(String text) {
    if (text.isEmpty) return text;

    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

class SinglePeriodEnforcer extends TextInputFormatter {
  const SinglePeriodEnforcer();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    // Allow only one period
    if ('.'.allMatches(newText).length <= 1) {
      return newValue;
    }
    return oldValue;
  }
}

class CommaToPeriodEnforcer extends TextInputFormatter {
  const CommaToPeriodEnforcer();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.replaceAll(RegExp(r','), '.'));
  }
}
