import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/presentation/bloc/simulation_actions_cubit.dart';
import 'package:sj_manager/features/career_mode/subfeatures/current_date/presentation/bloc/simulation_current_date_cubit.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/presentation/bloc/country_team_profile_cubit.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/career_mode/ui/pages/country_team_profile/subteams/country_team_profile_subteams_not_available.dart';
import 'package:sj_manager/features/career_mode/ui/pages/country_team_profile/subteams/country_team_profile_subteams_non_empty.dart';

class CountryTeamProfileSubteams extends StatelessWidget {
  const CountryTeamProfileSubteams({
    super.key,
    required this.countryTeam,
  });

  final CountryTeam countryTeam;

  @override
  Widget build(BuildContext context) {
    final currentDateState =
        context.watch<SimulationCurrentDateCubit>().state as SimulationCurrentDateDefault;
    final actionsState =
        context.watch<SimulationActionsCubit>().state as SimulationActionsDefault;
    final countryProfileState =
        context.watch<CountryTeamProfileCubit>().state as CountryTeamProfileDefault;

    if (countryProfileState.subteams.isEmpty &&
        !actionsState.isCompleted[SimulationActionType.settingUpSubteams]!) {
      return CountryTeamProfileSubteamsNotAvailable(
        currentDate: currentDateState.currentDate,
        settingUpSubteamsDeadline:
            actionsState.deadline[SimulationActionType.settingUpSubteams]!,
      );
    } else if (countryProfileState.subteams.isEmpty &&
        actionsState.isCompleted[SimulationActionType.settingUpSubteams]!) {
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
