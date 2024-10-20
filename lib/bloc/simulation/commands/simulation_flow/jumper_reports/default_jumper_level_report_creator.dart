import 'package:sj_manager/models/simulation/flow/reports/jumper_level_description.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class DefaultJumperLevelReportCreator {
  DefaultJumperLevelReportCreator({
    required this.requirements,
  });

  final Map<JumperLevelDescription, double> requirements;

  JumperLevelReport create({
    required Jumper jumper,
  }) {
    final rating = ((jumper.skills.takeoffQuality) + (jumper.skills.takeoffQuality)) / 2;

    var levelDescription = JumperLevelDescription.values.last;
    requirements.forEach((description, requirement) {
      if (rating > requirement) {
        if (description.index < levelDescription.index) {
          levelDescription = description;
        }
      }
    });

    return JumperLevelReport(
      levelDescription: levelDescription,
      characteristics: {}, // TODO
    );
  }
}
