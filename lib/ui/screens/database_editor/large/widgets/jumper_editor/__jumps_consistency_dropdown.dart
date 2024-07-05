part of 'jumper_editor.dart';

class _JumpsConsistencyDropdown extends StatelessWidget {
  const _JumpsConsistencyDropdown({
    required this.controller,
    required this.onChange,
    this.initial,
  });

  final TextEditingController controller;
  final JumpsConsistency? initial;
  final Function(JumpsConsistency? selected) onChange;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<JumpsConsistency>(
      controller: controller,
      initialSelection: initial,
      enableSearch: false,
      requestFocusOnTap: false,
      dropdownMenuEntries: JumpsConsistency.values.map((consistency) {
        return DropdownMenuEntry(
          value: consistency,
          label: consistency.name,
        );
      }).toList(),
      label: const Text('Równość skoków'),
      onSelected: onChange,
    );
  }
}
