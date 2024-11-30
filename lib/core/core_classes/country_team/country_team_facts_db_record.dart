import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/core_classes/jumps/simple_jump_model.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam_type.dart';

part 'country_team_facts_db_record.g.dart';

@JsonSerializable()
class CountryTeamFactsDbRecord with EquatableMixin {
  const CountryTeamFactsDbRecord({
    required this.stars,
    this.record,
    required this.subteams,
    required this.limitInSubteam,
  });

  const CountryTeamFactsDbRecord.empty()
      : this(
          stars: 0,
          record: null,
          subteams: const {},
          limitInSubteam: const {},
        );

  final int stars;
  final SimpleJumpModel? record;
  final Set<SubteamType> subteams;
  final Map<SubteamType, int> limitInSubteam;

  static CountryTeamFactsDbRecord fromJson(Json json) =>
      _$CountryTeamFactsDbRecordFromJson(json);

  Json toJson() => _$CountryTeamFactsDbRecordToJson(this);

  @override
  List<Object?> get props => [
        stars,
        record,
        subteams,
        limitInSubteam,
      ];
}
