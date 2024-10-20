import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumper/jumping_style.dart';
import 'package:sj_manager/models/user_db/jumper/landing_style.dart';

part 'jumper_skills.g.dart';

@JsonSerializable()
class JumperSkills with EquatableMixin {
  const JumperSkills({
    required this.takeoffQuality,
    required this.flightQuality,
    required this.landingQuality,
    required this.jumpingStyle,
  });

  static const empty = JumperSkills(
    takeoffQuality: 0,
    flightQuality: 0,
    landingQuality: 0,
    jumpingStyle: JumpingStyle.balanced,
  );

  final double takeoffQuality;
  final double flightQuality;
  final double landingQuality;
  final JumpingStyle jumpingStyle;

  factory JumperSkills.fromJson(Json json) => _$JumperSkillsFromJson(json);

  Json toJson() => _$JumperSkillsToJson(this);

  @override
  List<Object?> get props => [
        takeoffQuality,
        flightQuality,
        landingQuality,
        jumpingStyle,
      ];

  JumperSkills copyWith({
    double? takeoffQuality,
    double? flightQuality,
    double? landingQuality,
    JumpingStyle? jumpingStyle,
  }) {
    return JumperSkills(
      takeoffQuality: takeoffQuality ?? this.takeoffQuality,
      flightQuality: flightQuality ?? this.flightQuality,
      landingQuality: landingQuality ?? this.landingQuality,
      jumpingStyle: jumpingStyle ?? this.jumpingStyle,
    );
  }
}
