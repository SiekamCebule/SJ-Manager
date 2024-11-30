import 'dart:async';

import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/core/general_utils/json/countries.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/psyche/level_of_consciousness.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/stats/jumper_stats.dart';

class SimulationJumperLoader implements SimulationDbPartParser<SimulationJumper> {
  const SimulationJumperLoader({
    required this.idsRepository,
    required this.countryLoader,
  });

  final IdsRepository idsRepository;
  final JsonCountryLoader countryLoader;

  @override
  Future<SimulationJumper> parse(Json json) async {
    return SimulationJumper(
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      name: json['name'],
      surname: json['surname'],
      country: await countryLoader.load(json['countryCode']),
      countryTeam: idsRepository.get(json['countryTeamId']),
      subteam: idsRepository.get(json['subteamId']),
      sex: Sex.values.singleWhere((sex) => sex.name == json['sex']),
      takeoffQuality: json['takeoffQuality'],
      flightQuality: json['flightQuality'],
      landingQuality: json['landingQuality'],
      trainingConfig: json['trainingConfig'],
      form: json['form'],
      jumpsConsistency: json['jumpsConsistency'],
      morale: json['morale'],
      fatigue: json['fatigue'],
      levelOfConsciousness: LevelOfConsciousness.fromJson(json['levelOfConsciousness']),
      reports: JumperReports.fromJson(json['reports']),
      stats: JumperStats.fromJson(json['stats']),
    );
  }
}
