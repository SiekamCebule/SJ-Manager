import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:sj_manager/utilities/json/json_types.dart';

part 'jumper_skills_model.g.dart';

@JsonSerializable()
class JumperSkillsModel with EquatableMixin {
  const JumperSkillsModel({
    required this.takeoffQuality,
    required this.flightQuality,
    required this.landingQuality,
  });

  static const empty = JumperSkillsModel(
    takeoffQuality: 0,
    flightQuality: 0,
    landingQuality: 0,
  );

  final double takeoffQuality;
  final double flightQuality;
  final double landingQuality;

  factory JumperSkillsModel.fromJson(Json json) => _$JumperSkillsModelFromJson(json);

  Json toJson() => _$JumperSkillsModelToJson(this);

  @override
  List<Object?> get props => [
        takeoffQuality,
        flightQuality,
        landingQuality,
      ];

  JumperSkillsModel copyWith({
    double? takeoffQuality,
    double? flightQuality,
    double? landingQuality,
  }) {
    return JumperSkillsModel(
      takeoffQuality: takeoffQuality ?? this.takeoffQuality,
      flightQuality: flightQuality ?? this.flightQuality,
      landingQuality: landingQuality ?? this.landingQuality,
    );
  }
}
