import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumps/simple_jump.dart';
import 'package:sj_manager/models/user_db/team/country_team/subteam_type.dart';

part 'country_team_facts.g.dart';

@JsonSerializable()
class CountryTeamFacts with EquatableMixin {
  const CountryTeamFacts({
    required this.stars,
    this.record,
    required this.subteams,
    required this.limitInSubteam,
  });

  const CountryTeamFacts.empty()
      : this(
          stars: 0,
          record: null,
          subteams: const {},
          limitInSubteam: const {},
        );

  final int stars;
  final SimpleJump? record;
  final Set<SubteamType> subteams;
  final Map<SubteamType, int> limitInSubteam;

  static CountryTeamFacts fromJson(Json json) => _$CountryTeamFactsFromJson(json);

  Json toJson() => _$CountryTeamFactsToJson(this);

  @override
  List<Object?> get props => [
        stars,
        record,
        subteams,
        limitInSubteam,
      ];
}
