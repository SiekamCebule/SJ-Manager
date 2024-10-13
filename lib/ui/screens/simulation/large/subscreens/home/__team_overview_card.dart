part of '../../../simulation_route.dart';

class _TeamOverviewCard extends StatelessWidget {
  const _TeamOverviewCard();

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabaseCubit>().state;
    final jumpers = sjmTestJumpersList(database: database);

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
              Navigator.of(context).pushReplacementNamed('/simulation/team');
              context.read<SimulationScreenNavigationCubit>().change(index: 1);
            },
            labelText: 'Przejdź',
          ),
        ],
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TeamSummaryCard(),
          const Gap(15),
          Expanded(
            child: ListView(
              children: [
                for (var jumper in jumpers)
                  JumperInTeamOverviewCard(
                    jumper: jumper,
                    hideLinks: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
