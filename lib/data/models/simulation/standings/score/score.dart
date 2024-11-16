import 'package:equatable/equatable.dart';
import 'package:sj_manager/data/models/simulation/standings/score/details/score_details.dart';

class Score<E, D extends ScoreDetails>
    with EquatableMixin
    implements Comparable<Score<E, D>> {
  const Score({
    required this.entity,
    required this.points,
    required this.details,
  });

  final E entity;
  final double points;
  final D details;

  Score<E, D> copyWith({
    E? entity,
    double? points,
    D? details,
  }) {
    return Score<E, D>(
      entity: entity ?? this.entity,
      points: points ?? this.points,
      details: details ?? this.details,
    );
  }

  bool operator <(Score other) {
    return points < other.points;
  }

  bool operator >(Score other) {
    return points > other.points;
  }

  @override
  int compareTo(Score<E, D> other) {
    return points.compareTo(other.points);
  }

  @override
  List<Object?> get props => [
        entity,
        points,
        details,
      ];
}
