import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/classification/simple_classification_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class DefaultClassificationRulesSerializer
    implements SimulationDbPartSerializer<SimpleClassificationRules> {
  const DefaultClassificationRulesSerializer({
    required this.idsRepository,
    required this.classificationScoreCreatorSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<ClassificationScoreCreator>
      classificationScoreCreatorSerializer;

  @override
  Json serialize(SimpleClassificationRules rules) {
    if (rules is SimpleIndividualClassificationRules ||
        rules is SimpleTeamClassificationRules) {
      return _serializeAccordingly(rules: rules);
    } else {
      throw UnsupportedError(
        '(Serializing) An unsupported DefaultClassificationRules type (${rules.runtimeType})',
      );
    }
  }

  Json _serializeAccordingly({
    required SimpleClassificationRules rules,
  }) {
    final classificationScoreCreatorJson =
        classificationScoreCreatorSerializer.serialize(rules.classificationScoreCreator);
    final pointsMapJson = rules.pointsMap;
    final competitionIdsJson =
        rules.competitions.map((competition) => idsRepository.id(competition)).toList();
    final pointsModifiersJson = rules.pointsModifiers.map(
        (competition, modifier) => MapEntry(idsRepository.id(competition), modifier));

    return {
      'type': rules is SimpleIndividualClassificationRules ? 'individual' : 'team',
      'classificationScoreCreator': classificationScoreCreatorJson,
      'scoringType': _serializeType(rules.scoringType),
      'pointsMapJson': pointsMapJson,
      'competitionIds': competitionIdsJson,
      'pointsModifiers': pointsModifiersJson,
      if (rules is SimpleIndividualClassificationRules)
        'includeIndividualPlaceFromTeamCompetitions':
            rules.includeApperancesInTeamCompetitions,
      if (rules is SimpleTeamClassificationRules)
        'includeJumperPointsFromIndividualCompetitions':
            rules.includeJumperPointsFromIndividualCompetitions
    };
  }

  dynamic _serializeType(SimpleClassificationScoringType type) {
    return switch (type) {
      SimpleClassificationScoringType.pointsFromCompetitions => 'pointsFromCompetitions',
      SimpleClassificationScoringType.pointsFromMap => 'pointsFromMap',
    };
  }
}
