import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/competitions/domain/utils/wind_averager/concrete/default_linear.dart';
import 'package:sj_manager/features/competitions/domain/utils/wind_averager/concrete/default_weighted.dart';
import 'package:sj_manager/features/competitions/domain/utils/wind_averager/wind_averager.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class WindAveragerParser implements SimulationDbPartParser<WindAverager> {
  const WindAveragerParser({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  WindAverager parse(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'default_linear' => _loadDefaultLinear(json),
      'default_weighted' => _loadDefaultWeighted(json),
      _ => throw UnsupportedError(
          '(Loading) An unsupported WindAverager type ($type)',
        ),
    };
  }

  DefaultLinearWindAverager _loadDefaultLinear(Json json) {
    return DefaultLinearWindAverager(
      skipNonAchievedSensors: json['skipNonAchievedSensors'],
      computePreciselyPartialMeasurement: json['computePreciselyPartialMeasurement'],
    );
  }

  DefaultWeightedWindAverager _loadDefaultWeighted(Json json) {
    return DefaultWeightedWindAverager(
      skipNonAchievedSensors: json['skipNonAchievedSensors'],
      computePreciselyPartialMeasurement: json['computePreciselyPartialMeasurement'],
    );
  }
}
