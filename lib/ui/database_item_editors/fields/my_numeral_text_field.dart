import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/ui/reusable/text_formatters.dart';

class MyNumeralTextField extends StatelessWidget {
  const MyNumeralTextField({
    super.key,
    required this.controller,
    required this.onChange,
    required this.formatters,
    required this.labelText,
    this.suffixText,
    required this.step,
    this.min,
    this.max,
    this.focusNode,
  });

  final VoidCallback onChange;
  final TextEditingController controller;
  final List<TextInputFormatter> formatters;
  final String labelText;
  final String? suffixText;
  final num step;
  final num? min;
  final num? max;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                label: Text(labelText),
                border: const OutlineInputBorder(),
                suffixText: suffixText,
              ),
              inputFormatters: [
                ...formatters,
                _numberInRangeEnforcer,
              ],
              onSubmitted: (value) => onChange(),
              onTapOutside: (event) => onChange(),
              focusNode: focusNode,
            ),
          ),
          IconButton(
            onPressed: () {
              final decremented = _numberFromController - step;
              controller.text = _numberInRangeEnforcer
                  .formatEditUpdate(controller.value,
                      controller.value.copyWith(text: decremented.toString()))
                  .text;
              onChange();
            },
            icon: const Icon(
              Symbols.remove,
            ),
          ),
          IconButton(
            onPressed: () {
              final incremented = _numberFromController + step;
              controller.text = _numberInRangeEnforcer
                  .formatEditUpdate(controller.value,
                      controller.value.copyWith(text: incremented.toString()))
                  .text;
              onChange();
            },
            icon: const Icon(Symbols.add),
          ),
        ],
      ),
    );
  }

  NumberInRangeEnforcer get _numberInRangeEnforcer {
    return NumberInRangeEnforcer(min: min, max: max);
  }

  num get _numberFromController {
    return num.parse(controller.text);
  }
}
