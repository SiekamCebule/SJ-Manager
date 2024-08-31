import 'package:equatable/equatable.dart';

abstract class ScoreDetails with EquatableMixin {
  const ScoreDetails();

  @override
  List<Object?> get props => [];
}

class SimplePointsScoreDetails extends ScoreDetails {
  const SimplePointsScoreDetails();
}
