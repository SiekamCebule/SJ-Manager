part of 'jumper_editor.dart';

class _LandingStyleDropdown extends StatelessWidget {
  const _LandingStyleDropdown({
    required this.controller,
    required this.onChange,
    this.initial,
    this.width,
  });

  final TextEditingController controller;
  final LandingStyle? initial;
  final Function(LandingStyle? selected) onChange;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<LandingStyle>(
      width: width,
      controller: controller,
      enableSearch: false,
      requestFocusOnTap: false,
      dropdownMenuEntries: LandingStyle.values.map((style) {
        return DropdownMenuEntry(
          value: style,
          label: translatedLandingStyleDescription(context, style),
        );
      }).toList(),
      label: const Text('Styl lądowania'),
      onSelected: onChange,
    );
  }
}
