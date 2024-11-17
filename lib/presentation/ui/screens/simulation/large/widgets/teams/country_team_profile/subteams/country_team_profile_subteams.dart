import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/domain/entities/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_database.dart/sex.dart';
import 'package:sj_manager/core/team/country_team/country_team.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/large/widgets/teams/country_team_profile/subteams/country_team_profile_subteams_not_available.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/large/widgets/teams/country_team_profile/subteams/country_team_profile_subteams_non_empty.dart';

class CountryTeamProfileSubteams extends StatelessWidget {
  const CountryTeamProfileSubteams({
    super.key,
    required this.countryTeam,
  });

  final CountryTeam countryTeam;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabase>();
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
          countryTeam.sex == Sex.male
              ? translate(context).noMaleJumpersInTeam
              : translate(context).noFemaleJumpersInTeam,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    } else {
      return CountryTeamProfileSubteamsNonEmpty(
        subteams: subteams.toList(),
        jumpers: database.subteamJumpers.map(
          (subteam, ids) => MapEntry(
            subteam,
            ids.map((id) => database.idsRepo.get(id) as SimulationJumper).toList(),
          ),
        ),
      );
    }
  }
}
