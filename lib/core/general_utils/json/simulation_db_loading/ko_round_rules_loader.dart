import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class KoRoundRulesParser implements SimulationDbPartParser<KoRoundRules> {
  const KoRoundRulesParser({
    required this.idsRepository,
    required this.advancementDeterminatorParser,
    required this.koGroupsCreatorParser,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<KoRoundAdvancementDeterminator>
      advancementDeterminatorParser;
  final SimulationDbPartParser<KoGroupsCreator> koGroupsCreatorParser;

  @override
  FutureOr<KoRoundRules> parse(Json json) async {
    return KoRoundRules(
      advancementDeterminator:
          advancementDeterminatorParser.parse(json['advancementDeterminator'])
              as KoRoundAdvancementDeterminator<dynamic>,
      advancementCount: json['advancementCount'],
      koGroupsCreator: await koGroupsCreatorParser.parse(json['koGroupsCreator']),
      groupSize: json['groupSize'],
    );
  }
}
