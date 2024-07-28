import 'package:equatable/equatable.dart';

abstract class Score with EquatableMixin implements Comparable {
  const Score();

  bool operator <(Score other);
  bool operator >(Score other);
}
