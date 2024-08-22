import 'package:sj_manager/models/simulation_db/classification/default_classification_rules.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';

abstract class Classification<E, R extends ClassificationRules<E>> {
  const Classification({
    required this.name,
    required this.standings,
    required this.rules,
  });

  final String name;
  final Standings<E>? standings;
  final R rules;

  void updateStandings() {
    if (standings == null) {
      throw StateError('Standings are null, so cannot update them');
    }
    standings!.update();
  }
}

// TODO: Custom classification

class DefaultClassification<E> extends Classification<E, DefaultClassificationRules<E>> {
  const DefaultClassification({
    required super.name,
    required super.standings,
    required super.rules,
  });
}
