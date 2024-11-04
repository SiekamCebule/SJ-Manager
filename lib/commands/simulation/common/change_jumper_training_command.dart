import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/commands/simulation/common/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class ChangeJumperTrainingCommand {
  const ChangeJumperTrainingCommand({
    required this.context,
    required this.database,
    required this.jumper,
    required this.trainingConfig,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final Jumper jumper;
  final JumperTrainingConfig trainingConfig;

  void execute() {
    final changedDynamicParams = database.jumperDynamicParams;
    changedDynamicParams[jumper] = database.jumperDynamicParams[jumper]!.copyWith(
      trainingConfig: trainingConfig,
    );
    final changedDatabase = database.copyWith(
      jumperDynamicParams: changedDynamicParams,
    );
    context.read<SimulationDatabaseCubit>().update(changedDatabase);
  }
}
