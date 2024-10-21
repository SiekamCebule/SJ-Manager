import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumper/jumping_technique.dart';

part 'jumper_skills.g.dart';

@JsonSerializable()
class JumperSkills with EquatableMixin {
  const JumperSkills({
    required this.takeoffQuality,
    required this.flightQuality,
    required this.landingQuality,
    required this.jumpingTechnique,
  });

  static const empty = JumperSkills(
    takeoffQuality: 0,
    flightQuality: 0,
    landingQuality: 0,
    jumpingTechnique: JumpingTechnique.balanced,
  );

  final double takeoffQuality;
  final double flightQuality;
  final double landingQuality;
  final JumpingTechnique jumpingTechnique;

  factory JumperSkills.fromJson(Json json) => _$JumperSkillsFromJson(json);

  Json toJson() => _$JumperSkillsToJson(this);

  @override
  List<Object?> get props => [
        takeoffQuality,
        flightQuality,
        landingQuality,
        jumpingTechnique,
      ];

  JumperSkills copyWith({
    double? takeoffQuality,
    double? flightQuality,
    double? landingQuality,
    JumpingTechnique? jumpingTechnique,
  }) {
    return JumperSkills(
      takeoffQuality: takeoffQuality ?? this.takeoffQuality,
      flightQuality: flightQuality ?? this.flightQuality,
      landingQuality: landingQuality ?? this.landingQuality,
      jumpingTechnique: jumpingTechnique ?? this.jumpingTechnique,
    );
  }
}
