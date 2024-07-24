import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/json/json_types.dart';

part 'simple_jump_record.g.dart';

@JsonSerializable()
class SimpleJumpRecord {
  const SimpleJumpRecord({
    required this.jumperNameAndSurname,
    required this.distance,
  });

  final String jumperNameAndSurname;

  final double distance;

  static SimpleJumpRecord fromJson(Json json) => _$SimpleJumpRecordFromJson(json);

  Json toJson() => _$SimpleJumpRecordToJson(this);
}
