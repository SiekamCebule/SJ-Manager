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
    return Material(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: SimulationWizardModeOptionButton(
              titleText: 'Klasyczny trener',
              subtitleText:
                  'Obejmij jedną z kadr w krajowym związku narciarskim. Odpowiadaj za rozwój i powołuj na zawody. Dbaj o dobre wyniki swoich skoczków lub skoczkiń.',
              onTap: () {
                setState(() {
                  _selected = _selected != SimulationMode.classicCoach
                      ? SimulationMode.classicCoach
                      : null;
                });
                widget.onChange(_selected);
              },
              isSelected: _selected == SimulationMode.classicCoach,
              disabled:
                  !sjmSimulationModeAvailibilityStates[SimulationMode.classicCoach]!,
            ),
          ),
          SizedBox(
            height: 100,
            child: SimulationWizardModeOptionButton(
              titleText: 'Trener personalny',
              subtitleText:
                  'Wybierz z kim chcesz pracować i odpowiadaj za rozwój swoich podopiecznych. Nie ty powołujesz ich na zawody - wciąż podlegają oni swoim kadrom.',
              onTap: () {
                setState(() {
                  _selected = _selected != SimulationMode.personalCoach
                      ? SimulationMode.personalCoach
                      : null;
                });
                widget.onChange(_selected);
              },
              isSelected: _selected == SimulationMode.personalCoach,
              disabled:
                  !sjmSimulationModeAvailibilityStates[SimulationMode.personalCoach]!,
            ),
          ),
          SizedBox(
            height: 100,
            child: SimulationWizardModeOptionButton(
              titleText: 'Obserwator',
              subtitleText:
                  'Nie maczaj palców w prowadzeniu kadry ani w szkoleniu zawodników i zawodniczek. Obserwuj codzienne wydarzenia ze świata skoków i jeźdź na zawody. W każdym momencie możesz objąć kadrę lub zostać trenerem personalnym.',
              onTap: () {
                setState(() {
                  _selected = _selected != SimulationMode.observer
                      ? SimulationMode.observer
                      : null;
                });
                widget.onChange(_selected);
              },
              isSelected: _selected == SimulationMode.observer,
              disabled: !sjmSimulationModeAvailibilityStates[SimulationMode.observer]!,
            ),
          ),
        ],
      ),
    );
  }
}

const sjmSimulationModeAvailibilityStates = {
  SimulationMode.classicCoach: false,
  SimulationMode.personalCoach: true,
  SimulationMode.observer: false,
};
