part of 'jumper_editor.dart';

class _SexSegmentedButton extends StatefulWidget {
  const _SexSegmentedButton({
    required this.selected,
    required this.onChange,
  });

  final Sex selected;
  final Function(Sex selected) onChange;

  @override
  State<_SexSegmentedButton> createState() => _SexSegmentedButtonState();
}

class _SexSegmentedButtonState extends State<_SexSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Sex>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: Sex.male,
          icon: Icon(
            Symbols.male,
            size: UiItemEditorsConstants.sexIconSizeInJumperEditor,
          ),
        ),
        ButtonSegment(
          value: Sex.female,
          icon: Icon(
            Symbols.female,
            size: UiItemEditorsConstants.sexIconSizeInJumperEditor,
          ),
        ),
      ],
      selected: {widget.selected},
      onSelectionChanged: (selected) {
        widget.onChange(selected.single);
      },
    );
  }
}
