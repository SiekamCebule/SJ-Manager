import 'package:equatable/equatable.dart';
import 'package:sj_manager/core/mixins/country_mixin.dart';
import 'package:sj_manager/core/mixins/name_and_surname_mixin.dart';
import 'package:sj_manager/core/mixins/sex_mixin.dart';
import 'package:sj_manager/domain/entities/simulation/psyche/level_of_consciousness.dart';
import 'package:sj_manager/utilities/json/countries.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_database.dart/sex.dart';
import 'package:sj_manager/domain/entities/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/stats/jumper_stats.dart';

class SimulationJumper with EquatableMixin, NameAndSurnameMixin, CountryMixin, SexMixin {
  SimulationJumper({
    required this.dateOfBirth,
    required this.name,
    required this.surname,
    required this.country,
    required this.sex,
    required this.takeoffQuality,
    required this.flightQuality,
    required this.landingQuality,
    required this.trainingConfig,
    required this.form,
    required this.jumpsConsistency,
    required this.morale,
    required this.fatigue,
    required this.levelOfConsciousness,
    required this.reports,
    required this.stats,
  });

  DateTime dateOfBirth;

  @override
  String name;

  @override
  String surname;

  @override
  Country country;

  @override
  Sex sex;

  /// From 1 to 20
  double takeoffQuality;

  /// From 1 to 20
  double flightQuality;

  // From 1 to 20
  double landingQuality;

  JumperTrainingConfig? trainingConfig;

  /// From 1 to 20
  double form;

  /// From 1 to 20
  double jumpsConsistency;

  /// From -1 to 1
  double morale;

  /// From -1 to 1
  double fatigue;

  LevelOfConsciousness levelOfConsciousness;
  JumperReports reports;
  JumperStats stats;

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

  @override
  String nameAndSurname({bool capitalizeSurname = false, bool reverse = false}) {
    var appropriateSurname = surname;
    if (capitalizeSurname) {
      appropriateSurname = appropriateSurname.toUpperCase();
    }
    return reverse ? '$appropriateSurname $name ' : '$name $appropriateSurname';
  }

  Json toJson({required JsonCountrySaver countrySaver}) {
    return {
      'dateOfBirth': dateOfBirth.toString(),
      'name': name,
      'surname': surname,
      'country': countrySaver.save(country),
      'sex': sex.name,
      'takeoffQuality': takeoffQuality,
      'flightQuality': flightQuality,
      'landingQuality': landingQuality,
      'trainingConfig': trainingConfig?.toJson(),
      'form': form,
      'jumpsConsistency': jumpsConsistency,
      'morale': morale,
      'fatigue': fatigue,
      'levelOfConsciousness': levelOfConsciousness.logarithmicValue,
      'reports': reports.toJson(),
      'stats': stats.toJson(),
    };
  }

  static SimulationJumper fromJson(
    Json json, {
    required JsonCountryLoader countryLoader,
  }) {
    final trainingConfigJson = json['trainingConfig'];
    return SimulationJumper(
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      name: json['name'],
      surname: json['surname'],
      country: countryLoader.load(json['country']),
      sex: Sex.values.singleWhere((value) => value.name == json['sex']),
      takeoffQuality: json['takeoffQuality'],
      flightQuality: json['flightQuality'],
      landingQuality: json['landingQuality'],
      trainingConfig: trainingConfigJson != null
          ? JumperTrainingConfig.fromJson(trainingConfigJson)
          : null,
      form: json['form'],
      jumpsConsistency: json['jumpsConsistency'],
      morale: json['morale'],
      fatigue: json['fatigue'],
      levelOfConsciousness: LevelOfConsciousness(json['levelOfConsciousness']),
      stats: JumperStats.fromJson(json['stats']),
      reports: JumperReports.fromJson(json['reports']),
    );
  }

