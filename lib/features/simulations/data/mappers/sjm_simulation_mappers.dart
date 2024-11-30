import 'package:sj_manager/features/simulations/data/models/sjm_simulation_model.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';

extension SjmSimulationToModel on SjmSimulation {
  SjmSimulationModel toModel({
    required DateTime saveTime,
    required SimulationMode mode,
  }) {
    return SjmSimulationModel(
      id: id,
      name: name,
      saveTime: saveTime,
      mode: mode,
      currentDate: currentDate,
      traineesCount: traineesCount,
      subteamCountryName: subteamCountryName,
      subteamType: subteamType,
    );
  }
}

SjmSimulation sjmSimulationFromModel(SjmSimulationModel model) {
  return SjmSimulation(
    id: model.id,
    name: model.name,
    saveTime: model.saveTime,
    mode: model.mode,
    currentDate: model.currentDate,
    traineesCount: model.traineesCount,
    subteamCountryName: model.subteamCountryName,
    subteamType: model.subteamType,
  );
}
