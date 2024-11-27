import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

abstract interface class CountryTeamRankingCreator {
  Iterable<SimulationJumper> create({
    required Iterable<SimulationJumper> source,
  });
}
