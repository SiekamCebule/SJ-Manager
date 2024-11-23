import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

abstract interface class PartialAppointmentsAlgorithm {
  const PartialAppointmentsAlgorithm();

  Iterable<SimulationJumper> chooseBestJumpers({
    required Iterable<SimulationJumper> source,
    required int limit,
  });
}
