import 'package:equatable/equatable.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/flow/training/jumping_technique_change_training.dart';

class JumperTrainingConfig with EquatableMixin {
  const JumperTrainingConfig({
    required this.balance,
    required this.jumpingTechniqueChangeTraining,
    required this.points,
  });

  /// -1.0 do 1.0. Utrzymanie/Zmiana
  final double balance;

  /// Zmniejsz/Zwiększ ryzyko podczas skoków
  final JumpingTechniqueChangeTrainingType jumpingTechniqueChangeTraining;

  final Map<JumperTrainingPointsCategory, int> points;

  JumperTrainingConfig copyWith({
    double? balance,
    JumpingTechniqueChangeTrainingType? jumpingTechniqueChangeTraining,
    Map<JumperTrainingPointsCategory, int>? points,
  }) {
    return JumperTrainingConfig(
      balance: balance ?? this.balance,
      jumpingTechniqueChangeTraining:
          jumpingTechniqueChangeTraining ?? this.jumpingTechniqueChangeTraining,
      points: points ?? this.points,
    );
  }

  Json toJson() {
    return {
      'balance': balance,
      'jumpingTechniqueChangeTraining': jumpingTechniqueChangeTraining.name,
      'points': points.map((category, points) {
        return MapEntry(category.name, points);
      }),
    };
  }

  static JumperTrainingConfig fromJson(Json json) {
    final pointsJson = json['points'] as Json;
    final points = pointsJson.map((categoryName, points) {
      final category = JumperTrainingPointsCategory.values.singleWhere(
        (value) => value.name == categoryName,
      );
      return MapEntry(category, points as int);
    });
    final techniqueChangeTrainingJson = json['jumpingTechniqueChangeTraining'];
    return JumperTrainingConfig(
      balance: json['balance'],
      jumpingTechniqueChangeTraining: JumpingTechniqueChangeTrainingType.values
          .singleWhere((value) => value.name == techniqueChangeTrainingJson),
      points: points,
    );
  }

  @override
  List<Object?> get props => [
        balance,
        jumpingTechniqueChangeTraining,
        points,
      ];
}

enum JumperTrainingPointsCategory {
  takeoff,
  flight,
  landing,
  form,
}

const initialJumperTrainingPoints = {
  JumperTrainingPointsCategory.takeoff: 1,
  JumperTrainingPointsCategory.flight: 1,
  JumperTrainingPointsCategory.landing: 1,
  JumperTrainingPointsCategory.form: 1,
};

const initialJumperTrainingConfig = JumperTrainingConfig(
  balance: 0,
  jumpingTechniqueChangeTraining: JumpingTechniqueChangeTrainingType.maintain,
  points: initialJumperTrainingPoints,
);
