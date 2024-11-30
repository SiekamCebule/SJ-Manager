import 'package:sj_manager/core/general_utils/iterable.dart';
import 'package:sj_manager/core/general_utils/json/countries.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/general_utils/json/utils/enums.dart';

import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class SimulationTeamLoader implements SimulationDbPartParser<SimulationTeam> {
  const SimulationTeamLoader({
    required this.idsRepository,
    required this.countryLoader,
  });

  final IdsRepository idsRepository;
  final JsonCountryLoader countryLoader;

  @override
  Future<SimulationTeam> parse(Json json) async {
    final type = json['type'];
    return switch (type) {
      'country_team' => await _parseCountryTeam(json),
      'subteam' => await _parseSubteam(json),
      _ => throw ArgumentError('(Team parsing): An invalid team\'s type ($type)'),
    };
  }

  Future<CountryTeam> _parseCountryTeam(Json json) async {
    final sex = sexEnumMap.keys.singleWhere((sex) => sexEnumMap[sex]! == json['sex']);
    final country = await countryLoader.load(json['countryCode']);
    final subteamsJson = json['subteams'] as List;
    final subteams = await subteamsJson.asyncMap(
      (subteamJson) async => await parse(subteamJson),
    );
    return CountryTeam(
      sex: sex,
      country: country,
      subteams: subteams.cast(),
    );
  }

  Future<Subteam> _parseSubteam(Json json) async {
    final parentTeamJson = json['parentTeam'] as Json;
    final parentTeam = await parse(parentTeamJson);
    final typeName = json['subteamType'] as String;
    final jumperIds = json['jumperIds'] as List;
    final jumpers = jumperIds.map((id) {
      return idsRepository.get(id) as SimulationJumper;
    }).toList();

    return Subteam(
      parentTeam: parentTeam as CountryTeam,
      type: SubteamType.values.singleWhere((subteamType) => subteamType.name == typeName),
      jumpers: jumpers,
      limit: json['limit'],
    );
  }
}
