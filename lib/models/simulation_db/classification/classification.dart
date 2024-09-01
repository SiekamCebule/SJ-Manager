import 'package:sj_manager/models/simulation_db/classification/default_classification_rules.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/classification_score_details.dart';

abstract class Classification<E, S extends Standings<E, ClassificationScoreDetails>,
    R extends ClassificationRules<E>> {
  const Classification({
    required this.name,
    required this.standings,
    required this.rules,
  });

  final String name;
  final S? standings;
  final R rules;

  void updateStandings() {
    if (standings == null) {
      throw StateError('Standings are null, so cannot update them');
    }
    standings!.update();
  }
}

// TODO: Custom classification

class DefaultClassification<E, S extends Standings<E, ClassificationScoreDetails>>
    extends Classification<E, S, DefaultClassificationRules<E>> {
  const DefaultClassification({
    required super.name,
    required super.standings,
    required super.rules,
  });
}
