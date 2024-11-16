import 'package:sj_manager/data/models/simulation/jumper/simulation_jumper.dart';

abstract interface class PartialAppointmentsAlgorithm {
  const PartialAppointmentsAlgorithm();

  Iterable<SimulationJumper> chooseBestJumpers({
    required Iterable<SimulationJumper> source,
    required int limit,
  });
}
