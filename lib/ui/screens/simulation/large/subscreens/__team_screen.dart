part of '../../simulation_route.dart';

class _TeamScreen extends StatefulWidget {
  const _TeamScreen();

  @override
  State<_TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<_TeamScreen> {
  var _selectedMode = TeamScreenJumperCardMode.overview;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabaseCubit>().state;
    final trainingsAreSetUp =
        database.actionsRepo.isCompleted(SimulationActionType.settingUpTraining);
    final jumpers = sjmTestJumpersList(database: database);

    return Column(
      children: [
        const SizedBox(
          height: 170,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  child: TeamSummaryCard(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Placeholder(),
              ),
              Expanded(
                flex: 1,
                child: Placeholder(),
              ),
            ],
          ),
        ),
        const Gap(15),
        Center(
          child: SegmentedButton(
            segments: const [
              ButtonSegment(
                value: TeamScreenJumperCardMode.overview,
                label: Text('Ogólnie'),
                icon: Icon(Symbols.dashboard),
              ),
              ButtonSegment(
                value: TeamScreenJumperCardMode.training,
                label: Text('Trening'),
                icon: Icon(Symbols.fitness_center),
              ),
            ],
            selected: {_selectedMode},
            onSelectionChanged: (selected) async {
              if (!trainingsAreSetUp) {
                await showSjmDialog(
                  context: context,
                  child: TrainingsAreNotSetUpDialog(
                    trainingsStartDate:
                        database.actionDeadlines[SimulationActionType.settingUpTraining]!,
                  ),
                );
              } else {
                setState(() {
                  _selectedMode = selected.single;
                });
              }
            },
          ),
        ),
        const Gap(15),
        Expanded(
          child: ListView(
            children: [
              for (var jumper in jumpers)
                AnimatedSize(
                  duration: Durations.short1,
                  curve: Curves.easeIn,
                  child: TeamScreenJumperCard(
                    jumper: jumper,
                    mode: _selectedMode,
                    onTrainingChange: (training) {
                      final changedDynamicParams = database.jumpersDynamicParameters;
                      changedDynamicParams[jumper] =
                          database.jumpersDynamicParameters[jumper]!.copyWith(
                        trainingConfig: training,
                      );
                      final changedDatabase = database.copyWith(
                        jumpersDynamicParameters: changedDynamicParams,
                      );
                      context.read<SimulationDatabaseCubit>().update(changedDatabase);
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

List<Jumper> sjmTestJumpersList({
  required SimulationDatabase database,
}) {
  final jumpers = database.jumpers.last;
  return [
    jumpers.singleWhere((jumper) => jumper.surname == 'Żyła'),
    jumpers.singleWhere((jumper) => jumper.surname == 'Wolny'),
    jumpers.singleWhere((jumper) => jumper.surname == 'Forfang'),
  ];
}
