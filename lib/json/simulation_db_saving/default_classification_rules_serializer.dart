import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/classification/default_classification_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class DefaultClassificationRulesSerializer
    implements SimulationDbPartSerializer<DefaultClassificationRules> {
  const DefaultClassificationRulesSerializer({
    required this.idsRepo,
    required this.classificationScoreCreatorSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<ClassificationScoreCreator>
      classificationScoreCreatorSerializer;

  @override
  Json serialize(DefaultClassificationRules rules) {
    if (rules is DefaultIndividualClassificationRules ||
        rules is DefaultTeamClassificationRules) {
      return _serializeAccordingly(rules: rules);
    } else {
      throw UnsupportedError(
        '(Serializing) An unsupported DefaultClassificationRules type (${rules.runtimeType})',
      );
    }
  }

  Json _serializeAccordingly({
    required DefaultClassificationRules rules,
  }) {
    final classificationScoreCreatorJson = classificationScoreCreatorSerializer
        .serialize(rules.classificationScoreCreator as ClassificationScoreCreator);
    final scoringTypeJson = _serializeType(rules.scoringType);
    final pointsMapJson = rules.pointsMap;
    final competitionIdsJson =
        rules.competitions.map((competition) => idsRepo.idOf(competition));
    final pointsModifiersJson = rules.pointsModifiers
        .map((competition, modifier) => MapEntry(idsRepo.idOf(competition), modifier));

    return {
      'classificationScoreCreator': classificationScoreCreatorJson,
      'scoringTypeJson': scoringTypeJson,
      'pointsMapJson': pointsMapJson,
      'competitionIds': competitionIdsJson,
      'pointsModifiers': pointsModifiersJson,
    };
  }

  dynamic _serializeType(DefaultClassificationScoringType type) {
    return switch (type) {
      DefaultClassificationScoringType.pointsFromCompetitions => 'pointsFromCompetitions',
      DefaultClassificationScoringType.pointsFromMap => 'pointsFromMap',
    };
  }
}
