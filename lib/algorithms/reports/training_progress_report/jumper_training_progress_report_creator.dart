import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

class JumperTrainingProgressReportCreator {
  JumperTrainingProgressReportCreator({
    required this.deltas,
    required this.requirements,
  });

  final Map<JumperTrainingProgressCategory, List<double>> deltas;
  final Map<JumperTrainingProgressCategory, Map<SimpleRating, double>> requirements;

  TrainingReport create() {
    final categories = deltas.keys;
    final avgDelta = deltas.map((category, deltas) {
      return MapEntry(
          category, deltas.reduce((sum, value) => sum + value) / deltas.length);
    });
    SimpleRating getRating(JumperTrainingProgressCategory category) {
      return requirements[category]!.keys.firstWhere((rating) {
        final requirement = requirements[category]![rating]!;
        if (avgDelta[category]! >= requirement) {
          return true;
        }
        return false;
      });
    }

    final ratings = {
      for (final category in categories) category: getRating(category),
    };

    final averageRatingImpact =
        (ratings[JumperTrainingProgressCategory.takeoff]!.impactValue * 25 +
                ratings[JumperTrainingProgressCategory.flight]!.impactValue * 25 +
                ratings[JumperTrainingProgressCategory.landing]!.impactValue * 5 +
                ratings[JumperTrainingProgressCategory.consistency]!.impactValue * 10 +
                ratings[JumperTrainingProgressCategory.form]!.impactValue * 35) /
            100;
    final generalRating = SimpleRating.fromImpactValue(averageRatingImpact.round());

    return TrainingReport(
      generalRating: generalRating,
      ratings: ratings,
    );
  }
}
