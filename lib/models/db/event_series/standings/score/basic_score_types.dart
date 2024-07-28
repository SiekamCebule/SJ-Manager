import 'package:sj_manager/models/db/event_series/standings/score/score.dart';

abstract class SingleValueScore<T> extends Score {
  const SingleValueScore(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}

class PointsScore extends SingleValueScore<double> {
  const PointsScore(super.value);

  @override
  bool operator >(covariant PointsScore other) {
    return value > other.value;
  }

  @override
  bool operator <(covariant PointsScore other) {
    return value < other.value;
  }

  @override
  int compareTo(covariant PointsScore other) {
    return value.compareTo(other.value);
  }
}
