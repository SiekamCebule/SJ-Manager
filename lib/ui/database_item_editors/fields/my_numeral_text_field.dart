import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable/text_formatters.dart';
import 'package:sj_manager/utils/doubles.dart';
import 'package:sj_manager/utils/math.dart';

class MyNumeralTextField extends StatefulWidget {
  const MyNumeralTextField({
    super.key,
    this.enabled = true,
    required this.controller,
    this.additionalButtons,
    required this.onChange,
    this.formatters = const [],
    required this.labelText,
    this.skipPlusMinusButtons = false,
    this.suffixText,
    required this.step,
    required this.min,
    required this.max,
    this.initial,
    this.focusNode,
    this.maxDecimalPlaces,
  }) : assert(initial == null || (initial >= min && initial <= max));

  final bool enabled;
  final VoidCallback onChange;
  final TextEditingController controller;
  final List<TextInputFormatter> formatters;
  final List<Widget>? additionalButtons;
  final bool skipPlusMinusButtons;
  final String labelText;
  final String? suffixText;
  final num step;
  final num min;
  final num max;
  final num? initial;
  final FocusNode? focusNode;
  final int? maxDecimalPlaces;

  @override
  State<MyNumeralTextField> createState() => MyNumeralTextFieldState();
}

class MyNumeralTextFieldState extends State<MyNumeralTextField> {
  @override
  void initState() {
    if (widget.initial != null) {
      widget.controller.text = widget.initial.toString();
    } else {
      widget.controller.text = widget.min.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(UiFieldWidgetsConstants.borderRadius),
      borderSide: BorderSide(
        width: UiFieldWidgetsConstants.borderSideWidth,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: widget.enabled,
              controller: widget.controller,
              decoration: InputDecoration(
                label: Text(widget.labelText),
                border: border,
                enabledBorder: border,
                suffixText: widget.suffixText,
              ),
              inputFormatters: [
                ...widget.formatters,
                _numberInRangeEnforcer,
                if (widget.maxDecimalPlaces != null)
                  NDecimalPlacesEnforcer(decimalPlaces: widget.maxDecimalPlaces!)
              ],
              onSubmitted: (value) => _onTextFieldChange(),
              onTapOutside: (event) => _onTextFieldChange(),
              focusNode: widget.focusNode,
            ),
          ),
          ...widget.additionalButtons ?? [],
          if (!widget.skipPlusMinusButtons) ...[
            IconButton(
              onPressed: widget.enabled
                  ? () {
                      var decremented = _numberFromController - widget.step;
                      if (widget.maxDecimalPlaces != null) {
                        decremented = preparedNumber(decremented.toDouble());
                      }
                      widget.controller.text = _numberInRangeEnforcer
                          .formatEditUpdate(
                              widget.controller.value,
                              widget.controller.value
                                  .copyWith(text: decremented.toString()))
                          .text;
                      widget.onChange();
                    }
                  : null,
              icon: const Icon(
                Symbols.remove,
              ),
            ),
            IconButton(
              onPressed: widget.enabled
                  ? () {
                      var incremented = _numberFromController + widget.step;
                      if (widget.maxDecimalPlaces != null) {
                        incremented = preparedNumber(incremented.toDouble());
                      }
                      widget.controller.text = _numberInRangeEnforcer
                          .formatEditUpdate(
                              widget.controller.value,
                              widget.controller.value
                                  .copyWith(text: incremented.toString()))
                          .text;
                      widget.onChange();
                    }
                  : null,
              icon: const Icon(Symbols.add),
            ),
          ]
        ],
      ),
    );
  }

  void _onTextFieldChange() {
    _setToMinIfEmpty();
    widget.onChange();
  }

  void _setToMinIfEmpty() {
    if (widget.controller.text.isEmpty) {
      widget.controller.text = widget.min.toString();
    }
  }

  double preparedNumber(double number) {
    return double.parse(
        minimizeDecimalPlaces(roundToNDecimalPlaces(number, widget.maxDecimalPlaces!)));
  }

  NumberInRangeEnforcer get _numberInRangeEnforcer {
    return NumberInRangeEnforcer(min: widget.min, max: widget.max);
  }

  num get _numberFromController {
    return num.parse(widget.controller.text);
  }
}
