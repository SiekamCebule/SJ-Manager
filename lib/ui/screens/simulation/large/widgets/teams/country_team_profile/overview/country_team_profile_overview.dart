import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/algorithms/jumpers_ranking/country_team_ranking_creator.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
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
    final subteams = database.subteamJumpers.keys.where(
      (subteam) => subteam.parentTeam == countryTeam,
    );
    final unorderedJumpers = <Jumper>[];
    for (var subteam in subteams) {
      final jumperIds = database.subteamJumpers[subteam]!;
      unorderedJumpers.addAll(
        jumperIds.map((id) => database.idsRepo.get(id) as Jumper),
      );
    }
    final ranking = CountryTeamRankingCreator(
            jumpers: unorderedJumpers, dynamicParams: database.jumperDynamicParams)
        .create();

    return Row(
      children: [
        SizedBox(
          width: 250,
          child: CardWithTitle(
            title: Text(
              'Ranking',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            child: TeamJumpersRankingList(
              jumpers: ranking,
            ),
          ),
        )
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
