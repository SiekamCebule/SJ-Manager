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
  SimulationMode? _selected;

  @override
  void initState() {
    widget.onChange(_selected);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SimulationWizardOptionButton(
            isSelected: _selected == SimulationMode.coach,
            onTap: () {
              setState(() {
                _selected =
                    _selected != SimulationMode.coach ? SimulationMode.coach : null;
              });
              widget.onChange(_selected);
            },
            child: const MainMenuTextContentButtonBody(
              titleText: 'Zostań trenerem',
              contentText:
                  'Wybierz swoją wymarzoną reprezentację i stań się odpowiedzialny za każdy aspekt prowadzenia drużyny! Samemu wybierzesz grupę skoczków, z którymi będziesz pracował, zajmiesz się powołaniami na zawody, będziesz nadzorował treningiem, i wiele więcej...',
              decorationWidget: Icon(
                Symbols.person,
                size: 140,
              ),
            ),
          ),
        ),
        Expanded(
          child: SimulationWizardOptionButton(
            isSelected: _selected == SimulationMode.observer,
            onTap: () {
              setState(() {
                _selected =
                    _selected != SimulationMode.observer ? SimulationMode.observer : null;
              });
              widget.onChange(_selected);
            },
            child: const MainMenuTextContentButtonBody(
              titleText: 'Zostań obserwatorem',
              contentText:
                  'Nie zaprzątaj swojej głowy prowadzeniem drużyny. Zajmij swoją głowę uważną obserwacją wszystkich emocjonujących wydarzeń ze świata skoków, oglądaj interesujące cię zawody, przeglądaj newsy... Jeśli chcesz, możesz zacząć tajnie wpływać na rzeczywistość za pomocą edytora symulacji in-game',
              decorationWidget: Icon(
                Symbols.eye_tracking,
                size: 140,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
