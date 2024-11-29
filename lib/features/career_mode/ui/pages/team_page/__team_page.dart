part of '../main_page/simulation_route.dart';

class _TeamPage extends StatefulWidget {
  const _TeamPage({
    this.initialMode = TeamScreenMode.overview,
  });

  final TeamScreenMode initialMode;

  @override
  State<_TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<_TeamPage> {
  late TeamScreenMode _selectedMode;

  @override
  void initState() {
    _selectedMode = widget.initialMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final actionsState =
        context.watch<SimulationActionsCubit>().state as SimulationActionsDefault;
    final managerDataState =
        context.watch<SimulationManagerCubit>().state as SimulationManagerDefault;
    final teamReportsState =
        context.watch<TeamReportsCubit>().state as TeamReportsDefault;

    final noJumpersWidget = TeamScreenNoJumpersInfoWidget(
      mode: managerDataState.mode,
      searchForCandidates: () async {
        final jumper = await showSearchForChargesDialog(context: context);
        if (jumper != null && context.mounted) {
          context.read<SimulationManagerCubit>().addManagerCharge(jumper);
        }
      },
    );

    final generalBody = managerDataState.charges.isNotEmpty
        ? ListView(
            children: [
              for (var jumper in managerDataState.charges)
                AnimatedSize(
                  duration: Durations.short1,
                  curve: Curves.easeIn,
                  child: JumperInTeamOverviewCard(
                    jumper: jumper,
                    subteamType: jumper.subteam!.type,
                    reports: jumper.reports,
                  ),
                ),
            ],
          )
        : noJumpersWidget;

    final trainingBody = JumperTrainingManagerRow(noJumpersWidget: noJumpersWidget);

    final bottomNavBar = managerDataState.mode == SimulationMode.personalCoach
        ? TeamScreenPersonalCoachBottomBar(
            chargesCount: managerDataState.charges.length,
            chargesLimit: sjmManagerChargesLimit,
            searchForCandidates: () async {
              final jumper = await showSearchForChargesDialog(context: context);
              if (jumper != null && context.mounted) {
                context.read<SimulationManagerCubit>().addManagerCharge(jumper);
              }
            },
            managePartnerships: () async {
              final result = await showManagePartnershipsDialog(context: context);
              if (!context.mounted) return;
              context.read<SimulationManagerCubit>().setManagerCharges(result.newOrder);
            })
        : null;

    return Scaffold(
      bottomNavigationBar: bottomNavBar,
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
                      reports: teamReportsState.reports[managerDataState.team]!,
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
                      value: TeamScreenMode.overview,
                      label: Text('Ogólnie'),
                      icon: Icon(Symbols.dashboard),
                    ),
                    ButtonSegment(
                      value: TeamScreenMode.training,
                      label: Text('Trening'),
                      icon: Icon(Symbols.fitness_center),
                    ),
                  ],
                  selected: {_selectedMode},
                  onSelectionChanged: (selected) async {
                    if (!actionsState
                        .isCompleted[SimulationActionType.settingUpTraining]!) {
                      await showSjmDialog(
                        barrierDismissible: true,
                        context: context,
                        child: TrainingsAreNotSetUpDialog(
                          trainingsStartDate: actionsState
                              .deadline[SimulationActionType.settingUpTraining]!,
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
            child: _selectedMode == TeamScreenMode.overview ? generalBody : trainingBody,
          ),
        ],
      ),
    );
  }
}

enum TeamScreenMode {
  overview,
  training,
}
