import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumps/simple_jump.dart';

part 'team_facts.g.dart';

@JsonSerializable()
class TeamFacts {
  const TeamFacts({
    required this.stars,
    this.record,
  });

  const TeamFacts.empty() : this(stars: 0, record: null);

  final int stars;
  final SimpleJump? record;

  static TeamFacts fromJson(Json json) => _$TeamFactsFromJson(json);

  Json toJson() => _$TeamFactsToJson(this);
}
