import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

abstract class StandingsPositionsCreator<S extends Score> with EquatableMixin {
  Map<int, List<S>> create(List<S> scores);

  @override
  List<Object?> get props => [
        runtimeType,
      ];
}
