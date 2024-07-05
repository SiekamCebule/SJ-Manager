import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/json/convertable_to_json.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/jumper_skills.dart';
import 'package:sj_manager/models/sex.dart';

part 'jumper.g.dart';

@JsonSerializable()
class Jumper with EquatableMixin implements ConvertableToJson<Jumper> {
  const Jumper({
    required this.name,
    required this.surname,
    required this.country,
    required this.sex,
    required this.age,
    required this.skills,
  });

  final int age;
  final String name;
  final String surname;
  final Country? country;
  final Sex sex;
  final JumperSkills skills;

  static Jumper fromJson(Json json) => _$JumperFromJson(json);

  @override
  Json toJson() => _$JumperToJson(this);

  @override
  String toString() {
    return '$name $surname ($country) - $sex, ${age}yo';
  }

  @override
  List<Object?> get props => [
        age,
        name,
        surname,
        country,
        sex,
        skills,
      ];
}
