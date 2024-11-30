import 'package:sj_manager/features/simulations/data/models/simulation_database_model.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

extension SimulationDatabaseToModel on SimulationDatabase {
  SimulationDatabaseModel toModel({
    required DateTime saveTime,
  }) {
    return SimulationDatabaseModel(
      managerData: managerData,
      startDate: startDate,
      currentDate: saveTime, // Zapisuje czas bieżący jako `currentDate`
      jumpers: jumpers,
      hills: hills,
      countries: countries,
      countryTeams: countryTeams,
      seasons: seasons,
      idsRepository: idsRepository,
      actions: actions,
    );
  }
}

SimulationDatabase simulationDatabaseFromModel(SimulationDatabaseModel model) {
  return SimulationDatabase(
    managerData: model.managerData,
    startDate: model.startDate,
    currentDate: model.currentDate,
    jumpers: model.jumpers,
    hills: model.hills,
    countries: model.countries,
    countryTeams: model.countryTeams,
    seasons: model.seasons,
    idsRepository: model.idsRepository,
    actions: model.actions,
  );
}
