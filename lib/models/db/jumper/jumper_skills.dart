// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/jumper/jumps_consistency.dart';
import 'package:sj_manager/models/db/jumper/landing_style.dart';

part 'jumper_skills.g.dart';

@JsonSerializable()
class JumperSkills with EquatableMixin {
  const JumperSkills({
    required this.qualityOnSmallerHills,
    required this.qualityOnLargerHills,
    required this.landingStyle,
    required this.jumpsConsistency,
  });

  static const empty = JumperSkills(
    qualityOnSmallerHills: 0,
    qualityOnLargerHills: 0,
    landingStyle: LandingStyle.average,
    jumpsConsistency: JumpsConsistency.average,
  );

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

  JumperSkills copyWith({
    double? qualityOnSmallerHills,
    double? qualityOnLargerHills,
    LandingStyle? landingStyle,
    JumpsConsistency? jumpsConsistency,
  }) {
    return JumperSkills(
      qualityOnSmallerHills:
          qualityOnSmallerHills ?? this.qualityOnSmallerHills,
      qualityOnLargerHills: qualityOnLargerHills ?? this.qualityOnLargerHills,
      landingStyle: landingStyle ?? this.landingStyle,
      jumpsConsistency: jumpsConsistency ?? this.jumpsConsistency,
    );
  }
}
