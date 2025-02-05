import 'package:equatable/equatable.dart';

import 'package:sj_manager/core/career_mode/career_mode_utils/reports/default_jumper_level_report_creator.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_level_description.dart';
import 'package:sj_manager/core/career_mode/simple_rating.dart';

class JumperLevelReport with EquatableMixin {
  JumperLevelReport({
    required this.levelDescription,
    required this.characteristics,
  });

  JumperLevelDescription levelDescription;
  Map<JumperLevelCharacteristicCategory, JumperCharacteristicOthernessStrength>
      characteristics;

  static JumperLevelReport fromJson(Json json) {
    final characteristics = json['characteristics'] as Json;

    return JumperLevelReport(
      levelDescription: JumperLevelDescription.values
          .singleWhere((value) => value.name == json['levelDescription']),
      characteristics: characteristics.map(
        (categoryJson, ratingJson) {
          final category = JumperLevelCharacteristicCategory.values
              .singleWhere((value) => value.name == categoryJson);
          final rating = JumperCharacteristicOthernessStrength.fromJson(ratingJson);
          return MapEntry(category, rating);
        },
      ),
    );
  }

  Json toJson() {
    return {
      'levelDescription': levelDescription.name,
      'characteristics': characteristics.map(
        (category, rating) => MapEntry(category.name, rating.name),
      ),
    };
  }

  @override
  List<Object?> get props => [
        levelDescription,
        characteristics,
      ];
}

enum JumperLevelCharacteristicCategory {
  takeoff,
  flight,
  landing,
  riskInJumps,
}

class TrainingReport with EquatableMixin {
  TrainingReport({
    required this.generalRating,
    required this.ratings,
  });

  SimpleRating generalRating;
  Map<TrainingProgressCategory, SimpleRating> ratings;

  static TrainingReport fromJson(Json json) {
    final ratings = json['ratings'] as Json;

    return TrainingReport(
      generalRating: SimpleRating.fromJson(json['generalRating']),
      ratings: ratings.map(
        (categoryJson, ratingJson) {
          final category = TrainingProgressCategory.values
              .singleWhere((value) => value.name == categoryJson);
          final rating = SimpleRating.fromJson(ratingJson);
          return MapEntry(category, rating);
        },
      ),
    );
  }

  Json toJson() {
    return {
      'generalRating': generalRating.name,
      'ratings': ratings.map(
        (category, rating) => MapEntry(category.name, rating.name),
      ),
    };
  }

  @override
  List<Object?> get props => [
        generalRating,
        ratings,
      ];
}

enum TrainingProgressCategory {
  takeoff,
  flight,
  landing,
  consistency,
  form,
}

class JumperReports with EquatableMixin {
  JumperReports({
    required this.levelReport,
    required this.weeklyTrainingReport,
    required this.monthlyTrainingReport,
    required this.moraleRating,
    required this.jumpsRating,
  });

  JumperLevelReport? levelReport;
  TrainingReport? weeklyTrainingReport;
  TrainingReport? monthlyTrainingReport;
  SimpleRating? moraleRating;
  SimpleRating? jumpsRating;

  static JumperReports fromJson(Json json) {
    final levelReport = json['levelReport'] != null
        ? JumperLevelReport.fromJson(json['levelReport'])
        : null;
    final weeklyTrainingReport = json['weeklyTrainingReport'] != null
        ? TrainingReport.fromJson(json['weeklyTrainingReport'])
        : null;
    final monthlyTrainingReport = json['monthlyTrainingReport'] != null
        ? TrainingReport.fromJson(json['monthlyTrainingReport'])
        : null;
    final moraleRating =
        json['moraleRating'] != null ? SimpleRating.fromJson(json['moraleRating']) : null;
    final jumpsRating =
        json['jumpsRating'] != null ? SimpleRating.fromJson(json['jumpsRating']) : null;

    return JumperReports(
      levelReport: levelReport,
      weeklyTrainingReport: weeklyTrainingReport,
      monthlyTrainingReport: monthlyTrainingReport,
      moraleRating: moraleRating,
      jumpsRating: jumpsRating,
    );
  }

  Json toJson() {
    return {
      'levelReport': levelReport?.toJson(),
      'weeklyTrainingReport': weeklyTrainingReport?.toJson(),
      'monthlyTrainingReport': monthlyTrainingReport?.toJson(),
      'moraleRating': moraleRating?.name,
      'jumpsRating': jumpsRating?.name,
    };
  }

  @override
  List<Object?> get props => [
        levelReport,
        weeklyTrainingReport,
        monthlyTrainingReport,
        moraleRating,
        jumpsRating,
      ];

  JumperReports copyWith({
    JumperLevelReport? levelReport,
    TrainingReport? weeklyTrainingReport,
    TrainingReport? monthlyTrainingReport,
    SimpleRating? moraleRating,
    SimpleRating? jumpsRating,
  }) {
    return JumperReports(
      levelReport: levelReport ?? this.levelReport,
      weeklyTrainingReport: weeklyTrainingReport ?? this.weeklyTrainingReport,
      monthlyTrainingReport: monthlyTrainingReport ?? this.monthlyTrainingReport,
      moraleRating: moraleRating ?? this.moraleRating,
      jumpsRating: jumpsRating ?? this.jumpsRating,
    );
  }
}
