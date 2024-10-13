import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/l10n/training_progress_translations.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';
import 'package:sj_manager/models/simulation/flow/training/reports.dart';

class TrainingProgressReportDisplay extends StatelessWidget {
  const TrainingProgressReportDisplay({
    super.key,
    required this.report,
  });

  final JumperTrainingProgressReport report;

  @override
  Widget build(BuildContext context) {
    final progressCategoryLabelStyle = Theme.of(context).textTheme.bodyMedium!;
    final baseProgressLabelStyle = Theme.of(context).textTheme.titleSmall!;
    TextStyle progressLabelStyle(SimpleRating rating) {
      return baseProgressLabelStyle.copyWith(color: darkThemeSimpleRatingColors[rating]);
    }

    SimpleRating getProgress(JumperTrainingProgressCategory category) {
      return report.ratings[category]!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(20),
        Text(
          'Ostatni raport z treningu',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(10),
        Row(
          children: [
            Text(
              '- Wybicie: ',
              style: progressCategoryLabelStyle,
            ),
            Text(
              translateTrainingProgress(
                getProgress(JumperTrainingProgressCategory.takeoff),
                context: context,
              ),
              style:
                  progressLabelStyle(getProgress(JumperTrainingProgressCategory.takeoff)),
            ),
          ],
        ),
        const Gap(5),
        Row(
          children: [
            Text(
              '- Lot: ',
              style: progressCategoryLabelStyle,
            ),
            Text(
              translateTrainingProgress(
                getProgress(JumperTrainingProgressCategory.flight),
                context: context,
              ),
              style:
                  progressLabelStyle(getProgress(JumperTrainingProgressCategory.flight)),
            ),
          ],
        ),
        const Gap(5),
        Row(
          children: [
            Text(
              '- Lądowanie: ',
              style: progressCategoryLabelStyle,
            ),
            Text(
              translateTrainingProgress(
                getProgress(JumperTrainingProgressCategory.landing),
                context: context,
              ),
              style:
                  progressLabelStyle(getProgress(JumperTrainingProgressCategory.landing)),
            ),
          ],
        ),
        const Gap(5),
        Row(
          children: [
            Text(
              '- Równość skoków: ',
              style: progressCategoryLabelStyle,
            ),
            Text(
              translateTrainingProgress(
                getProgress(JumperTrainingProgressCategory.jumpsConsistency),
                context: context,
              ),
              style: progressLabelStyle(
                  getProgress(JumperTrainingProgressCategory.jumpsConsistency)),
            ),
          ],
        ),
        const Gap(5),
        Row(
          children: [
            Text(
              '- Forma: ',
              style: progressCategoryLabelStyle,
            ),
            Text(
              translateTrainingProgress(
                getProgress(JumperTrainingProgressCategory.form),
                context: context,
              ),
              style: progressLabelStyle(getProgress(JumperTrainingProgressCategory.form)),
            ),
          ],
        ),
      ],
    );
  }
}
