import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/jumper/jumper_skills.dart';
import 'package:sj_manager/models/sex.dart';

part '../../json/manual_json/jumper_json.dart';

class Jumper with EquatableMixin {
  const Jumper({
    required this.name,
    required this.surname,
    required this.country,
    required this.sex,
    required this.age,
    required this.skills,
  });

  factory Jumper.empty({required Country country}) {
    return Jumper(
      name: '',
      surname: '',
      country: country,
      sex: Sex.male,
      age: 0,
      skills: JumperSkills.empty,
    );
  }

  final int age;
  final String name;
  final String surname;
  final Country country;
  final Sex sex;
  final JumperSkills skills;

  String nameAndSurname({bool capitalizeSurname = false, bool reverse = false}) {
    var appropiateSurname = surname;
    if (capitalizeSurname) {
      appropiateSurname = appropiateSurname.toUpperCase();
    }
    return reverse ? '$appropiateSurname $name ' : '$name $appropiateSurname';
  }

  static Jumper fromJson(Json json, {required JsonCountryLoader countryLoader}) {
    return _jumperFromJson(json, countryLoader: countryLoader);
  }

  Json toJson({required JsonCountrySaver countrySaver}) => _jumperToJson(
        this,
        countrySaver: countrySaver,
      );

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

  Jumper copyWith({
    int? age,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    JumperSkills? skills,
  }) {
    return Jumper(
      age: age ?? this.age,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      country: country ?? this.country,
      sex: sex ?? this.sex,
      skills: skills ?? this.skills,
    );
  }
}

class MaleJumper extends Jumper {
  const MaleJumper({
    required super.name,
    required super.surname,
    required super.country,
    required super.age,
    required super.skills,
  }) : super(sex: Sex.male);

  static MaleJumper fromJson(Json json, {required JsonCountryLoader countryLoader}) {
    final jumper = Jumper.fromJson(json, countryLoader: countryLoader);
    return MaleJumper(
      name: jumper.name,
      surname: jumper.surname,
      country: jumper.country,
      age: jumper.age,
      skills: jumper.skills,
    );
  }

  static MaleJumper empty({required Country country}) {
    return MaleJumper(
      name: '',
      surname: '',
      country: country,
      age: 0,
      skills: JumperSkills.empty,
    );
  }

  @override
  MaleJumper copyWith({
    int? age,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    JumperSkills? skills,
  }) {
    return MaleJumper(
      age: age ?? this.age,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      country: country ?? this.country,
      skills: skills ?? this.skills,
    );
  }
}

class FemaleJumper extends Jumper {
  const FemaleJumper({
    required super.name,
    required super.surname,
    required super.country,
    required super.age,
    required super.skills,
  }) : super(sex: Sex.female);

  static FemaleJumper fromJson(Json json, {required JsonCountryLoader countryLoader}) {
    final jumper = Jumper.fromJson(json, countryLoader: countryLoader);
    return FemaleJumper(
      name: jumper.name,
      surname: jumper.surname,
      country: jumper.country,
      age: jumper.age,
      skills: jumper.skills,
    );
  }

  static FemaleJumper empty({required Country country}) {
    return FemaleJumper(
      name: '',
      surname: '',
      country: country,
      age: 0,
      skills: JumperSkills.empty,
    );
  }

  @override
  FemaleJumper copyWith({
    int? age,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    JumperSkills? skills,
  }) {
    return FemaleJumper(
      age: age ?? this.age,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      country: country ?? this.country,
      skills: skills ?? this.skills,
    );
  }
}
