import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

abstract class StandingsPositionsCreator with EquatableMixin {
  Map<int, List<Score>> create(List<Score> records);

  @override
  List<Object?> get props => [
        runtimeType,
      ];
}
