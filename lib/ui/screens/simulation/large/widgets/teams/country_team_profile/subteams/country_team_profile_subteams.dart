import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/teams/country_team_profile/subteams/country_team_profile_subteams_not_available.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/teams/country_team_profile/subteams/country_team_profile_subteams_non_empty.dart';

class CountryTeamProfileSubteams extends StatelessWidget {
  const CountryTeamProfileSubteams({
    super.key,
    required this.countryTeam,
  });

  final CountryTeam countryTeam;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabaseCubit>().state;
    final subteams = database.subteamJumpers.keys
        .where((subteam) => subteam.parentTeam == countryTeam)
      ..sorted((first, second) => first.type.index.compareTo(second.type.index));
    if (subteams.isEmpty &&
        database.actionsRepo.isNotCompleted(SimulationActionType.settingUpSubteams)) {
      return CountryTeamProfileSubteamsNotAvailable(
        currentDate: database.currentDate,
        settingUpSubteamsDeadline:
            database.actionDeadlines[SimulationActionType.settingUpSubteams]!,
      );
    } else if (subteams.isEmpty &&
        database.actionsRepo.isCompleted(SimulationActionType.settingUpSubteams)) {
      return Center(
        child: Text(
          'Brak zawodników w drużynie',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    } else {
      return CountryTeamProfileSubteamsNonEmpty(
        subteams: subteams.toList(),
        jumpers: database.subteamJumpers.map(
          (subteam, ids) => MapEntry(
            subteam,
            ids.map((id) => database.idsRepo.get(id) as Jumper).toList(),
          ),
        ),
      );
    }
  }
}
