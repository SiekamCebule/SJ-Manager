import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_category.dart';

double sjmCalculateAvgTrainingBalance(Map<JumperTrainingCategory, double> balance) {
  final avgBalance = (balance[JumperTrainingCategory.takeoff]! * 27.5 +
          (balance[JumperTrainingCategory.flight]! * 27.5) +
          (balance[JumperTrainingCategory.form]! * 40) +
          (balance[JumperTrainingCategory.landing]! * 5)) /
      100;
  return avgBalance;
}
