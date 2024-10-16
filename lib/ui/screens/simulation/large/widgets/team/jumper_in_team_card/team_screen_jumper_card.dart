import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_in_team_card/jumper_in_team_overview_card.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_in_team_card/jumper_in_team_training_card.dart';

class TeamScreenJumperCard extends StatelessWidget {
  const TeamScreenJumperCard({
    super.key,
    required this.jumper,
    required this.mode,
    required this.onTrainingChange,
  });

  final Jumper jumper;
  final TeamScreenJumperCardMode mode;
  final Function(JumperTrainingConfig trainingConfig) onTrainingChange;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabaseCubit>().state;
    final trainingConfig = database.jumpersDynamicParameters[jumper]!.trainingConfig;
    if (trainingConfig == null && mode == TeamScreenJumperCardMode.training) {
      throw StateError(
        'Prosimy o zgłoszenie nam tego błędu. Nie można wyświetlić informacji o treningu skoczka, gdyż JumperTrainingConfig skoczka jest nullem (skoczek: $jumper).',
      );
    }

    final mainBody = mode == TeamScreenJumperCardMode.overview
        ? JumperInTeamOverviewCard(
            jumper: jumper,
            reports: database.jumpersReports[jumper]!,
          )
        : JumperInTeamTrainingCard(
            jumper: jumper,
            jumperRatings: database.jumpersReports[jumper]!,
            trainingConfig: trainingConfig!,
            onTrainingChange: onTrainingChange,
            managerPointsCount: database.managerData.trainingPoints,
          );

    return AnimatedSize(
      duration: Durations.short1,
      curve: Curves.easeIn,
      child: mainBody,
    );
  }
}

enum TeamScreenJumperCardMode {
  overview,
  training,
}
