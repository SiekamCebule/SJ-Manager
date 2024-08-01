import 'package:sj_manager/models/db/event_series/standings/score/score.dart';

mixin HasPointsMixin<E> on Score<E> {
  List<double> get components;
  double get points {
    return components.reduce((first, second) => first + second);
  }

  @override
  bool operator >(covariant HasPointsMixin other) {
    return points > other.points;
  }

  @override
  bool operator <(covariant HasPointsMixin other) {
    return points < other.points;
  }

  @override
  int compareTo(covariant HasPointsMixin other) {
    return points.compareTo(other.points);
  }
}
