part of '../../models/user_db/jumper/jumper.dart';

Jumper _jumperFromJson(Json json, {required JsonCountryLoader countryLoader}) {
  final country = countryLoader.load(json['country']);
  final sex = $enumDecode(_sexEnumJsonMap, json['sex']);
  final personality = $enumDecode(_personalitiesEnumJsonMap, json['personality']);
  return sex == Sex.male
      ? MaleJumper(
          name: json['name'] as String,
          surname: json['surname'] as String,
          country: country,
          dateOfBirth: DateTime.parse(json['dateOfBirth']),
          personality: personality,
          skills: JumperSkills.fromJson(json['skills'] as Map<String, dynamic>),
        )
      : FemaleJumper(
          name: json['name'] as String,
          surname: json['surname'] as String,
          country: country,
          dateOfBirth: DateTime.parse(json['dateOfBirth']),
          personality: personality,
          skills: JumperSkills.fromJson(json['skills'] as Map<String, dynamic>),
        );
}

Map<String, dynamic> _jumperToJson(Jumper jumper,
    {required JsonCountrySaver countrySaver}) {
  final countryJson = countrySaver.save(jumper.country);
  return <String, dynamic>{
    'name': jumper.name,
    'surname': jumper.surname,
    'country': countryJson,
    'dateOfBirth': jumper.dateOfBirth.toString(),
    'personality': _personalitiesEnumJsonMap[jumper.personality]!,
    'sex': _sexEnumJsonMap[jumper.sex]!,
    'skills': jumper.skills,
  };
}

const _sexEnumJsonMap = {
  Sex.male: 0,
  Sex.female: 1,
};

const _personalitiesEnumJsonMap = {
  Personalities.compromised: 'compromised',
  Personalities.selfCritical: 'selfCritical',
  Personalities.resigned: 'resigned',
  Personalities.nostalgic: 'nostalgic',
  Personalities.insecure: 'insecure',
  Personalities.yearning: 'yearning',
  Personalities.stubborn: 'stubborn',
  Personalities.arrogant: 'arrogant',
  Personalities.resourceful: 'resourceful',
  Personalities.balanced: 'balanced',
  Personalities.optimistic: 'optimistic',
  Personalities.open: 'open',
  Personalities.rational: 'rational',
  Personalities.devoted: 'devoted',
  Personalities.spiritualJoy: 'spiritualJoy',
  Personalities.spiritualPeace: 'spiritualPeace',
  Personalities.enlightened: 'enlightened',
};
