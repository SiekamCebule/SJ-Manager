import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/json/json_types.dart';

part 'jumper_skills.g.dart';

@JsonSerializable()
class JumperSkills with EquatableMixin {
  const JumperSkills({
    required this.qualityOnSmallerHills,
    required this.qualityOnLargerHills,
    required this.landingStyle,
    required this.jumpsConsistency,
  });

  final double qualityOnSmallerHills;
  final double qualityOnLargerHills;
  final LandingStyle landingStyle;
  final JumpsConsistency jumpsConsistency;

  factory JumperSkills.fromJson(Json json) => _$JumperSkillsFromJson(json);

  Json toJson() => _$JumperSkillsToJson(this);

  @override
  List<Object?> get props => [
        qualityOnSmallerHills,
        qualityOnLargerHills,
        landingStyle,
        jumpsConsistency,
      ];
}
