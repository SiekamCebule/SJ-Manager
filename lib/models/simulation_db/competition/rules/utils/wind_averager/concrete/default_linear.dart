import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/concrete/default.dart';
import 'package:sj_manager/utils/averaging.dart';

class DefaultLinearWindAverager extends DefaultWindAverager {
  DefaultLinearWindAverager({
    required super.skipNonAchievedSensors,
    required super.computePreciselyPartialMeasurement,
  });

  @override
  Wind computeAverage() {
    final divider = complete.length + (partialIncompletionFactor ?? 0);

    var averageWindStrength =
        complete.fold<double>(0, (sum, wind) => sum + wind.strength);
    if (computePreciselyPartialMeasurement) {
      final first = partiallyIncomplete?.strength ?? 0;
      final second = partialIncompletionFactor ?? 0;
      averageWindStrength += (first * second);
    }
    if (!skipNonAchievedSensors) {
      averageWindStrength += whollyIncomplete.fold(0, (sum, wind) => sum + wind.strength);
    }
    averageWindStrength /= divider;

    final directions = [
      if (!skipNonAchievedSensors)
        ...whollyIncomplete.map((wind) => wind.direction.value),
      ...complete.map((wind) => wind.direction.value),
      if (partiallyIncomplete != null) partiallyIncomplete!.direction.value,
    ];
    final averageWindDirection =
        Degrees(averageDirection(directions, divider.toDouble()));

    return Wind(direction: averageWindDirection, strength: averageWindStrength);
  }
}
