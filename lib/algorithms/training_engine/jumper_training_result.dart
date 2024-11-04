import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';

class JumperTrainingResult with EquatableMixin {
  const JumperTrainingResult({
    required this.skills,
    required this.form,
    required this.jumpsConsistency,
    required this.fatigue,
    required this.trainingFeeling,
  });

  final JumperSkills skills;
  final double form;
  final double jumpsConsistency;
  final double fatigue;
  final Map<JumperTrainingCategory, double> trainingFeeling;

  @override
  List<Object?> get props => [
        skills,
        form,
        jumpsConsistency,
        fatigue,
        trainingFeeling,
      ];
}
