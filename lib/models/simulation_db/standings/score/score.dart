import 'package:equatable/equatable.dart';

abstract class Score<E> with EquatableMixin implements Comparable {
  const Score({
    required this.entity,
  });

  final E entity;

  bool operator <(Score other);
  bool operator >(Score other);

  @override
  List<Object?> get props => [
        entity,
      ];
}
