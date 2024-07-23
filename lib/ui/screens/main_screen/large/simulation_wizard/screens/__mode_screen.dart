part of '../simulation_wizard_dialog.dart';

class _ModeScreen extends StatefulWidget {
  const _ModeScreen({
    required this.onChange,
  });

  final void Function(SimulationMode? mode) onChange;

  @override
  State<_ModeScreen> createState() => _ModeScreenState();
}

class _ModeScreenState extends State<_ModeScreen> {
  var _selected = SimulationMode.coach;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MainMenuTextContentButton(
            isSelected: _selected == SimulationMode.coach,
            titleText: 'Zostań trenerem',
            contentText:
                'Minim reprehenderit pariatur quis veniam laborum ipsum aliqua minim esse consectetur qui eiusmod dolore. Culpa sint velit reprehenderit do culpa enim magna consectetur labore quis occaecat pariatur.',
            onTap: () {
              setState(() {
                _selected = SimulationMode.coach;
              });
              widget.onChange(SimulationMode.coach);
            },
            decorationWidget: const Icon(
              Symbols.person,
              size: 140,
            ),
          ),
        ),
        Expanded(
          child: MainMenuTextContentButton(
            isSelected: _selected == SimulationMode.observer,
            titleText: 'Zostań obserwatorem',
            contentText:
                'Minim reprehenderit pariatur quis veniam laborum ipsum aliqua minim esse consectetur qui eiusmod dolore. Culpa sint velit reprehenderit do culpa enim magna consectetur labore quis occaecat pariatur. ',
            onTap: () {
              setState(() {
                _selected = SimulationMode.observer;
              });
              widget.onChange(SimulationMode.observer);
            },
            decorationWidget: const Icon(
              Symbols.eye_tracking,
              size: 140,
            ),
          ),
        ),
      ],
    );
  }
}
