part of 'jumper_editor.dart';

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.onChange,
    required this.formatters,
    required this.labelText,
    this.maxLength,
  });

  final VoidCallback onChange;
  final TextEditingController controller;
  final List<TextInputFormatter> formatters;
  final String labelText;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      controller: controller,
      decoration: InputDecoration(
        label: Text(labelText),
        border: const OutlineInputBorder(),
        counterText: '',
      ),
      inputFormatters: formatters,
      onSubmitted: (value) => onChange(),
      onTapOutside: (event) => onChange(),
    );
  }
}
