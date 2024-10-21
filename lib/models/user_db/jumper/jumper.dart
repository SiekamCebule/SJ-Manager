// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/models/user_db/psyche/personalities.dart';
import 'package:sj_manager/models/user_db/sex.dart';

part '../../../json/manual_json/jumper_json.dart';

class Jumper with EquatableMixin {
  const Jumper({
    required this.name,
    required this.surname,
    required this.country,
    required this.sex,
    required this.dateOfBirth,
    required this.personality,
    required this.skills,
  });

  factory Jumper.empty({required Country country}) {
    return Jumper(
      name: '',
      surname: '',
      country: country,
      sex: Sex.male,
      dateOfBirth: DateTime.now(),
      personality: Personalities.resourceful,
      skills: JumperSkills.empty,
    );
  }

  final DateTime dateOfBirth;
  final String name;
  final String surname;
  final Country country;
  final Sex sex;
  final Personalities personality;
  final JumperSkills skills;

  int age({required DateTime date}) {
    int age = date.year - dateOfBirth.year;
    if (date.month < dateOfBirth.month ||
        (date.month == dateOfBirth.month && date.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    // Sprawdzanie, czy urodziny były już w tym roku
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  String nameAndSurname({bool capitalizeSurname = false, bool reverse = false}) {
    var appropriateSurname = surname;
    if (capitalizeSurname) {
      appropriateSurname = appropriateSurname.toUpperCase();
    }
    return reverse ? '$appropriateSurname $name ' : '$name $appropriateSurname';
  }

  static Jumper fromJson(Json json, {required JsonCountryLoader countryLoader}) {
    return _jumperFromJson(json, countryLoader: countryLoader);
  }

  Json toJson({required JsonCountrySaver countrySaver}) => _jumperToJson(
        this,
        countrySaver: countrySaver,
      );

  @override
  List<Object?> get props => [
        dateOfBirth,
        personality,
        name,
        surname,
        country,
        sex,
        skills,
      ];

  Jumper copyWith({
    DateTime? dateOfBirth,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    Personalities? personality,
    JumperSkills? skills,
  }) {
    return Jumper(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      country: country ?? this.country,
      sex: sex ?? this.sex,
      personality: personality ?? this.personality,
      skills: skills ?? this.skills,
    );
  }
}

class MaleJumper extends Jumper {
  const MaleJumper({
    required super.name,
    required super.surname,
    required super.country,
    required super.dateOfBirth,
    required super.personality,
    required super.skills,
  }) : super(sex: Sex.male);

  static MaleJumper fromJson(Json json, {required JsonCountryLoader countryLoader}) {
    final jumper = Jumper.fromJson(json, countryLoader: countryLoader);
    return MaleJumper(
      name: jumper.name,
      surname: jumper.surname,
      country: jumper.country,
      dateOfBirth: jumper.dateOfBirth,
      personality: jumper.personality,
      skills: jumper.skills,
    );
  }

  static MaleJumper empty({required Country country}) {
    return MaleJumper(
      name: '',
      surname: '',
      country: country,
      dateOfBirth: DateTime.now(),
      personality: Personalities.resourceful,
      skills: JumperSkills.empty,
    );
  }

  @override
  MaleJumper copyWith({
    DateTime? dateOfBirth,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    Personalities? personality,
    JumperSkills? skills,
  }) {
    return MaleJumper(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      personality: personality ?? this.personality,
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
    required super.dateOfBirth,
    required super.personality,
    required super.skills,
  }) : super(sex: Sex.female);

  static FemaleJumper fromJson(Json json, {required JsonCountryLoader countryLoader}) {
    final jumper = Jumper.fromJson(json, countryLoader: countryLoader);
    return FemaleJumper(
      name: jumper.name,
      surname: jumper.surname,
      country: jumper.country,
      dateOfBirth: jumper.dateOfBirth,
      personality: jumper.personality,
      skills: jumper.skills,
    );
  }

  static FemaleJumper empty({required Country country}) {
    return FemaleJumper(
      name: '',
      surname: '',
      country: country,
      dateOfBirth: DateTime.now(),
      personality: Personalities.resourceful,
      skills: JumperSkills.empty,
    );
  }

  @override
  FemaleJumper copyWith({
    DateTime? dateOfBirth,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    Personalities? personality,
    JumperSkills? skills,
  }) {
    return FemaleJumper(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      personality: personality ?? this.personality,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      country: country ?? this.country,
      skills: skills ?? this.skills,
    );
  }
}
