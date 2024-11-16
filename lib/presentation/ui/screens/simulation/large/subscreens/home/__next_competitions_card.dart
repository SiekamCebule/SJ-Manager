part of '../../../simulation_route.dart';

class _NextCompetitionCard extends StatelessWidget {
  const _NextCompetitionCard();

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      title: Row(
        children: [
          Text(
            'Następny konkurs: ',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Gap(5),
          Text(
            'Engelberg HS140',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Gap(5),
          CountryFlag(
            country: context.read<CountriesRepo>().byCode('ch'),
            width: 25,
          ),
          const Gap(5),
          Text(
            '(PŚ)',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            columnWidths: const {
              0: FixedColumnWidth(80),
              1: FlexColumnWidth(1),
              2: FixedColumnWidth(140),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.symmetric(
              inside: BorderSide(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                width: 1,
              ),
            ),
            children: [
              TableRow(
                children: [
                  Text(
                    'Kiedy?',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    'Skocznia',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    'Cykl zawodów',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text(
                    'Dziś',
                  ),
                  Row(
                    children: [
                      Text('Engelberg HS140'),
                      const Gap(5),
                      CountryFlag(
                        country: context.read<CountriesRepo>().byCode('ch'),
                        height: 15,
                      ),
                    ],
                  ),
                  Text('PŚ'),
                ],
              ),
              TableRow(
                children: [
                  Text(
                    'Dziś',
                  ),
                  Row(
                    children: [
                      Text('Vikersund HS117'),
                      const Gap(5),
                      CountryFlag(
                        country: context.read<CountriesRepo>().byCode('no'),
                        height: 15,
                      ),
                    ],
                  ),
                  Text('PK'),
                ],
              ),
              TableRow(
                children: [
                  Text(
                    'Jutro',
                  ),
                  Row(
                    children: [
                      Text('Engelberg HS140'),
                      const Gap(5),
                      CountryFlag(
                        country: context.read<CountriesRepo>().byCode('ch'),
                        height: 15,
                      ),
                    ],
                  ),
                  Text('PŚ'),
                ],
              ),
              TableRow(
                children: [
                  Text(
                    'Za 6 dni',
                  ),
                  Row(
                    children: [
                      Text('Wisła HS134'),
                      const Gap(5),
                      CountryFlag(
                        country: context.read<CountriesRepo>().byCode('pl'),
                        height: 15,
                      ),
                    ],
                  ),
                  Text('MK (Polska)'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
