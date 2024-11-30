import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/country_team_profile_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/simulation_cubit.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/country_team_profile/subteams/country_team_profile_subteams_not_available.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/country_team_profile/subteams/country_team_profile_subteams_non_empty.dart';

class CountryTeamProfileSubteams extends StatelessWidget {
  const CountryTeamProfileSubteams({
    super.key,
    required this.countryTeam,
  });

  final CountryTeam countryTeam;

  @override
  Widget build(BuildContext context) {
    final simulationState =
        context.watch<SimulationCubit>().state as SimulationInitialized;
    final countryProfileState =
        context.watch<CountryTeamProfileCubit>().state as CountryTeamProfileDefault;

    if (countryProfileState.subteams.isEmpty &&
        !simulationState.actionIsCompleted[SimulationActionType.settingUpSubteams]!) {
      return CountryTeamProfileSubteamsNotAvailable(
        currentDate: simulationState.currentDate,
        settingUpSubteamsDeadline:
            simulationState.actionDeadline[SimulationActionType.settingUpSubteams]!,
      );
    } else if (countryProfileState.subteams.isEmpty &&
        simulationState.actionIsCompleted[SimulationActionType.settingUpSubteams]!) {
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
        subteams: countryProfileState.subteams,
      );
    }
  }
}
