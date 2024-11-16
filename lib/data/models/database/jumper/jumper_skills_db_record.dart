import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:sj_manager/utilities/json/json_types.dart';

part 'jumper_skills.g.dart';

@JsonSerializable()
class JumperSkillsDbRecord with EquatableMixin {
  JumperSkillsDbRecord({
    required this.takeoffQuality,
    required this.flightQuality,
    required this.landingQuality,
  });

  static final empty = JumperSkillsDbRecord(
    takeoffQuality: 0,
    flightQuality: 0,
    landingQuality: 0,
  );

  double takeoffQuality;
  double flightQuality;
  double landingQuality;

  factory JumperSkillsDbRecord.fromJson(Json json) => _$JumperSkillsFromJson(json);

  Json toJson() => _$JumperSkillsToJson(this);

  @override
  List<Object?> get props => [
        takeoffQuality,
        flightQuality,
        landingQuality,
      ];

  JumperSkillsDbRecord copyWith({
    double? takeoffQuality,
    double? flightQuality,
    double? landingQuality,
  }) {
    return JumperSkillsDbRecord(
      takeoffQuality: takeoffQuality ?? this.takeoffQuality,
      flightQuality: flightQuality ?? this.flightQuality,
      landingQuality: landingQuality ?? this.landingQuality,
    );
  }
}
