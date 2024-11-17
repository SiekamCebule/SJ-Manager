import 'package:equatable/equatable.dart';
import 'package:sj_manager/domain/entities/simulation/classification/default_classification_rules.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/details/score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings.dart';

abstract class Classification<E, S extends Standings<E, ScoreDetails>,
    R extends ClassificationRules<E>> with EquatableMixin {
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

  @override
  List<Object?> get props => [
        name,
        standings,
        rules,
      ];
}

class DefaultClassification<E, S extends Standings<E, ScoreDetails>>
    extends Classification<E, S, DefaultClassificationRules<E>> {
  const DefaultClassification({
    required super.name,
    required super.standings,
    required super.rules,
  });
}
