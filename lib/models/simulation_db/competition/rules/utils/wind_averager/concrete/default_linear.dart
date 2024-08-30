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
    double divider = countedWinds.length.toDouble();
    if (partiallyIncomplete != null) {
      divider += partialIncompletionFactor!;
    }

    var averageWindStrength =
        countedWinds.fold<double>(0, (sum, wind) => sum + wind.strength);
    if (partiallyIncomplete != null) {
      averageWindStrength += partiallyIncomplete!.strength * partialIncompletionFactor!;
    }
    averageWindStrength /= divider;

    final directions = [
      ...countedWinds.map((wind) => wind.direction.value),
      if (partiallyIncomplete != null) partiallyIncomplete!.direction.value,
    ];
    late double lastWeight = 1.0;
    if (partiallyIncomplete != null) {
      lastWeight = partialIncompletionFactor!;
    }
    final averageWindDirection = Degrees(
      averageDirectionWeightedForLast(
        directions,
        lastWeight: lastWeight,
      ),
    );

    return Wind(direction: averageWindDirection, strength: averageWindStrength);
  }
}
