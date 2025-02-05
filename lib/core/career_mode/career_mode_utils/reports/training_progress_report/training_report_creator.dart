import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/core/career_mode/simple_rating.dart';

class TrainingReportCreator {
  TrainingReportCreator({
    required this.deltas,
    required this.requirements,
  });

  final Map<TrainingProgressCategory, List<double>> deltas;
  final Map<TrainingProgressCategory, Map<SimpleRating, double>> requirements;

  TrainingReport? create() {
    final categories = deltas.keys;
    if (deltas.isEmpty) return null;
    final deltasSum = deltas.map((category, deltas) {
      return MapEntry(
        category,
        deltas.reduce((sum, value) => sum + value),
      );
    });
    SimpleRating getRating(TrainingProgressCategory category) {
      // final sortedRatings = requirements[category]!.keys.toList()
      //   ..sort((a, b) => b.impactValue.compareTo(a.impactValue));
      // return sortedRatings.firstWhereOrNull((rating) {
      //       final requirement = requirements[category]![rating]!;
      //       if (deltasSum[category]! >= requirement) {
      //         return true;
      //       }
      //       return false;
      //     }) ??
      //     requirements[category]!.keys.last;

      final entries = requirements[category]!.entries.toList();

      final bestMatch = entries.reduce((closest, current) {
        final currentDiff = (deltasSum[category]! - current.value).abs();
        final closestDiff = (deltasSum[category]! - closest.value).abs();
        return currentDiff < closestDiff ? current : closest;
      });

      return bestMatch.key;
    }

    final ratings = {
      for (final category in categories) category: getRating(category),
    };

    final averageRatingImpact =
        (ratings[TrainingProgressCategory.takeoff]!.impactValue * 35 +
                ratings[TrainingProgressCategory.flight]!.impactValue * 35 +
                ratings[TrainingProgressCategory.landing]!.impactValue * 5 +
                ratings[TrainingProgressCategory.consistency]!.impactValue * 10 +
                ratings[TrainingProgressCategory.form]!.impactValue * 15) /
            100 *
            2.5;
    final generalRating =
        SimpleRating.fromImpactValue(averageRatingImpact.round().clamp(-3, 3));

    return TrainingReport(
      generalRating: generalRating,
      ratings: ratings,
    );
  }
}
