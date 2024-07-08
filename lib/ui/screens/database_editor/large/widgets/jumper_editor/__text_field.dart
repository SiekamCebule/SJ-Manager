part of 'jumper_editor.dart';

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.onChange,
    required this.formatters,
    required this.labelText,
  });

  final VoidCallback onChange;
  final TextEditingController controller;
  final List<TextInputFormatter> formatters;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(labelText),
        border: const OutlineInputBorder(),
      ),
      inputFormatters: formatters,
      onSubmitted: (value) => onChange(),
      onTapOutside: (event) => onChange(),
    );
  }
}
