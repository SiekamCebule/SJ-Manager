import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/utilities/json/json_types.dart';

part 'simple_jump.g.dart';

@JsonSerializable()
class SimpleJumpModel with EquatableMixin {
  const SimpleJumpModel({
    required this.jumperNameAndSurname,
    required this.distance,
  });

  final String jumperNameAndSurname;
  final double distance;

  static SimpleJumpModel fromJson(Json json) => _$SimpleJumpFromJson(json);

  Json toJson() => _$SimpleJumpToJson(this);

  @override
  List<Object?> get props => [
        jumperNameAndSurname,
        distance,
      ];
}
