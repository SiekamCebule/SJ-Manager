import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/classification/default_classification_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
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
    final classificationScoreCreatorJson =
        classificationScoreCreatorSerializer.serialize(rules.classificationScoreCreator);
    final pointsMapJson = rules.pointsMap;
    final competitionIdsJson =
        rules.competitions.map((competition) => idsRepo.id(competition)).toList();
    final pointsModifiersJson = rules.pointsModifiers
        .map((competition, modifier) => MapEntry(idsRepo.id(competition), modifier));

    return {
      'type': rules is DefaultIndividualClassificationRules ? 'individual' : 'team',
      'classificationScoreCreator': classificationScoreCreatorJson,
      'scoringType': _serializeType(rules.scoringType),
      'pointsMapJson': pointsMapJson,
      'competitionIds': competitionIdsJson,
      'pointsModifiers': pointsModifiersJson,
      if (rules is DefaultIndividualClassificationRules)
        'includeIndividualPlaceFromTeamCompetitions':
            rules.includeApperancesInTeamCompetitions,
      if (rules is DefaultTeamClassificationRules)
        'includeJumperPointsFromIndividualCompetitions':
            rules.includeJumperPointsFromIndividualCompetitions
    };
  }

  dynamic _serializeType(DefaultClassificationScoringType type) {
    return switch (type) {
      DefaultClassificationScoringType.pointsFromCompetitions => 'pointsFromCompetitions',
      DefaultClassificationScoringType.pointsFromMap => 'pointsFromMap',
    };
  }
}
