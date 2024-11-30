import 'dart:async';

import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class SimulationJumperSerializer implements SimulationDbPartSerializer<SimulationJumper> {
  const SimulationJumperSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  FutureOr<Json> serialize(SimulationJumper jumper) {
    return {
      'dateOfBirth': jumper.dateOfBirth,
      'name': jumper.name,
      'surname': jumper.surname,
      'countryCode': jumper.country.code,
      'countryTeamId': idsRepository.id(jumper.countryTeam),
      'subteamId': idsRepository.maybeId(jumper.subteam),
      'sex': jumper.sex.name,
      'takeoffQuality': jumper.takeoffQuality,
      'flightQuality': jumper.flightQuality,
      'landingQuality': jumper.landingQuality,
      'trainingConfig': jumper.trainingConfig?.toJson(),
      'form': jumper.form,
      'jumpsConsistency': jumper.jumpsConsistency,
      'morale': jumper.morale,
      'fatigue': jumper.fatigue,
      'levelOfConsciousness': jumper.levelOfConsciousness.toJson(),
      'reports': jumper.reports.toJson(),
      'stats': jumper.stats.toJson(),
    };
  }
}
