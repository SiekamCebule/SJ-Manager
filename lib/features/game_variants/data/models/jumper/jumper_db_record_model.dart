import 'package:equatable/equatable.dart';
import 'package:sj_manager/core/country/country.dart';
import 'package:sj_manager/core/psyche/personalities.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_database.dart/sex.dart';
import 'package:sj_manager/features/game_variants/data/models/jumper/jumper_skills_model.dart';
import 'package:sj_manager/utilities/json/countries.dart';
import 'package:sj_manager/utilities/json/json_types.dart';

class JumperDbRecordModel with EquatableMixin {
  const JumperDbRecordModel({
    required this.dateOfBirth,
    required this.name,
    required this.surname,
    required this.country,
    required this.sex,
    required this.personality,
    required this.skills,
  });

  final DateTime dateOfBirth;
  final String name;
  final String surname;
  final Country country;
  final Sex sex;
  final Personalities personality;
  final JumperSkillsModel skills;

  static JumperDbRecordModel fromJson(Json json,
      {required JsonCountryLoader countryLoader}) {
    return JumperDbRecordModel(
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      name: json['name'],
      surname: json['name'],
      country: countryLoader.load(json['country']),
      sex: Sex.values.firstWhere((sex) => sex.name == json['sex']),
      personality: Personalities.values
          .firstWhere((personality) => personality.name == json['personality']),
      skills: JumperSkillsModel.fromJson(json['skills']),
    );
  }

  Json toJson({required JsonCountrySaver countrySaver}) {
    return {
      'dateOfBirth': dateOfBirth.toString(),
      'name': name,
      'surname': surname,
      'country': countrySaver.save(country),
      'sex': sex.name,
      'personality': personality.name,
      'skills': skills.toJson(),
    };
  }

  JumperDbRecordModel copyWith({
    DateTime? dateOfBirth,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    Personalities? personality,
    JumperSkillsModel? skills,
  }) {
    return JumperDbRecordModel(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      country: country ?? this.country,
      sex: sex ?? this.sex,
      personality: personality ?? this.personality,
      skills: skills ?? this.skills,
    );
  }

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
}
