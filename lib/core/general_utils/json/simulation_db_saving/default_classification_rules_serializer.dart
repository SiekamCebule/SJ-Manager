import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/classification/default_classification_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class DefaultClassificationRulesSerializer
    implements SimulationDbPartSerializer<DefaultClassificationRules> {
  const DefaultClassificationRulesSerializer({
    required this.idsRepository,
    required this.classificationScoreCreatorSerializer,
  });

  final IdsRepository idsRepository;
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
        rules.competitions.map((competition) => idsRepository.id(competition)).toList();
    final pointsModifiersJson = rules.pointsModifiers.map(
        (competition, modifier) => MapEntry(idsRepository.id(competition), modifier));

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
