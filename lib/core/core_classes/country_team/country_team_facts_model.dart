import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/core_classes/jumps/simple_jump_model.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/subteam_type.dart';

part 'country_team_facts.g.dart';

@JsonSerializable()
class CountryTeamFactsModel with EquatableMixin {
  const CountryTeamFactsModel({
    required this.stars,
    this.record,
    required this.subteams,
    required this.limitInSubteam,
  });

  const CountryTeamFactsModel.empty()
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

  static CountryTeamFactsModel fromJson(Json json) => _$CountryTeamFactsFromJson(json);

  Json toJson() => _$CountryTeamFactsToJson(this);

  @override
  List<Object?> get props => [
        stars,
        record,
        subteams,
        limitInSubteam,
      ];
}
