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

class NumberInRangeEnforcer extends TextInputFormatter {
  const NumberInRangeEnforcer({
    this.min,
    this.max,
  });

  final num? min;
  final num? max;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return oldValue;
    }
    final number = num.parse(newValue.text);
    if (min != null && number < min!) {
      return newValue.copyWith(text: min.toString());
    } else if (max != null && number > max!) {
      return newValue.copyWith(text: max.toString());
    } else {
      return newValue;
    }
  }
}

class NDecimalPlacesEnforcer extends TextInputFormatter {
  const NDecimalPlacesEnforcer({
    required this.decimalPlaces,
  }) : assert(decimalPlaces > 0);

  final int decimalPlaces;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (newValue.text == '.') {
      return newValue;
    }
    final value = double.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }
    final decimalIndex = newValue.text.indexOf('.');
    if (decimalIndex == -1 || newValue.text.length - decimalIndex - 1 <= decimalPlaces) {
      return newValue;
    }
    return oldValue;
  }
}

List<TextInputFormatter> get doubleTextInputFormatters {
  return [
    FilteringTextInputFormatter.allow(RegExp(r'[\d\.,]')),
    const CommaToPeriodEnforcer(),
    const SinglePeriodEnforcer(),
  ];
}
