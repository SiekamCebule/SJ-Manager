import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/features/competitions/domain/utils/wind_averager/concrete/default.dart';
import 'package:sj_manager/core/general_utils/averaging.dart';

class DefaultLinearWindAverager extends DefaultWindAverager {
  DefaultLinearWindAverager({
    required super.skipNonAchievedSensors,
    required super.computePreciselyPartialMeasurement,
  });

  @override
  void computeAveragedWindObject() {
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

    averagedWindObject =
        Wind(direction: averageWindDirection, strength: averageWindStrength);
  }
}
