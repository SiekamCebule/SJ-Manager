import 'package:sj_manager/features/game_variants/data/models/jumper/jumper_db_record_model.dart';
import 'package:sj_manager/features/game_variants/data/models/jumper/jumper_skills_model.dart';
import 'package:sj_manager/features/game_variants/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/game_variants/domain/entities/jumper/jumper_skills.dart';

extension JumperDbRecordToModel on JumperDbRecord {
  JumperDbRecordModel toModel() {
    return JumperDbRecordModel(
      dateOfBirth: dateOfBirth,
      name: name,
      surname: surname,
      country: country,
      sex: sex,
      personality: personality,
      skills: skills.toModel(),
    );
  }
}

extension JumperSkillsToModel on JumperSkills {
  JumperSkillsModel toModel() {
    return JumperSkillsModel(
      takeoffQuality: takeoffQuality,
      flightQuality: flightQuality,
      landingQuality: landingQuality,
    );
  }
}

JumperDbRecord jumperDbRecordFromModel(JumperDbRecordModel model) {
  return JumperDbRecord(
    name: model.name,
    surname: model.surname,
    country: model.country,
    sex: model.sex,
    dateOfBirth: model.dateOfBirth,
    personality: model.personality,
    skills: jumperSkillsFromModel(model.skills),
  );
}

JumperSkills jumperSkillsFromModel(JumperSkillsModel model) {
  return JumperSkills(
    takeoffQuality: model.takeoffQuality,
    flightQuality: model.flightQuality,
    landingQuality: model.landingQuality,
  );
}
