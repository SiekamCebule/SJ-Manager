import 'dart:async';

import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/classification/classification.dart';
import 'package:sj_manager/domain/entities/simulation/classification/default_classification_rules.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

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
  FutureOr<Classification> parse(Json json) async {
    final type = json['type'] as String;

    return switch (type) {
      'default' => _loadDefaultClassification(json),
      'custom' => throw UnimplementedError(), // TODO
      _ => throw UnsupportedError('(Loading) An unsupported classification type ($type)'),
    };
  }

  FutureOr<DefaultClassification> _loadDefaultClassification(Json json) async {
    final standingsJson = json['standings'] as Json?;
    var standings =
        standingsJson != null ? await standingsParser.parse(standingsJson) : null;

    final rules = await defaultClassificationRulesParser.parse(json['rules']);
    return DefaultClassification(
      name: json['name'],
      standings: standings,
      rules: rules,
    );
  }
}
