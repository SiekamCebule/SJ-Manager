part of '../../models/jumper/jumper.dart';

Jumper _jumperFromJson(Json json, {required JsonCountryLoader countryLoader}) {
  final country = countryLoader.load(json['country']);
  return Jumper(
    name: json['name'] as String,
    surname: json['surname'] as String,
    country: country,
    sex: $enumDecode(sexEnumJsonMap, json['sex']),
    age: (json['age'] as num).toInt(),
    skills: JumperSkills.fromJson(json['skills'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _jumperToJson(Jumper jumper,
    {required JsonCountrySaver countrySaver}) {
  final countryJson = countrySaver.save(jumper.country);
  return <String, dynamic>{
    'age': jumper.age,
    'name': jumper.name,
    'surname': jumper.surname,
    'country': countryJson,
    'sex': sexEnumJsonMap[jumper.sex]!,
    'skills': jumper.skills,
  };
}

const sexEnumJsonMap = {
  Sex.male: 0,
  Sex.female: 1,
};
