part of '../../../simulation_route.dart';

class _TeamOverviewCard extends StatelessWidget {
  const _TeamOverviewCard();

  @override
  Widget build(BuildContext context) {
    final goButtonStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Zespół',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Gap(10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/simulation/team');
                  },
                  child: Text(
                    'Przejdź',
                    style: goButtonStyle,
                  ),
                ),
              ],
            ),
            const Gap(15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Card(
                elevation: 2,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: Row(
                  children: [
                    Text(
                      'Ogólnie bardzo dobre morale',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: darkThemeSimpleRatingColors[SimpleRating.veryGood]),
                    ),
                    const Gap(15),
                    const Icon(Symbols.emoji_emotions),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Card(
                elevation: 2,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: Row(
                  children: [
                    Text(
                      'Ogólnie przeciętne wyniki',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: darkThemeSimpleRatingColors[SimpleRating.correct]),
                    ),
                    const Gap(15),
                    const Icon(Symbols.analytics),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Card(
                elevation: 2,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: Row(
                  children: [
                    Text(
                      'Ogólnie efektywny trening',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: darkThemeSimpleRatingColors[SimpleRating.good]),
                    ),
                    const Gap(15),
                    const Icon(Symbols.fitness_center),
                  ],
                ),
              ),
            ),
            const Gap(15),
            Expanded(
              child: ListView(
                children: [
                  JumperInTeamCard(
                    jumper: context
                        .read<SimulationDatabase>()
                        .jumpers
                        .last
                        .singleWhere((jumper) => jumper.surname == 'Żyła'),
                  ),
                  JumperInTeamCard(
                    jumper: context
                        .read<SimulationDatabase>()
                        .jumpers
                        .last
                        .singleWhere((jumper) => jumper.surname == 'Wolny'),
                  ),
                  JumperInTeamCard(
                    jumper: context
                        .read<SimulationDatabase>()
                        .jumpers
                        .last
                        .singleWhere((jumper) => jumper.surname == 'Kytosaho'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
