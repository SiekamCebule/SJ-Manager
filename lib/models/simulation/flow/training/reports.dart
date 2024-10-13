import 'package:sj_manager/models/simulation/database/helper/jumper_level_description.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

class JumperLevelReport {
  const JumperLevelReport({
    required this.levelDescription,
    required this.characteristics,
  });

  final JumperLevelDescription levelDescription;
  final Map<JumperLevelCharacteristicCategory, SimpleRating> characteristics;
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
}

enum JumperTrainingProgressCategory {
  takeoff,
  flight,
  landing,
  jumpsConsistency,
  form,
}
