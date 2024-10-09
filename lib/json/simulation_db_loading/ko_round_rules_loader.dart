import 'dart:async';

import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class KoRoundRulesParser implements SimulationDbPartParser<KoRoundRules> {
  const KoRoundRulesParser({
    required this.idsRepo,
    required this.advancementDeterminatorParser,
    required this.koGroupsCreatorParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<KoRoundAdvancementDeterminator>
      advancementDeterminatorParser;
  final SimulationDbPartParser<KoGroupsCreator> koGroupsCreatorParser;

  @override
  FutureOr<KoRoundRules> parse(Json json) async {
    return KoRoundRules(
      advancementDeterminator:
          advancementDeterminatorParser.parse(json['advancementDeterminator'])
              as KoRoundAdvancementDeterminator<dynamic,
                  KoRoundAdvancementDeterminingContext>,
      advancementCount: json['advancementCount'],
      koGroupsCreator: await koGroupsCreatorParser.parse(json['koGroupsCreator']),
      groupSize: json['groupSize'],
    );
  }
}
