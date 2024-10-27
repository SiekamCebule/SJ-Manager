import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';

class JumperTrainingResult {
  const JumperTrainingResult({
    required this.skills,
    required this.form,
    required this.formStability,
    required this.jumpsConsistency,
    required this.fatigue,
  });

  final JumperSkills skills;
  final double form;
  final double formStability;
  final double jumpsConsistency;
  final double fatigue;
}
