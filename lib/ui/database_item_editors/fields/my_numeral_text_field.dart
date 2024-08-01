import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/ui/reusable/text_formatters.dart';
import 'package:sj_manager/utils/doubles.dart';
import 'package:sj_manager/utils/math.dart';

class MyNumeralTextField extends StatelessWidget {
  const MyNumeralTextField({
    super.key,
    this.enabled = true,
    required this.controller,
    this.buttons,
    required this.onChange,
    required this.formatters,
    required this.labelText,
    this.suffixText,
    required this.step,
    this.min,
    this.max,
    this.focusNode,
    this.maxDecimalPlaces,
  });

  final bool enabled;
  final VoidCallback onChange;
  final TextEditingController controller;
  final List<TextInputFormatter> formatters;
  final List<Widget>? buttons;
  final String labelText;
  final String? suffixText;
  final num step;
  final num? min;
  final num? max;
  final FocusNode? focusNode;
  final int? maxDecimalPlaces;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: enabled,
              controller: controller,
              decoration: InputDecoration(
                label: Text(labelText),
                border: const OutlineInputBorder(),
                suffixText: suffixText,
              ),
              inputFormatters: [
                ...formatters,
                _numberInRangeEnforcer,
                if (maxDecimalPlaces != null)
                  NDecimalPlacesEnforcer(decimalPlaces: maxDecimalPlaces!)
              ],
              onSubmitted: (value) => onChange(),
              onTapOutside: (event) => onChange(),
              focusNode: focusNode,
            ),
          ),
          ...buttons ?? [],
          IconButton(
            onPressed: enabled
                ? () {
                    var decremented = _numberFromController - step;
                    if (maxDecimalPlaces != null) {
                      decremented = preparedNumber(decremented.toDouble());
                    }
                    controller.text = _numberInRangeEnforcer
                        .formatEditUpdate(
                            controller.value,
                            controller.value
                                .copyWith(text: decremented.toString()))
                        .text;
                    onChange();
                  }
                : null,
            icon: const Icon(
              Symbols.remove,
            ),
          ),
          IconButton(
            onPressed: enabled
                ? () {
                    var incremented = _numberFromController + step;
                    if (maxDecimalPlaces != null) {
                      incremented = preparedNumber(incremented.toDouble());
                    }
                    controller.text = _numberInRangeEnforcer
                        .formatEditUpdate(
                            controller.value,
                            controller.value
                                .copyWith(text: incremented.toString()))
                        .text;
                    onChange();
                  }
                : null,
            icon: const Icon(Symbols.add),
          ),
        ],
      ),
    );
  }

  double preparedNumber(double number) {
    return double.parse(minimizeDecimalPlaces(
        roundToNDecimalPlaces(number, maxDecimalPlaces!)));
  }

  NumberInRangeEnforcer get _numberInRangeEnforcer {
    return NumberInRangeEnforcer(min: min, max: max);
  }

  num get _numberFromController {
    return num.parse(controller.text);
  }
}
