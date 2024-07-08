part of 'jumper_editor.dart';

class _JumpsConsistencyDropdown extends StatelessWidget {
  const _JumpsConsistencyDropdown({
    required this.controller,
    required this.onChange,
    this.initial,
    this.width,
  });

  final TextEditingController controller;
  final JumpsConsistency? initial;
  final Function(JumpsConsistency? selected) onChange;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<JumpsConsistency>(
      width: width,
      controller: controller,
      initialSelection: initial,
      enableSearch: false,
      requestFocusOnTap: false,
      dropdownMenuEntries: JumpsConsistency.values.map((consistency) {
        return DropdownMenuEntry(
          value: consistency,
          label: translatedJumpsConsistencyDescription(context, consistency),
        );
      }).toList(),
      label: const Text('Równość skoków'),
      onSelected: onChange,
    );
  }
}
