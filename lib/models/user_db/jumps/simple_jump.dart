import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/json/json_types.dart';

part 'simple_jump.g.dart';

@JsonSerializable()
class SimpleJump {
  const SimpleJump({
    required this.jumperNameAndSurname,
    required this.distance,
  });

  final String jumperNameAndSurname;
  final double distance;

  static SimpleJump fromJson(Json json) => _$SimpleJumpFromJson(json);

  Json toJson() => _$SimpleJumpToJson(this);
}
