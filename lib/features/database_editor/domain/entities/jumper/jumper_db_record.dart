import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/core/mixins/country_mixin.dart';
import 'package:sj_manager/core/mixins/name_and_surname_mixin.dart';
import 'package:sj_manager/core/mixins/sex_mixin.dart';

import 'package:sj_manager/utilities/json/countries.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_skills.dart';
import 'package:sj_manager/core/psyche/personalities.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_database.dart/sex.dart';

part '../../../../../utilities/json/manual_json/jumper_json.dart';

class JumperDbRecord with EquatableMixin, NameAndSurnameMixin, CountryMixin, SexMixin {
  JumperDbRecord({
    required this.name,
    required this.surname,
    required this.country,
    required this.sex,
    required this.dateOfBirth,
    required this.personality,
    required this.skills,
  });

  factory JumperDbRecord.empty({required Country country}) {
    return JumperDbRecord(
      name: '',
      surname: '',
      country: country,
      sex: Sex.male,
      dateOfBirth: DateTime.now(),
      personality: Personalities.resourceful,
      skills: JumperSkills.empty,
    );
  }

  DateTime dateOfBirth;

  @override
  String name;

  @override
  String surname;

  @override
  Country country;

  @override
  Sex sex;

  Personalities personality;
  JumperSkills skills;

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

  static JumperDbRecord fromJson(Json json, {required JsonCountryLoader countryLoader}) {
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

  JumperDbRecord copyWith({
    DateTime? dateOfBirth,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    Personalities? personality,
    JumperSkills? skills,
  }) {
    return JumperDbRecord(
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

class MaleJumperDbRecord extends JumperDbRecord {
  MaleJumperDbRecord({
    required super.name,
    required super.surname,
    required super.country,
    required super.dateOfBirth,
    required super.personality,
    required super.skills,
  }) : super(sex: Sex.male);

  static MaleJumperDbRecord fromJson(Json json,
      {required JsonCountryLoader countryLoader}) {
    final jumper = JumperDbRecord.fromJson(json, countryLoader: countryLoader);
    return MaleJumperDbRecord(
      name: jumper.name,
      surname: jumper.surname,
      country: jumper.country,
      dateOfBirth: jumper.dateOfBirth,
      personality: jumper.personality,
      skills: jumper.skills,
    );
  }

  static MaleJumperDbRecord empty({required Country country}) {
    return MaleJumperDbRecord(
      name: '',
      surname: '',
      country: country,
      dateOfBirth: DateTime.now(),
      personality: Personalities.resourceful,
      skills: JumperSkills.empty,
    );
  }

  @override
  MaleJumperDbRecord copyWith({
    DateTime? dateOfBirth,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    Personalities? personality,
    JumperSkills? skills,
  }) {
    return MaleJumperDbRecord(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      personality: personality ?? this.personality,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      country: country ?? this.country,
      skills: skills ?? this.skills,
    );
  }
}

class FemaleJumperDbRecord extends JumperDbRecord {
  FemaleJumperDbRecord({
    required super.name,
    required super.surname,
    required super.country,
    required super.dateOfBirth,
    required super.personality,
    required super.skills,
  }) : super(sex: Sex.female);

  static FemaleJumperDbRecord fromJson(Json json,
      {required JsonCountryLoader countryLoader}) {
    final jumper = JumperDbRecord.fromJson(json, countryLoader: countryLoader);
    return FemaleJumperDbRecord(
      name: jumper.name,
      surname: jumper.surname,
      country: jumper.country,
      dateOfBirth: jumper.dateOfBirth,
      personality: jumper.personality,
      skills: jumper.skills,
    );
  }

  static FemaleJumperDbRecord empty({required Country country}) {
    return FemaleJumperDbRecord(
      name: '',
      surname: '',
      country: country,
      dateOfBirth: DateTime.now(),
      personality: Personalities.resourceful,
      skills: JumperSkills.empty,
    );
  }

  @override
  FemaleJumperDbRecord copyWith({
    DateTime? dateOfBirth,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    Personalities? personality,
    JumperSkills? skills,
  }) {
    return FemaleJumperDbRecord(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      personality: personality ?? this.personality,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      country: country ?? this.country,
      skills: skills ?? this.skills,
    );
  }
}
