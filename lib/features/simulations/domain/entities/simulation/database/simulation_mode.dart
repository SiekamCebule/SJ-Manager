import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';

enum SimulationMode {
  classicCoach,
  personalCoach,
  observer,
}

final possibleActionsBySimulationMode = <SimulationMode, List<SimulationActionType>>{
  SimulationMode.classicCoach: [
    SimulationActionType.settingUpTraining,
    SimulationActionType.settingUpSubteams,
  ],
  SimulationMode.personalCoach: [
    SimulationActionType.settingUpTraining,
  ],
  SimulationMode.observer: [],
};
