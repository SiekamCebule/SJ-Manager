import 'package:sj_manager/core/general_utils/json/countries.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/general_utils/json/utils/enums.dart';

import 'package:sj_manager/core/core_classes/country_team/country_team_facts_model.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/core_classes/jumps/simple_jump_model.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/competition_team.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class TeamLoader implements SimulationDbPartParser<Team> {
  const TeamLoader({
    required this.idsRepository,
    required this.countryLoader,
  });

  final IdsRepository idsRepository;
  final JsonCountryLoader countryLoader;

  @override
  Future<Team> parse(Json json) async {
    final type = json['type'];
    return switch (type) {
      'country_team' => await _parseCountryTeam(json),
      'competition_team' => _parseCompetitionTeam(json),
      'subteam' => _parseSubteam(json),
      _ => throw ArgumentError('(Team parsing): An invalid team\'s type ($type)'),
    };
  }

  Future<CountryTeam> _parseCountryTeam(Json json) async {
    return await loadCountryTeamFromJson(json, countryLoader: countryLoader);
  }

  Future<CompetitionTeam<Team>> _parseCompetitionTeam(Json json) async {
    final parentTeamJson = json['parentTeam'] as Json;
    final parentTeam = await parse(parentTeamJson);
    final jumperIds = json['jumperIds'] as List;
    final jumpers = jumperIds.map((id) {
      return idsRepository.get(id) as JumperDbRecord;
    }).toList();

    return CompetitionTeam(
      parentTeam: parentTeam,
      jumpers: jumpers,
    );
  }

  Future<Subteam> _parseSubteam(Json json) async {
    final parentTeamJson = json['parentTeam'] as Json;
    final parentTeam = await parse(parentTeamJson);
    final typeName = json['subteamType'] as String;

    return Subteam(
      parentTeam: parentTeam,
      type: SubteamType.values.singleWhere((subteamType) => subteamType.name == typeName),
    );
  }
}

Future<CountryTeam> loadCountryTeamFromJson(
  Json json, {
  required JsonCountryLoader countryLoader,
}) async {
  final sex = sexEnumMap.keys.singleWhere((sex) => sexEnumMap[sex]! == json['sex']);
  final country = await countryLoader.load(json['countryCode']);
  final factsJson = json['facts'] as Json;
  final nationalRecordJson = factsJson['record'] as Json?;
  final subteamsJson = (factsJson['subteams'] as List).cast<String>();
  final subteams = subteamsJson.map((subteamTypeName) {
    return SubteamType.values.singleWhere((type) => type.name == subteamTypeName);
  }).toSet();
  final limitInSubteamJson = factsJson['limitInSubteam'] as Map;
  return CountryTeam(
    sex: sex,
    country: country,
    facts: CountryTeamFactsModel(
      stars: factsJson['stars'],
      record: nationalRecordJson != null
          ? SimpleJumpModel(
              jumperNameAndSurname: nationalRecordJson['jumperNameAndSurname'],
              distance: nationalRecordJson['distance'],
            )
          : null,
      subteams: subteams,
      limitInSubteam: limitInSubteamJson.map(
        (subteamTypeName, limit) => MapEntry(
          SubteamType.values.singleWhere(
            (value) => value.name == subteamTypeName,
          ),
          limit,
        ),
      ),
    ),
  );
}
