import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/algorithms/jumpers_ranking/country_team_ranking_creator.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/ui/reusable_widgets/card_with_title.dart';
import 'package:sj_manager/ui/reusable_widgets/jumpers_ranking/team_jumpers_ranking_list.dart';

class CountryTeamProfileOverview extends StatelessWidget {
  const CountryTeamProfileOverview({
    super.key,
    required this.countryTeam,
  });

  final CountryTeam countryTeam;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabaseCubit>().state;
    final unorderedJumpers = database.jumpers.last.where((jumper) =>
        jumper.country == countryTeam.country && jumper.sex == countryTeam.sex);

    final ranking = CountryTeamRankingCreator(
            jumpers: unorderedJumpers.toList(),
            dynamicParams: database.jumperDynamicParams)
        .create();

    return Row(
      children: [
        SizedBox(
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: CardWithTitle(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  title: Text(
                    'Ranking',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  child: ranking.isNotEmpty
                      ? TeamJumpersRankingList(
                          jumpers: ranking,
                        )
                      : const Center(
                          child: Text('Brak zawodników'),
                        ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: CardWithTitle(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  title: Text(
                    'Informacje',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  child: const SizedBox.expand(
                    child: Placeholder(
                      child: Center(child: Text('Jeszcze nie dodano...')),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.titleText,
    required this.right,
  });

  final String titleText;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          titleText,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        right,
      ],
    );
  }
}

// ranking skoczków
// perspektywa
// podstawowe rekordy (wygranych konkursow druż pś, wygranych konkursów ind pś)
// gwiazdki
// płeć na fladze
//