  SimulationJumper copyWith({
    DateTime? dateOfBirth,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    double? takeoffQuality,
    double? flightQuality,
    double? landingQuality,
    JumperTrainingConfig? trainingConfig,
    double? form,
    double? jumpsConsistency,
    double? morale,
    double? fatigue,
    LevelOfConsciousness? levelOfConsciousness,
    JumperReports? reports,
    JumperStats? stats,
  }) {
    return SimulationJumper(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      country: country ?? this.country,
      sex: sex ?? this.sex,
      takeoffQuality: takeoffQuality ?? this.takeoffQuality,
      flightQuality: flightQuality ?? this.flightQuality,
      landingQuality: landingQuality ?? this.landingQuality,
      trainingConfig: trainingConfig ?? this.trainingConfig,
      form: form ?? this.form,
      jumpsConsistency: jumpsConsistency ?? this.jumpsConsistency,
      morale: morale ?? this.morale,
      fatigue: fatigue ?? this.fatigue,
      levelOfConsciousness: levelOfConsciousness ?? this.levelOfConsciousness,
      reports: reports ?? this.reports,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
        dateOfBirth,
        name,
        surname,
        country,
        sex,
        takeoffQuality,
        flightQuality,
        landingQuality,
        trainingConfig,
        form,
        jumpsConsistency,
        morale,
        fatigue,
        levelOfConsciousness,
      ];
}

class SimulationMaleJumper extends SimulationJumper {
  SimulationMaleJumper({
    required super.dateOfBirth,
    required super.name,
    required super.surname,
    required super.country,
    required super.takeoffQuality,
    required super.flightQuality,
    required super.landingQuality,
    required super.trainingConfig,
    required super.form,
    required super.jumpsConsistency,
    required super.morale,
    required super.fatigue,
    required super.levelOfConsciousness,
    required super.reports,
    required super.stats,
  }) : super(
          sex: Sex.male,
        );

  factory SimulationMaleJumper.fromJson(Json json,
      {required JsonCountryLoader countryLoader}) {
    return SimulationJumper.fromJson(json, countryLoader: countryLoader)
        as SimulationMaleJumper;
  }

  @override
  SimulationFemaleJumper copyWith({
    DateTime? dateOfBirth,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    double? takeoffQuality,
    double? flightQuality,
    double? landingQuality,
    JumperTrainingConfig? trainingConfig,
    double? form,
    double? jumpsConsistency,
    double? morale,
    double? fatigue,
    LevelOfConsciousness? levelOfConsciousness,
    JumperReports? reports,
    JumperStats? stats,
  }) {
    return super.copyWith(
      dateOfBirth: dateOfBirth,
      name: name,
      surname: surname,
      country: country,
      sex: Sex.female,
      takeoffQuality: takeoffQuality,
      flightQuality: flightQuality,
      landingQuality: landingQuality,
      trainingConfig: trainingConfig,
      form: form,
      jumpsConsistency: jumpsConsistency,
      morale: morale,
      fatigue: fatigue,
      levelOfConsciousness: levelOfConsciousness,
      reports: reports ?? this.reports,
      stats: stats ?? this.stats,
    ) as SimulationFemaleJumper;
  }
}

class SimulationFemaleJumper extends SimulationJumper {
  SimulationFemaleJumper({
    required super.dateOfBirth,
    required super.name,
    required super.surname,
    required super.country,
    required super.takeoffQuality,
    required super.flightQuality,
    required super.landingQuality,
    required super.trainingConfig,
    required super.form,
    required super.jumpsConsistency,
    required super.morale,
    required super.fatigue,
    required super.levelOfConsciousness,
    required super.reports,
    required super.stats,
  }) : super(
          sex: Sex.female,
        );

  factory SimulationFemaleJumper.fromJson(Json json,
      {required JsonCountryLoader countryLoader}) {
    return SimulationJumper.fromJson(json, countryLoader: countryLoader)
        as SimulationFemaleJumper;
  }

  @override
  SimulationFemaleJumper copyWith({
    DateTime? dateOfBirth,
    String? name,
    String? surname,
    Country? country,
    Sex? sex,
    double? takeoffQuality,
    double? flightQuality,
    double? landingQuality,
    JumperTrainingConfig? trainingConfig,
    double? form,
    double? jumpsConsistency,
    double? morale,
    double? fatigue,
    LevelOfConsciousness? levelOfConsciousness,
    JumperReports? reports,
    JumperStats? stats,
  }) {
    return super.copyWith(
      dateOfBirth: dateOfBirth,
      name: name,
      surname: surname,
      country: country,
      sex: Sex.female,
      takeoffQuality: takeoffQuality,
      flightQuality: flightQuality,
      landingQuality: landingQuality,
      trainingConfig: trainingConfig,
      form: form,
      jumpsConsistency: jumpsConsistency,
      morale: morale,
      fatigue: fatigue,
      levelOfConsciousness: levelOfConsciousness,
      reports: reports ?? this.reports,
      stats: stats ?? this.stats,
    ) as SimulationFemaleJumper;
  }
}
