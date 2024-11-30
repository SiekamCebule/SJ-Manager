part of '../main_page/simulation_route.dart';

class _TeamOverviewCard extends StatelessWidget {
  const _TeamOverviewCard();

  @override
  Widget build(BuildContext context) {
    final managerState = context.watch<ManagerCubit>().state as ManagerDefault;
    final myTeamState = context.watch<MyTeamCubit>().state as MyTeamDefault;
    final trainees = myTeamState.trainees;
    final managerTeamReports = myTeamState.teamReports;

    final jumpersNonEmptyContent = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeamSummaryCard(
          excludeTitle: true,
          reports: managerTeamReports,
        ),
        const Gap(15),
        Expanded(
          child: ListView(
            children: [
              for (var jumper in trainees)
                Builder(
                  builder: (context) {
                    return JumperInTeamOverviewCard(
                      reports: jumper.reports,
                      jumper: jumper,
                      subteamType: jumper.subteam?.type,
                      hideLinks: true,
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
    const double emptyStateWidgetMaxWidth = 400;
    final content = trainees.isEmpty
        ? ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: emptyStateWidgetMaxWidth),
            child: TeamOverviewCardNoJumpersInfoWidget(
              mode: managerState.mode,
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
