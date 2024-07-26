import 'package:equatable/equatable.dart';

class ClassificationResult<T> with EquatableMixin {
  const ClassificationResult({
    required this.entity,
    required this.score,
  });

  final T entity;
  final double score;

  ClassificationResult<T> copyWith({
    T? entity,
    double? score,
  }) {
    return ClassificationResult<T>(
      entity: entity ?? this.entity,
      score: score ?? this.score,
    );
  }

  int operator >(ClassificationResult<T> other) {
    return score.compareTo(other.score);
  }

  int operator <(ClassificationResult<T> other) {
    return other.score.compareTo(score);
  }

  @override
  List<Object?> get props => [entity, score];
}
