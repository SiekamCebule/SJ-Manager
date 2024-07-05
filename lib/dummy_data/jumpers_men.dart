import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/jumper.dart';
import 'package:sj_manager/models/jumper_skills.dart';
import 'package:sj_manager/models/sex.dart';

const jumpersMale = [
  Jumper(
    name: 'Philipp',
    surname: 'Aschenwald',
    age: 28,
    country: Country(code: 'at', name: 'Austria'),
    sex: Sex.male,
    skills: JumperSkills(
      qualityOnSmallerHills: 82,
      qualityOnLargerHills: 74,
      landingStyle: LandingStyle.graceful,
      jumpsConsistency: JumpsConsistency.veryConsistent,
    ),
  ),
  Jumper(
    name: 'Daniel',
    surname: 'Huber',
    age: 31,
    country: Country(code: 'at', name: 'Austria'),
    sex: Sex.male,
    skills: JumperSkills(
      qualityOnSmallerHills: 85,
      qualityOnLargerHills: 86,
      landingStyle: LandingStyle.average,
      jumpsConsistency: JumpsConsistency.inconsistent,
    ),
  ),
  Jumper(
    name: 'Yevhen',
    surname: 'Marusiak',
    age: 24,
    country: Country(code: 'ua', name: 'Ukraina'),
    sex: Sex.male,
    skills: JumperSkills(
      qualityOnSmallerHills: 74,
      qualityOnLargerHills: 77,
      landingStyle: LandingStyle.average,
      jumpsConsistency: JumpsConsistency.inconsistent,
    ),
  ),
  Jumper(
    name: 'Vladimir',
    surname: 'Zografski',
    age: 30,
    country: Country(code: 'bg', name: 'Bułgaria'),
    sex: Sex.male,
    skills: JumperSkills(
      qualityOnSmallerHills: 77,
      qualityOnLargerHills: 75,
      landingStyle: LandingStyle.ugly,
      jumpsConsistency: JumpsConsistency.inconsistent,
    ),
  ),
];
