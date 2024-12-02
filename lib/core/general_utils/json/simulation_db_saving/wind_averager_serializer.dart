import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/competitions/domain/utils/wind_averager/concrete/default_linear.dart';
import 'package:sj_manager/features/competitions/domain/utils/wind_averager/concrete/default_weighted.dart';
import 'package:sj_manager/features/competitions/domain/utils/wind_averager/wind_averager.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class WindAveragerSerializer implements SimulationDbPartSerializer<WindAverager> {
  const WindAveragerSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  Json serialize(WindAverager averager) {
    if (averager is DefaultLinearWindAverager) {
      return _parseDefaultLinear(averager);
    } else if (averager is DefaultWeightedWindAverager) {
      return _parseDefaultWeighted(averager);
    } else {
      throw UnsupportedError(
        '(Parsing) An unsupported WindAverager type (${averager.runtimeType})',
      );
    }
  }

  Json _parseDefaultLinear(DefaultLinearWindAverager averager) {
    return {
      'type': 'default_linear',
      'skipNonAchievedSensors': averager.skipNonAchievedSensors,
      'computePreciselyPartialMeasurement': averager.computePreciselyPartialMeasurement,
    };
  }

  Json _parseDefaultWeighted(DefaultWeightedWindAverager averager) {
    return {
      'type': 'default_weighted',
      'skipNonAchievedSensors': averager.skipNonAchievedSensors,
      'computePreciselyPartialMeasurement': averager.computePreciselyPartialMeasurement,
    };
  }
}
