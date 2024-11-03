import 'package:equatable/equatable.dart';

import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/psyche/level_of_consciousness.dart';

class JumperDynamicParams with EquatableMixin {
  const JumperDynamicParams({
    required this.trainingConfig,
    required this.form,
    required this.trainingFeeling,
    required this.jumpsConsistency,
    required this.morale,
    required this.fatigue,
    required this.levelOfConsciousness,
  });

  final JumperTrainingConfig? trainingConfig;

  /// From 1 to 20
  final double form;

  /// from 0 to 1
  final Map<JumperTrainingCategory, double>? trainingFeeling;

  /// From 1 to 20
  final double jumpsConsistency;

  /// From -1 to 1
  final double morale;

  /// From -1 to 1
  final double fatigue;

  /// From David Hawkins' Map of Consciousness
  final LevelOfConsciousness levelOfConsciousness;

  JumperDynamicParams.empty()
      : this(
          trainingConfig: null,
          form: 0,
          trainingFeeling: const {},
          jumpsConsistency: 0,
          morale: 0,
          fatigue: 0,
          levelOfConsciousness: LevelOfConsciousness.fromMapOfConsciousness(
            LevelOfConsciousnessLabels.courage,
          ),
        );

  Json toJson() {
    return {
      'trainingConfig': trainingConfig?.toJson(),
      'form': form,
      'trainingFeeling': trainingFeeling?.map((category, factor) {
        return MapEntry(category.name, factor);
      }),
      'jumpsConsistency': jumpsConsistency,
      'morale': morale,
      'fatigue': fatigue,
      'levelOfConsciousness': levelOfConsciousness.logarithmicValue,
    };
  }

  static JumperDynamicParams fromJson(Json json) {
    final trainingConfigJson = json['trainingConfig'];
    final trainingFeelingJson = json['trainingFeeling'] as Json?;
    final trainingFeeling = trainingFeelingJson?.map(
      (key, value) {
        return MapEntry(
          JumperTrainingCategory.values.singleWhere((value) => value.name == key),
          value as double,
        );
      },
    );

    return JumperDynamicParams(
      trainingConfig: trainingConfigJson != null
          ? JumperTrainingConfig.fromJson(trainingConfigJson)
          : null,
      form: json['form'],
      trainingFeeling: trainingFeeling,
      jumpsConsistency: json['jumpsConsistency'],
      morale: json['morale'],
      fatigue: json['fatigue'],
      levelOfConsciousness: LevelOfConsciousness(json['levelOfConsciousness']),
    );
  }

  @override
  List<Object?> get props => [
        trainingConfig,
        form,
        trainingFeeling,
        jumpsConsistency,
        morale,
        fatigue,
        levelOfConsciousness,
      ];

  JumperDynamicParams copyWith({
    JumperTrainingConfig? trainingConfig,
    int? jumpingTechniqueChangeTrainingDaysLeft,
    double? form,
    Map<JumperTrainingCategory, double>? trainingFeeling,
    double? jumpsConsistency,
    double? morale,
    double? fatigue,
    LevelOfConsciousness? levelOfConsciousness,
  }) {
    return JumperDynamicParams(
      trainingConfig: trainingConfig ?? this.trainingConfig,
      form: form ?? this.form,
      trainingFeeling: trainingFeeling ?? this.trainingFeeling,
      jumpsConsistency: jumpsConsistency ?? this.jumpsConsistency,
      morale: morale ?? this.morale,
      fatigue: fatigue ?? this.fatigue,
      levelOfConsciousness: levelOfConsciousness ?? this.levelOfConsciousness,
    );
  }
}
