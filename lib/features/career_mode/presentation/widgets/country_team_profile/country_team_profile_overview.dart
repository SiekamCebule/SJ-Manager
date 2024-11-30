import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/country_team_profile_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/simulation_cubit.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/general_ui/reusable_widgets/card_with_title.dart';
import 'package:sj_manager/general_ui/reusable_widgets/jumpers_ranking/team_jumpers_ranking_list.dart';

class CountryTeamProfileOverview extends StatelessWidget {
  const CountryTeamProfileOverview({
    super.key,
    required this.countryTeam,
  });

  final CountryTeam countryTeam;

  @override
  Widget build(BuildContext context) {
    final simulationState =
        context.watch<SimulationCubit>().state as SimulationInitialized;
    final teamProfileState =
        context.watch<CountryTeamProfileCubit>().state as CountryTeamProfileDefault;

    late Widget rankingWidget;
    if (simulationState.actionIsCompleted[SimulationActionType.settingUpTraining]!) {
      rankingWidget = teamProfileState.ranking.isNotEmpty
          ? TeamJumpersRankingList(
              jumpers: teamProfileState.ranking,
            )
          : Center(
              child: Text(
                countryTeam.sex == Sex.male
                    ? translate(context).noMaleJumpers
                    : translate(context).noFemaleJumpers,
              ),
            );
    } else {
      rankingWidget = Center(
        child: Text(translate(context).rankingWillShowUpAfterTrainingsStart),
      );
    }

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
                  child: rankingWidget,
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
