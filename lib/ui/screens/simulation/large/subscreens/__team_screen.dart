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
                    onTrainingChange: (trainingConfig) {
                      ChangeJumperTrainingCommand(
                        context: context,
                        database: database,
                        jumper: jumper,
                        trainingConfig: trainingConfig,
                      ).execute();
                    },
                  ),
                ),
            ],
          )
        : TeamScreenNoJumpersInfoWidget(
            mode: database.managerData.mode,
            searchForCandidates: () =>
                SearchForCandidatesCommand(context: context, database: database)
                    .execute(),
          );

    return Scaffold(
      bottomNavigationBar: database.managerData.mode == SimulationMode.personalCoach
          ? TeamScreenPersonalCoachBottomBar(
              chargesCount: database.managerData.personalCoachTeam!.jumpers.length,
              chargesLimit: sjmManagerChargesLimit,
              searchForCandidates: () =>
                  SearchForCandidatesCommand(context: context, database: database)
                      .execute(),
              endPartnership: () =>
                  ManagePartnershipsCommand(context: context, database: database)
                      .execute(),
            )
          : null,
      body: Column(
        children: [
          SizedBox(
            height: 170,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    child: TeamSummaryCard(
                      reports: database.teamReports[dbHelper.managerTeam]!,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Placeholder(),
                ),
                const Expanded(
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
                        barrierDismissible: true,
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
                      barrierDismissible: true,
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
}
