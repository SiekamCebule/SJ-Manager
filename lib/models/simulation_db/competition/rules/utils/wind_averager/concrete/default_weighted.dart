import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/concrete/default.dart';

class DefaultWeightedWindAverager extends DefaultWindAverager {
  DefaultWeightedWindAverager({
    required super.skipNonAchievedSensors,
    required super.computePreciselyPartialMeasurement,
  });

  @override
  Wind computeAverage() {
    /*final weights = context.windMeasurementWeights;
    if (weights!.length !=
        complete.length +
            (partiallyIncomplete != null ? 1 : 0) +
            (skipNonAchievedSensors ? 0 : whollyIncomplete.length)) {
      throw ArgumentError(
          "The length of weights must match the number of wind measurements being averaged.");
    }

    int currentIndex = 0;

    double weightedSumStrength = 0;
    double totalWeight = 0;

    for (var wind in complete) {
      weightedSumStrength += wind.strength * weights[currentIndex];
      totalWeight += weights[currentIndex];
      currentIndex++;
    }

    if (computePreciselyPartialMeasurement && partiallyIncomplete != null) {
      weightedSumStrength += (partiallyIncomplete!.strength * weights[currentIndex]);
      totalWeight += weights[currentIndex];
      currentIndex++;
    }

    if (!skipNonAchievedSensors) {
      for (var wind in whollyIncomplete) {
        weightedSumStrength += wind.strength * weights[currentIndex];
        totalWeight += weights[currentIndex];
        currentIndex++;
      }
    }

    final averageWindStrength = weightedSumStrength / totalWeight;

    final directions = [
      if (!skipNonAchievedSensors)
        ...whollyIncomplete.map((wind) => wind.direction.value),
      ...complete.map((wind) => wind.direction.value),
      if (partiallyIncomplete != null) partiallyIncomplete!.direction.value,
    ];

    final averageWindDirection = Degrees(averageDirection(directions, weights));

    return Wind(direction: averageWindDirection, strength: averageWindStrength);*/
    throw UnimplementedError();
  }
}
