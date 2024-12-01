import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/classification/classification.dart';
import 'package:sj_manager/to_embrace/classification/simple_classification_rules.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/standings.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class ClassificationSerializer implements SimulationDbPartSerializer<Classification> {
  const ClassificationSerializer({
    required this.idsRepository,
    required this.standingsSerializer,
    required this.defaultClassificationRulesSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<Standings> standingsSerializer;
  final SimulationDbPartSerializer<SimpleClassificationRules>
      defaultClassificationRulesSerializer;

  @override
  FutureOr<Json> serialize(Classification classification) {
    if (classification is SimpleClassification) {
      return _serializeDefault(classification);
    } else {
      throw UnsupportedError(
        '(Serializing) An unsupported classification type (${classification.runtimeType})',
      );
    }
  }

  FutureOr<Json> _serializeDefault(SimpleClassification classification) async {
    return {
      'type': 'default',
      'name': classification.name,
      'standings': classification.standings != null
          ? await standingsSerializer.serialize(classification.standings!)
          : null,
      'rules': defaultClassificationRulesSerializer.serialize(classification.rules),
    };
  }
}
