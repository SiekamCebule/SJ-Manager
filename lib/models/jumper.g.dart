// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jumper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jumper _$JumperFromJson(Map<String, dynamic> json) => Jumper(
      name: json['name'] as String,
      surname: json['surname'] as String,
      country: Country.fromJson(json['country'] as String),
      sex: $enumDecode(_$SexEnumMap, json['sex']),
      age: (json['age'] as num).toInt(),
      skills: JumperSkills.fromJson(json['skills'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JumperToJson(Jumper instance) => <String, dynamic>{
      'age': instance.age,
      'name': instance.name,
      'surname': instance.surname,
      'country': instance.country,
      'sex': _$SexEnumMap[instance.sex]!,
      'skills': instance.skills,
    };

const _$SexEnumMap = {
  Sex.male: 0,
  Sex.female: 1,
};
