import 'package:equatable/equatable.dart';

abstract class Score<T> with EquatableMixin {
  const Score({
    required this.subject,
  });

  final T subject;
  double get points;

  bool operator >(covariant Score other) {
    return points > other.points;
  }

  bool operator <(covariant Score other) {
    return points < other.points;
  }
}
