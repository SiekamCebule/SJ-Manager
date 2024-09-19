import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/json/utils/enums.dart';

import 'package:sj_manager/models/user_db/country/country_team_facts.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumps/simple_jump.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:sj_manager/models/user_db/team/country_team.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class TeamLoader implements SimulationDbPartParser<Team> {
  const TeamLoader({
    required this.idsRepo,
    required this.countryLoader,
  });

  final ItemsIdsRepo idsRepo;
  final JsonCountryLoader countryLoader;

  @override
  Team parse(Json json) {
    final type = json['type'];
    return switch (type) {
      'country_team' => _parseCountryTeam(json),
      'competition_team' => _parseCompetitionTeam(json),
      'subteam' => _parseSubteam(json),
      _ => throw ArgumentError('(Team parsing): An invalid team\'s type ($type)'),
    };
  }

  CountryTeam _parseCountryTeam(Json json) {
    final sex = sexEnumMap.keys.singleWhere((sex) => sexEnumMap[sex]! == json['sex']);
    final country = countryLoader.load(json['countryCode']);
    final factsJson = json['facts'] as Json;
    final nationalRecordJson = json['record'] as Json?;
    return CountryTeam(
      sex: sex,
      country: country,
      facts: CountryTeamFacts(
        stars: factsJson['stars'],
        record: nationalRecordJson != null
            ? SimpleJump(
                jumperNameAndSurname: nationalRecordJson['jumperNameAndSurname'],
                distance: nationalRecordJson['distance'],
              )
            : null,
      ),
    );
  }

  CompetitionTeam _parseCompetitionTeam(Json json) {
    final parentTeamJson = json['parentTeam'] as Json;
    final parentTeam = parse(parentTeamJson);
    final jumperIds = json['jumperIds'] as List;
    final jumpers = jumperIds.map((id) {
      return idsRepo.get(id) as Jumper;
    });

    return CompetitionTeam(
      parentTeam: parentTeam,
      jumpers: jumpers.toList(),
    );
  }

  Subteam _parseSubteam(Json json) {
    final parentTeamJson = json['parentTeam'] as Json;
    final parentTeam = parse(parentTeamJson);
    final jumperIds = json['jumperIds'] as List;
    final jumpers = jumperIds.map((id) {
      return idsRepo.get(id) as Jumper;
    });

    return Subteam(
      parentTeam: parentTeam,
      jumpers: jumpers.toList(),
      label: json['label'],
    );
  }
}
