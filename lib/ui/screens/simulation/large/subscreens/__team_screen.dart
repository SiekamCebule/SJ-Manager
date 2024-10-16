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
    final dbHelper = context.read<SimulationDatabaseHelper>();
    final trainingsAreSetUp =
        database.actionsRepo.isCompleted(SimulationActionType.settingUpTraining);
    final jumpers = dbHelper.managerJumpers;

    final jumpersBody = jumpers.isNotEmpty
        ? ListView(
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
          )
        : TeamScreenNoJumpersInfoWidget(
            mode: database.managerData.mode,
            searchForCandidates: _searchForCandidates,
          );

    return Scaffold(
      bottomNavigationBar: database.managerData.mode == SimulationMode.personalCoach
          ? TeamScreenPersonalCoachBottomBar(
              searchForCandidates: _searchForCandidates,
            )
          : null,
      body: Column(
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton(
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
                          trainingsStartDate: database
                              .actionDeadlines[SimulationActionType.settingUpTraining]!,
                        ),
                      );
                    } else {
                      setState(() {
                        _selectedMode = selected.single;
                      });
                    }
                  },
                ),
                const Gap(5),
                TextButton(
                  onPressed: () async {
                    await showSjmDialog(
                      context: context,
                      child: const TrainingTutorialDialog(),
                    );
                  },
                  child: const Text(
                    'Jak przeprowadzać trening?',
                  ),
                ),
              ],
            ),
          ),
          const Gap(15),
          Expanded(
            child: jumpersBody,
          ),
        ],
      ),
    );
  }

  void _searchForCandidates() async {
    final database = context.read<SimulationDatabaseCubit>().state;
    final jumpers = database.jumpers.last
        .where(
          (jumper) =>
              database.managerData.personalCoachJumpers!.contains(jumper) == false,
        )
        .toList();

    await showSjmDialog(
      barrierDismissible: true,
      context: context,
      child: BlocProvider.value(
        value: context.read<SimulationDatabaseCubit>(),
        child: MultiProvider(
          providers: [
            Provider.value(value: context.read<CountryFlagsRepo>()),
            Provider.value(value: context.read<DbItemImageGeneratingSetup<Jumper>>()),
          ],
          child: SearchForChargesJumpersDialog(
            jumpers: jumpers,
            onSubmit: (jumper) {
              final changedPersonalCoachJumpers = [
                ...database.managerData.personalCoachJumpers!,
                jumper
              ];
              final changedManagerData = database.managerData
                  .copyWith(personalCoachJumpers: changedPersonalCoachJumpers);
              final changedDynamicParams = Map.of(database.jumpersDynamicParameters);
              changedDynamicParams[jumper] = changedDynamicParams[jumper]!.copyWith(
                trainingConfig: const JumperTrainingConfig(
                    trainingRisk: TrainingRisk.balanced,
                    points: initialJumperTrainingPoints),
              );
              final changedDatabase = database.copyWith(
                managerData: changedManagerData,
                jumpersDynamicParameters: changedDynamicParams,
              );
              context.read<SimulationDatabaseCubit>().update(changedDatabase);
            },
          ),
        ),
      ),
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
