import 'package:sj_manager/models/simulation/flow/reports/jumper_level_description.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumper/jumping_technique.dart';

class DefaultJumperLevelReportCreator {
  DefaultJumperLevelReportCreator({
    required this.requirements,
  });

  final Map<JumperLevelDescription, double> requirements;

  JumperLevelReport create({
    required Jumper jumper,
  }) {
    print(
      'Create a raport for: ${jumper.nameAndSurname(capitalizeSurname: true, reverse: true)}',
    );
    final takeoffAndFlightAvg =
        ((jumper.skills.takeoffQuality) + (jumper.skills.flightQuality)) / 2;
    var levelDescription = JumperLevelDescription.values.last;
    requirements.forEach((description, requirement) {
      if (takeoffAndFlightAvg > requirement) {
        if (description.index < levelDescription.index) {
          levelDescription = description;
        }
      }
    });

    JumperCharacteristicOthernessStrength findAppropriateOthernessStrength(num delta) {
      const deviationForOneStrength = 0.9;
      const minDeviationAbsForFirstStrength = 0.25;
      if (delta.abs() < minDeviationAbsForFirstStrength) {
        return JumperCharacteristicOthernessStrength.average;
      }
      late final int indexInEnum;
      if (delta < 0) {
        indexInEnum = (delta.abs() ~/ deviationForOneStrength) + 1;
      } else {
        indexInEnum = (delta ~/ deviationForOneStrength) + 6;
      }
      return JumperCharacteristicOthernessStrength.values[indexInEnum];
    }

    final averageSkillRating = (jumper.skills.takeoffQuality * 0.425) +
        (jumper.skills.flightQuality * 0.425) +
        (jumper.skills.landingQuality * 0.15);

    print('average skill rating: $averageSkillRating');
    print('jumper.skills.takeoffQuality: ${jumper.skills.takeoffQuality}');
    print('jumper.skills.flightQuality: ${jumper.skills.flightQuality}');
    print('jumper.skills.landingQuality: ${jumper.skills.landingQuality}');

    final riskInJumps = switch (jumper.skills.jumpingTechnique) {
      JumpingTechnique.veryDefensive => JumperCharacteristicOthernessStrength.below5,
      JumpingTechnique.clearlyDefensive => JumperCharacteristicOthernessStrength.below4,
      JumpingTechnique.defensive => JumperCharacteristicOthernessStrength.below3,
      JumpingTechnique.cautious => JumperCharacteristicOthernessStrength.below2,
      JumpingTechnique.slightlyCautious => JumperCharacteristicOthernessStrength.below1,
      JumpingTechnique.balanced => JumperCharacteristicOthernessStrength.average,
      JumpingTechnique.fairlyUnpredictable =>
        JumperCharacteristicOthernessStrength.above1,
      JumpingTechnique.unpredictable => JumperCharacteristicOthernessStrength.above2,
      JumpingTechnique.risky => JumperCharacteristicOthernessStrength.above3,
      JumpingTechnique.clearlyRisky => JumperCharacteristicOthernessStrength.above4,
      JumpingTechnique.veryRisky => JumperCharacteristicOthernessStrength.above5,
    };

    return JumperLevelReport(
      levelDescription: levelDescription,
      characteristics: {
        JumperLevelCharacteristicCategory.takeoff: findAppropriateOthernessStrength(
          jumper.skills.takeoffQuality - averageSkillRating,
        ),
        JumperLevelCharacteristicCategory.flight: findAppropriateOthernessStrength(
          jumper.skills.flightQuality - averageSkillRating,
        ),
        JumperLevelCharacteristicCategory.landing: findAppropriateOthernessStrength(
          jumper.skills.landingQuality - averageSkillRating,
        ),
        JumperLevelCharacteristicCategory.riskInJumps: riskInJumps,
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
