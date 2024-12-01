import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/classification/simple_classification_rules.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class DefaultClassificationRulesParser
    implements SimulationDbPartParser<SimpleClassificationRules> {
  const DefaultClassificationRulesParser({
    required this.idsRepository,
    required this.classificationScoreCreatorParser,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<ClassificationScoreCreator>
      classificationScoreCreatorParser;

  @override
  SimpleClassificationRules parse(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'individual' || 'team' => _loadAccordingly(json: json, typeString: type),
      _ => throw UnsupportedError(
          'An unsupported default classification rules type ($type). Supported are only \'individual\' and \'team\'',
        ),
    };
  }

  SimpleClassificationRules _loadAccordingly(
      {required Json json, required String typeString}) {
    final classificationScoreCreator =
        classificationScoreCreatorParser.parse(json['classificationScoreCreator']);
    final scoringType = _loadScoringType(json['scoringType']);
    final competitionsJson = json['competitionIds'] as List;
    final competitions = competitionsJson.map(
      (competitionId) => idsRepository.get(competitionId) as Competition,
    );
    final pointsModifiersJson = (json['pointsModifiers'] as Json).cast<String, String>();
    final pointsModifiers = pointsModifiersJson.map(
      (key, value) {
        return MapEntry(idsRepository.get(key) as Competition, double.parse(value));
      },
    );

    SimpleIndividualClassificationRules createIndividual() {
      if (classificationScoreCreator is ClassificationScoreCreator<JumperDbRecord,
          DefaultClassificationScoreCreatingContext<JumperDbRecord>>) {
        return SimpleIndividualClassificationRules(
          classificationScoreCreator: classificationScoreCreator,
          scoringType: scoringType,
          pointsMap: json['pointsMap'],
          competitions: competitions.toList(),
          pointsModifiers: pointsModifiers,
          includeApperancesInTeamCompetitions:
              json['includeIndividualPlaceFromTeamCompetitions'],
        );
      } else {
        throw ArgumentError(
          "The loaded classification score creator is not a ClassificationScoreCreator<Jumper,"
          "DefaultClassificationScoreCreatingContext<Jumper>>",
        );
      }
    }

    SimpleTeamClassificationRules createTeam() {
      if (classificationScoreCreator is ClassificationScoreCreator<SimulationTeam,
          DefaultClassificationScoreCreatingContext<SimulationTeam>>) {
        return SimpleTeamClassificationRules(
          classificationScoreCreator: classificationScoreCreator,
          scoringType: scoringType,
          pointsMap: json['pointsMap'],
          competitions: competitions.toList(),
          pointsModifiers: pointsModifiers,
          includeJumperPointsFromIndividualCompetitions:
              json['includeJumperPointsFromIndividualCompetitions'],
        );
      } else {
        throw ArgumentError(
          "The loaded classification score creator is not a ClassificationScoreCreator<Team,"
          "DefaultClassificationScoreCreatingContext<Team>>",
        );
      }
    }

    return switch (typeString) {
      'individual' => createIndividual(),
      'team' => createTeam(),
      _ => throw UnsupportedError(
          'That shouldn\'t even appear, but there is an invalid typeString ($typeString) during loading the DefaultIndividualClassificationRules'),
    };
  }

  SimpleClassificationScoringType _loadScoringType(dynamic value) {
    return switch (value) {
      'pointsFromCompetitions' => SimpleClassificationScoringType.pointsFromCompetitions,
      'pointsFromMap' => SimpleClassificationScoringType.pointsFromMap,
      _ => throw UnsupportedError(
          'An unsupported type of DefaultClassificationScoringType. Supported are only \'pointsFromCompetitions\' \'pointsFromMap\' ($value)')
    };
  }
}
