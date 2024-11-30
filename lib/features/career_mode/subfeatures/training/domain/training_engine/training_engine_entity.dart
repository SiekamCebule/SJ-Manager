// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/psyche/level_of_consciousness.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_config.dart';

class TrainingEngineEntity {
  const TrainingEngineEntity({
    required this.takeoffQuality,
    required this.flightQuality,
    required this.landingQuality,
    required this.form,
    required this.jumpsConsistency,
    required this.morale,
    required this.fatigue,
    required this.levelOfConsciousness,
    required this.trainingConfig,
  });

  final double takeoffQuality;
  final double flightQuality;
  final double landingQuality;
  final double form;
  final double jumpsConsistency;
  final double morale;
  final double fatigue;
  final LevelOfConsciousness levelOfConsciousness;
  final JumperTrainingConfig? trainingConfig;

  factory TrainingEngineEntity.fromJson(Json json) {
    return TrainingEngineEntity(
      takeoffQuality: json['takeoffQuality'],
      flightQuality: json['flightQuality'],
      landingQuality: json['landingQuality'],
      form: json['form'],
      jumpsConsistency: json['jumpsConsistency'],
      morale: json['morale'],
      fatigue: json['fatigue'],
      levelOfConsciousness: LevelOfConsciousness.fromJson(json['levelOfConsciousness']),
      trainingConfig: JumperTrainingConfig.fromJson(json['trainingConfig']),
    );
  }

  TrainingEngineEntity copyWith({
    double? takeoffQuality,
    double? flightQuality,
    double? landingQuality,
    double? form,
    double? jumpsConsistency,
    double? morale,
    double? fatigue,
    LevelOfConsciousness? levelOfConsciousness,
    JumperTrainingConfig? trainingConfig,
  }) {
    return TrainingEngineEntity(
      takeoffQuality: takeoffQuality ?? this.takeoffQuality,
      flightQuality: flightQuality ?? this.flightQuality,
      landingQuality: landingQuality ?? this.landingQuality,
      form: form ?? this.form,
      jumpsConsistency: jumpsConsistency ?? this.jumpsConsistency,
      morale: morale ?? this.morale,
      fatigue: fatigue ?? this.fatigue,
      levelOfConsciousness: levelOfConsciousness ?? this.levelOfConsciousness,
      trainingConfig: trainingConfig ?? this.trainingConfig,
    );
  }
}
