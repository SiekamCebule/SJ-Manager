import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/wind_averager/wind_averager.dart';

abstract class DefaultWindAverager extends WindAverager with EquatableMixin {
  DefaultWindAverager({
    required this.skipNonAchievedSensors,
    required this.computePreciselyPartialMeasurement,
  });

  late WindAveragingContext context;
  var countedWinds = <Wind>[];
  Wind? partiallyIncomplete;
  double? partialIncompletionFactor;
  Wind? averagedWindObject;

  /// Whether, for instance, include last two sensors in the wind averaging if jumper hadn't jumper as far (like only 100 meters on K120, when there are two more sensors in front of him)
  final bool skipNonAchievedSensors;

  /// Whether, for instance, add 60% of wind for some sensor, if jumper had jumped only at 60% of the path to next sensor (e.g. 6 meters if sensors are every 10)
  final bool computePreciselyPartialMeasurement;

  void clearData() {
    countedWinds = [];
    partiallyIncomplete = null;
    partialIncompletionFactor = null;
    averagedWindObject = null;
  }

  void fillCompletnessData() {
    final distance = context.distance;
    final measurement = context.windMeasurement;
    measurement.winds.forEach((range, wind) {
      if (distance <= range.$1) {
        if (!skipNonAchievedSensors) {
          countedWinds.add(wind);
        }
      } else if (distance > range.$1 &&
          distance < range.$2 &&
          (computePreciselyPartialMeasurement && skipNonAchievedSensors)) {
        partiallyIncomplete = wind;
        partialIncompletionFactor = (distance - range.$1) / (range.$2 - range.$1);
      } else {
        countedWinds.add(wind);
      }
    });
  }

  void computeAveragedWindObject();

  double convertToAveraged() {
    return cos(averagedWindObject!.direction.value * pi / 180) *
        averagedWindObject!.strength;
  }

  @override
  double compute(WindAveragingContext input) {
    clearData();
    context = input;
    fillCompletnessData();
    computeAveragedWindObject();
    return convertToAveraged();
  }

  @override
  List<Object?> get props => [
        skipNonAchievedSensors,
        computePreciselyPartialMeasurement,
      ];
}
