import 'package:sj_manager/core/classes/country_team/country_team.dart';
import 'package:sj_manager/data/models/user_simulation/simulation_model.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';

class Simulation {
  const Simulation({
    required this.id,
    required this.name,
    required this.database,
  });

  Simulation.fromModel(
    SimulationModel model, {
    required SimulationDatabase database,
  }) : this(
          id: model.id,
          name: model.name,
          database: database,
        );

  SimulationModel toModel() {
    return SimulationModel(
      id: id,
      name: name,
      saveTime: DateTime.now(),
      mode: database.managerData.mode,
      subteamCountryFlagName:
          '${(database.managerData.userSubteam?.parentTeam as CountryTeam?)?.country.code}.jpg',
    );
  }

  final String id;
  final String name;
  final SimulationDatabase database;

  Simulation copyWith({
    String? id,
    String? name,
    SimulationDatabase? database,
  }) {
    return Simulation(
      id: id ?? this.id,
      name: name ?? this.name,
      database: database ?? this.database,
    );
  }
}
