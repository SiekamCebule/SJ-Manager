import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';

class StandingsRecord<E, S extends Score> with EquatableMixin implements Comparable {
  const StandingsRecord({
    required this.entity,
    required this.score,
  });

  final E entity;
  final S score;

  StandingsRecord<E, S> copyWith({
    E? entity,
    S? score,
  }) {
    return StandingsRecord<E, S>(
      entity: entity ?? this.entity,
      score: score ?? this.score,
    );
  }

  bool operator >(StandingsRecord<E, S> other) {
    return score > other.score;
  }

  bool operator <(StandingsRecord<E, S> other) {
    return score > other.score;
  }

  @override
  int compareTo(covariant StandingsRecord other) {
    return score.compareTo(other.score);
  }

  @override
  List<Object?> get props => [entity, score];
}
