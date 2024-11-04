import 'package:flutter/material.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';

class SetUpSubteamsCommand {
  SetUpSubteamsCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  SimulationDatabase execute() {
    database.actionsRepo.complete(SimulationActionType.settingUpSubteams);
    return database;
  }
}
