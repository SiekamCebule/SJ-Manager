part of '../../../simulation_route.dart';

class _TeamOverviewCard extends StatelessWidget {
  const _TeamOverviewCard();

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabase>();
    final dbHelper = context.read<SimulationDatabaseHelper>();
    final jumpers = dbHelper.managerJumpers;

    print('Before TeamOverviewCard build: ${database.subteamJumpers}');

    final jumpersNonEmptyContent = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeamSummaryCard(
          excludeTitle: true,
          reports: database.teamReports[dbHelper.managerTeam]!,
        ),
        const Gap(15),
        Expanded(
          child: ListView(
            children: [
              for (var jumper in jumpers)
                Builder(builder: (context) {
                  print('_TeamOverviewCard jumper: ${jumper.nameAndSurname()}');
                  print('_TeamOverviewCard jumpers length: ${jumpers.length}');
                  final report = database.jumperReports[jumper];
                  if (report == null) {
                    throw StateError(
                      'Prosimy o zgłoszenie nam tego błędu. Skoczek ($jumper) nie posiada swojego JumperReports w bazie danych symulacji',
                    );
                  }
                  return JumperInTeamOverviewCard(
                    reports: report,
                    jumper: jumper,
                    subteamType: dbHelper.subteamOfJumper(jumper),
                    hideLinks: true,
                  );
                }),
            ],
          ),
        ),
      ],
    );
    const double emptyStateWidgetMaxWidth = 400;
    final content = jumpers.isEmpty
        ? ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: emptyStateWidgetMaxWidth),
            child: TeamOverviewCardNoJumpersInfoWidget(
              mode: database.managerData.mode,
            ),
          )
        : jumpersNonEmptyContent;

    return CardWithTitle(
      title: Row(
        children: [
          Text(
            'Zespół',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Gap(10),
          LinkTextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                '/simulation/team',
                arguments: TeamScreenMode.overview,
              );
              context
                  .read<SimulationScreenNavigationCubit>()
                  .change(screen: SimulationScreenNavigationTarget.team);
            },
            labelText: 'Przejdź',
          ),
        ],
      ),
      child: Center(child: content),
    );
  }
}
