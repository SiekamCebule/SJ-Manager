import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/classification/default_classification_rules.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class ClassificationParser implements SimulationDbPartParser<Classification> {
  const ClassificationParser({
    required this.idsRepo,
    required this.standingsParser,
    required this.defaultClassificationRulesParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<Standings> standingsParser;
  final SimulationDbPartParser<DefaultClassificationRules>
      defaultClassificationRulesParser;

  @override
  Classification parse(Json json) {
    final type = json['type'] as String;

    return switch (type) {
      'default' => _loadDefaultClassification(json),
      'custom' => throw UnimplementedError(), // TODO
      _ => throw UnsupportedError('(Loading) An unsupported classification type ($type)'),
    };
  }

  DefaultClassification _loadDefaultClassification(Json json) {
    final standings = standingsParser.parse(json['standings']);
    final rules = defaultClassificationRulesParser.parse(json['rules']);
    return DefaultClassification(
      name: json['name'],
      standings: standings as Standings<dynamic, ClassificationScoreDetails>,
      rules: rules,
    );
  }
}
