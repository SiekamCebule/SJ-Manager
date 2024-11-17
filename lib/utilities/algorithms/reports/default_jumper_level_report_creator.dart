import 'package:sj_manager/domain/entities/simulation/jumper/reports/jumper_level_description.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/simulation_jumper.dart';

class DefaultJumperLevelReportCreator {
  DefaultJumperLevelReportCreator({
    required this.requirements,
  });

  final Map<JumperLevelDescription, double> requirements;

  JumperLevelReport create({
    required SimulationJumper jumper,
  }) {
    final takeoffAndFlightAvg = ((jumper.takeoffQuality) + (jumper.flightQuality)) / 2;
    var levelDescription = JumperLevelDescription.values.last;
    requirements.forEach((description, requirement) {
      if (takeoffAndFlightAvg > requirement) {
        if (description.index < levelDescription.index) {
          levelDescription = description;
        }
      }
    });

    JumperCharacteristicOthernessStrength findAppropriateOthernessStrength(num delta) {
      const double deviationForOneStrength = 0.9;
      const double minDeviationAbsForFirstStrength = 0.25;

      // Handle the average case first
      if (delta.abs() < minDeviationAbsForFirstStrength) {
        return JumperCharacteristicOthernessStrength.average;
      }

      // Calculate the index in the enum
      int indexInEnum;
      if (delta < 0) {
        indexInEnum = (delta.abs() ~/ deviationForOneStrength) + 1;
      } else {
        indexInEnum = (delta ~/ deviationForOneStrength) + 6;
      }

      // Ensure the index is within the bounds of the enum values
      if (indexInEnum < 0) {
        indexInEnum = 0;
      } else if (indexInEnum >= JumperCharacteristicOthernessStrength.values.length) {
        indexInEnum = JumperCharacteristicOthernessStrength.values.length - 1;
      }

      return JumperCharacteristicOthernessStrength.values[indexInEnum];
    }

    final averageSkillRating = (jumper.takeoffQuality * 0.425) +
        (jumper.flightQuality * 0.425) +
        (jumper.landingQuality * 0.15);

    print('average skill rating: $averageSkillRating');
    print('jumper.skills.takeoffQuality: ${jumper.takeoffQuality}');
    print('jumper.skills.flightQuality: ${jumper.flightQuality}');
    print('jumper.skills.landingQuality: ${jumper.landingQuality}');

    return JumperLevelReport(
      levelDescription: levelDescription,
      characteristics: {
        JumperLevelCharacteristicCategory.takeoff: findAppropriateOthernessStrength(
          jumper.takeoffQuality - averageSkillRating,
        ),
        JumperLevelCharacteristicCategory.flight: findAppropriateOthernessStrength(
          jumper.flightQuality - averageSkillRating,
        ),
        JumperLevelCharacteristicCategory.landing: findAppropriateOthernessStrength(
          jumper.landingQuality - averageSkillRating,
        ),
      },
    );
  }
}

enum JumperCharacteristicOthernessStrength {
  average,
  below1,
  below2,
  below3,
  below4,
  below5,
  above1,
  above2,
  above3,
  above4,
  above5;

  static JumperCharacteristicOthernessStrength fromJson(String name) {
    return JumperCharacteristicOthernessStrength.values
        .singleWhere((value) => value.name == name);
  }
}
