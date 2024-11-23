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
      subteamJumpers: subteamJumpers,
      seasons: seasons,
      idsRepository: idsRepository,
      actionDeadlines: actionDeadlines,
      actionsRepo: actionsRepo,
      teamReports: teamReports,
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
    subteamJumpers: model.subteamJumpers,
    seasons: model.seasons,
    idsRepository: model.idsRepository,
    actionDeadlines: model.actionDeadlines,
    actionsRepo: model.actionsRepo,
    teamReports: model.teamReports,
  );
}
