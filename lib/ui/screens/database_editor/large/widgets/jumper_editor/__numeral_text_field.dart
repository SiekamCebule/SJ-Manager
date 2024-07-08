part of 'jumper_editor.dart';

class _NumeralTextField extends StatelessWidget {
  const _NumeralTextField({
    required this.controller,
    required this.onChange,
    required this.formatters,
    required this.labelText,
    required this.step,
    this.min,
    this.max,
  });

  final VoidCallback onChange;
  final TextEditingController controller;
  final List<TextInputFormatter> formatters;
  final String labelText;
  final num step;
  final num? min;
  final num? max;

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
              ),
              inputFormatters: [
                ...formatters,
                _numberInRangeEnforcer,
              ],
              onSubmitted: (value) => onChange(),
              onTapOutside: (event) => onChange(),
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
