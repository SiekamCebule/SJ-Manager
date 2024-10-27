import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:sj_manager/json/json_types.dart';

part 'jumper_skills.g.dart';

@JsonSerializable()
class JumperSkills with EquatableMixin {
  const JumperSkills({
    required this.takeoffQuality,
    required this.flightQuality,
    required this.landingQuality,
  });

  static const empty = JumperSkills(
    takeoffQuality: 0,
    flightQuality: 0,
    landingQuality: 0,
  );

  final double takeoffQuality;
  final double flightQuality;
  final double landingQuality;

  factory JumperSkills.fromJson(Json json) => _$JumperSkillsFromJson(json);

  Json toJson() => _$JumperSkillsToJson(this);

  @override
  List<Object?> get props => [
        takeoffQuality,
        flightQuality,
        landingQuality,
      ];

  JumperSkills copyWith({
    double? takeoffQuality,
    double? flightQuality,
    double? landingQuality,
  }) {
    return JumperSkills(
      takeoffQuality: takeoffQuality ?? this.takeoffQuality,
      flightQuality: flightQuality ?? this.flightQuality,
      landingQuality: landingQuality ?? this.landingQuality,
    );
  }
}
