import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/wind_averager/concrete/default_linear.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/wind_averager/concrete/default_weighted.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/wind_averager/wind_averager.dart';

import 'wind_averaging_test.mocks.dart';

@GenerateMocks([WindAveragingContext])
void main() {
  group('DefaultLinearWindAverager Tests', () {
    late final WindAveragingContext context;

    setUpAll(() {
      context = MockWindAveragingContext();
      when(context.distance).thenReturn(120);
      when(context.windMeasurement).thenReturn(
        WindMeasurement(
          winds: {
            (0, 22): Wind(direction: Degrees(121.5), strength: 1.44),
            (22, 44): Wind(direction: Degrees(180.5), strength: 1.7),
            (44, 66): Wind(direction: Degrees(40.5), strength: 3.0),
            (66, 88): Wind(direction: Degrees(200.9), strength: 1.01),
            (88, 110): Wind(direction: Degrees(140.5), strength: 0.66),
            (110, 132): Wind(direction: Degrees(90.11), strength: 3.5),
            (132, 154): Wind(direction: Degrees(190.5), strength: 5.0),
          },
        ),
      );
    });

    test(
        'Scenario 1: skipNonAchievedSensors = true, computePreciselyPartialMeasurement = true',
        () {
      final averager = DefaultLinearWindAverager(
        skipNonAchievedSensors: true,
        computePreciselyPartialMeasurement: true,
      );

      averager.compute(context);
      final averageWind = averager.averagedWindObject!;

      expect(averageWind.strength, closeTo(1.722, 0.01));
      expect(averageWind.direction.value, closeTo(138, 0.1));
    });

    test(
        'Scenario 2: skipNonAchievedSensors = true, computePreciselyPartialMeasurement = false',
        () {
      final averager = DefaultLinearWindAverager(
        skipNonAchievedSensors: true,
        computePreciselyPartialMeasurement: false,
      );

      averager.compute(context);
      final averageWind = averager.averagedWindObject!;

      expect(averageWind.strength, closeTo(1.885, 0.001));
      expect(averageWind.direction.value, closeTo(131.7, 0.1));
    });

    test(
        'Scenario 3: skipNonAchievedSensors = false, computePreciselyPartialMeasurement = true',
        () {
      final averager = DefaultLinearWindAverager(
        skipNonAchievedSensors: false,
        computePreciselyPartialMeasurement: true,
      );

      averager.compute(context);
      final averageWind = averager.averagedWindObject!;

      expect(averageWind.strength, closeTo(2.33, 0.001));
      expect(averageWind.direction.value, closeTo(143.1, 0.1));
    });

    test(
        'Scenario 4: skipNonAchievedSensors = false, computePreciselyPartialMeasurement = false',
        () {
      final averager = DefaultLinearWindAverager(
        skipNonAchievedSensors: false,
        computePreciselyPartialMeasurement: false,
      );

      averager.compute(context);
      final averageWind = averager.averagedWindObject!;

      expect(averageWind.strength, closeTo(2.33, 0.001));
      expect(averageWind.direction.value, closeTo(143.1, 0.1));
    });
  });

  group('DefaultWeightedWindAverager Tests', () {
    late final WindAveragingContext context;

    setUpAll(() {
      context = MockWindAveragingContext();
      when(context.distance).thenReturn(120);
      when(context.windMeasurement).thenReturn(
        WindMeasurement(
          winds: {
            (0, 22): Wind(direction: Degrees(121.5), strength: 1.44),
            (22, 44): Wind(direction: Degrees(180.5), strength: 1.7),
            (44, 66): Wind(direction: Degrees(40.5), strength: 3.0),
            (66, 88): Wind(direction: Degrees(200.9), strength: 1.01),
            (88, 110): Wind(direction: Degrees(140.5), strength: 0.66),
            (110, 132): Wind(direction: Degrees(90.11), strength: 3.5),
            (132, 154): Wind(direction: Degrees(190.5), strength: 5.0),
          },
        ),
      );
      when(context.windMeasurementWeights)
          .thenReturn([1.0, 0.8, 1.2, 0.5, 0.9, 2.0, 0.3]);
    });

    test(
        'Scenario 1: skipNonAchievedSensors = true, computePreciselyPartialMeasurement = true',
        () {
      final averager = DefaultWeightedWindAverager(
        skipNonAchievedSensors: true,
        computePreciselyPartialMeasurement: true,
      );

      averager.compute(context);
      final averageWind = averager.averagedWindObject!;

      expect(averageWind.strength, closeTo(2.009, 0.01));
      expect(averageWind.direction.value, closeTo(118.32, 0.1));
    });

    test(
        'Scenario 2: skipNonAchievedSensors = false, computePreciselyPartialMeasurement = false',
        () {
      final averager = DefaultWeightedWindAverager(
        skipNonAchievedSensors: false,
        computePreciselyPartialMeasurement: false,
      );

      averager.compute(context);
      final averageWind = averager.averagedWindObject!;

      expect(averageWind.strength, closeTo(2.38, 0.01));
      expect(averageWind.direction.value, closeTo(115.26, 0.1));
    });

    test(
        'Scenario 3: skipNonAchievedSensors = true, computePreciselyPartialMeasurement = false',
        () {
      final averager = DefaultWeightedWindAverager(
        skipNonAchievedSensors: true,
        computePreciselyPartialMeasurement: false,
      );

      averager.compute(context);
      final averageWind = averager.averagedWindObject!;

      expect(averageWind.strength, closeTo(2.265, 0.01));
      expect(averageWind.direction.value, closeTo(111.40, 0.1));
    });
  });
}
