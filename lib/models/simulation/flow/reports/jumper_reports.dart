import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_level_description.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

class JumperLevelReport {
  const JumperLevelReport({
    required this.levelDescription,
    required this.characteristics,
  });

  final JumperLevelDescription levelDescription;
  final Map<JumperLevelCharacteristicCategory, SimpleRating> characteristics;

  static JumperLevelReport fromJson(Json json) {
    final characteristics = json['characteristics'] as Json;

    return JumperLevelReport(
      levelDescription: JumperLevelDescription.values
          .singleWhere((value) => value.name == json['levelDescription']),
      characteristics: characteristics.map(
        (categoryJson, ratingJson) {
          final category = JumperLevelCharacteristicCategory.values
              .singleWhere((value) => value.name == categoryJson);
          final rating = SimpleRating.fromJson(ratingJson);
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
}

enum JumperLevelCharacteristicCategory {
  takeoff,
  flight,
  landing,
  jumpsConsistency,
}

class JumperTrainingProgressReport {
  const JumperTrainingProgressReport({
    required this.generalRating,
    required this.ratings,
  });

  final SimpleRating generalRating;
  final Map<JumperTrainingProgressCategory, SimpleRating> ratings;

  static JumperTrainingProgressReport fromJson(Json json) {
    final ratings = json['ratings'] as Json;

    return JumperTrainingProgressReport(
      generalRating: SimpleRating.fromJson(json['generalRating']),
      ratings: ratings.map(
        (categoryJson, ratingJson) {
          final category = JumperTrainingProgressCategory.values
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
}

enum JumperTrainingProgressCategory {
  takeoff,
  flight,
  landing,
  jumpsConsistency,
  form,
}

class JumperReports {
  const JumperReports({
    required this.levelReport,
    required this.trainingProgressReport,
    required this.moraleRating,
    required this.jumpsRating,
  });

  final JumperLevelReport? levelReport;
  final JumperTrainingProgressReport? trainingProgressReport;
  final SimpleRating? moraleRating;
  final SimpleRating? jumpsRating;

  JumperReports copyWith({
    JumperLevelReport? levelReport,
    JumperTrainingProgressReport? trainingProgressReport,
    SimpleRating? moraleRating,
    SimpleRating? jumpsRating,
  }) {
    return JumperReports(
      levelReport: levelReport ?? this.levelReport,
      trainingProgressReport: trainingProgressReport ?? this.trainingProgressReport,
      moraleRating: moraleRating ?? this.moraleRating,
      jumpsRating: jumpsRating ?? this.jumpsRating,
    );
  }

  static JumperReports fromJson(Json json) {
    final levelReport = json['levelReport'] != null
        ? JumperLevelReport.fromJson(json['levelReport'])
        : null;
    final trainingProgressReport = json['trainingProgressReport'] != null
        ? JumperTrainingProgressReport.fromJson(json['trainingProgressReport'])
        : null;
    final moraleRating =
        json['moraleRating'] != null ? SimpleRating.fromJson(json['moraleRating']) : null;
    final jumpsRating =
        json['jumpsRating'] != null ? SimpleRating.fromJson(json['jumpsRating']) : null;

    return JumperReports(
      levelReport: levelReport,
      trainingProgressReport: trainingProgressReport,
      moraleRating: moraleRating,
      jumpsRating: jumpsRating,
    );
  }

  Json toJson() {
    return {
      'levelReport': levelReport?.toJson(),
      'trainingProgressReport': trainingProgressReport?.toJson(),
      'moraleRating': moraleRating?.name,
      'jumpsRating': jumpsRating?.name,
    };
  }
}
