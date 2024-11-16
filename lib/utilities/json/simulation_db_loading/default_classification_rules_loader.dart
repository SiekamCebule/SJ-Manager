import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/simulation/classification/default_classification_rules.dart';
import 'package:sj_manager/data/models/simulation/competition/competition.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/data/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/data/models/database/team/team.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class DefaultClassificationRulesParser
    implements SimulationDbPartParser<DefaultClassificationRules> {
  const DefaultClassificationRulesParser({
    required this.idsRepo,
    required this.classificationScoreCreatorParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<ClassificationScoreCreator>
      classificationScoreCreatorParser;

  @override
  DefaultClassificationRules parse(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'individual' || 'team' => _loadAccordingly(json: json, typeString: type),
      _ => throw UnsupportedError(
          'An unsupported default classification rules type ($type). Supported are only \'individual\' and \'team\'',
        ),
    };
  }

  DefaultClassificationRules _loadAccordingly(
      {required Json json, required String typeString}) {
    final classificationScoreCreator =
        classificationScoreCreatorParser.parse(json['classificationScoreCreator']);
    final scoringType = _loadScoringType(json['scoringType']);
    final competitionsJson = json['competitionIds'] as List;
    final competitions = competitionsJson.map(
      (competitionId) => idsRepo.get(competitionId) as Competition,
    );
    final pointsModifiersJson = (json['pointsModifiers'] as Json).cast<String, String>();
    final pointsModifiers = pointsModifiersJson.map(
      (key, value) {
        return MapEntry(idsRepo.get(key) as Competition, double.parse(value));
      },
    );

    DefaultIndividualClassificationRules createIndividual() {
      if (classificationScoreCreator is ClassificationScoreCreator<JumperDbRecord,
          DefaultClassificationScoreCreatingContext<JumperDbRecord>>) {
        return DefaultIndividualClassificationRules(
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

    DefaultTeamClassificationRules createTeam() {
      if (classificationScoreCreator is ClassificationScoreCreator<Team,
          DefaultClassificationScoreCreatingContext<Team>>) {
        return DefaultTeamClassificationRules(
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

  DefaultClassificationScoringType _loadScoringType(dynamic value) {
    return switch (value) {
      'pointsFromCompetitions' => DefaultClassificationScoringType.pointsFromCompetitions,
      'pointsFromMap' => DefaultClassificationScoringType.pointsFromMap,
      _ => throw UnsupportedError(
          'An unsupported type of DefaultClassificationScoringType. Supported are only \'pointsFromCompetitions\' \'pointsFromMap\' ($value)')
    };
  }
}
