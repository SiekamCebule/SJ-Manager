import 'package:sj_manager/utilities/json/countries.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/utilities/json/utils/enums.dart';

import 'package:sj_manager/core/classes/country_team/country_team_facts_model.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/classes/jumps/simple_jump_model.dart';
import 'package:sj_manager/domain/entities/simulation/team/competition_team.dart';
import 'package:sj_manager/core/classes/country_team/country_team.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam_type.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class TeamLoader implements SimulationDbPartParser<Team> {
  const TeamLoader({
    required this.idsRepo,
    required this.countryLoader,
  });

  final ItemsIdsRepo idsRepo;
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
      return idsRepo.get(id) as JumperDbRecord;
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
