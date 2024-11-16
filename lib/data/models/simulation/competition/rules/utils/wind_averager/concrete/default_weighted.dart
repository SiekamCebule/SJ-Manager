import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/wind_averager/concrete/default.dart';
import 'package:sj_manager/utilities/utils/averaging.dart';
import 'package:sj_manager/utilities/utils/math.dart';

class DefaultWeightedWindAverager extends DefaultWindAverager {
  DefaultWeightedWindAverager({
    required super.skipNonAchievedSensors,
    required super.computePreciselyPartialMeasurement,
  });

  @override
  void computeAveragedWindObject() {
    //const ok = 2;
    final weights = context.windMeasurementWeights!;
    weights.length = (countedWinds.length + (partiallyIncomplete != null ? 1 : 0));

    final appropriateWeightsCount =
        countedWinds.length + (partiallyIncomplete != null ? 1 : 0);
    if (weights.length != appropriateWeightsCount) {
      throw ArgumentError(
        "The length of weights must match the number of wind measurements being averaged (there is ${weights.length}, but should be $appropriateWeightsCount)",
      );
    }

    if (partiallyIncomplete != null) {
      weights[weights.length - 1] =
          weights[weights.length - 1] * partialIncompletionFactor!;
    }

    final angles = [
      ...countedWinds.map((wind) => wind.direction.value),
      if (partiallyIncomplete != null) partiallyIncomplete!.direction.value,
    ];
    final strengths = [
      ...countedWinds.map((wind) => wind.strength),
      if (partiallyIncomplete != null) partiallyIncomplete!.strength,
    ];
    final averageDir = averageDirection(angles, weights);
    final averageStrength = weightedAverage(strengths, weights);

    averagedWindObject = Wind(direction: Degrees(averageDir), strength: averageStrength);
  }
}
