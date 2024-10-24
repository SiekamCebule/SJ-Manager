import 'package:equatable/equatable.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/flow/training/training_risk.dart';

class JumperTrainingConfig with EquatableMixin {
  const JumperTrainingConfig({
    required this.points,
  });

  final Map<JumperTrainingPointsCategory, int> points;

  JumperTrainingConfig copyWith({
    TrainingRisk? trainingRisk,
    Map<JumperTrainingPointsCategory, int>? points,
  }) {
    return JumperTrainingConfig(
      points: points ?? this.points,
    );
  }

  Json toJson() {
    return {
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
    return JumperTrainingConfig(
      points: points,
    );
  }

  @override
  List<Object?> get props => [
        points,
      ];
}

enum JumperTrainingPointsCategory {
  takeoff,
  flight,
  landing,
  jumpsConsistency,
  form,
}

const initialJumperTrainingPoints = {
  JumperTrainingPointsCategory.takeoff: 1,
  JumperTrainingPointsCategory.flight: 1,
  JumperTrainingPointsCategory.landing: 1,
  JumperTrainingPointsCategory.jumpsConsistency: 1,
  JumperTrainingPointsCategory.form: 1,
};
