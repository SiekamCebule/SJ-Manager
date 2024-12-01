import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/standings.dart';
import 'package:sj_manager/to_embrace/classification/simple_classification_rules.dart';

abstract class Classification<T, R extends ClassificationRules<T>> with EquatableMixin {
  const Classification({
    required this.name,
    required this.standings,
    required this.rules,
  });

  final String name;
  final Standings? standings;
  final R rules;

  @override
  List<Object?> get props => [
        name,
        standings,
        rules,
      ];
}

class SimpleClassification<T> extends Classification<T, SimpleClassificationRules<T>> {
  const SimpleClassification({
    required super.name,
    required super.standings,
    required super.rules,
  });
}

// TODO: Custom classification
