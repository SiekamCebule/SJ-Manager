import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/l10n/training_progress_translations.dart';
import 'package:sj_manager/domain/entities/simulation/flow/simple_rating.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/reports/jumper_reports.dart';

class TrainingProgressReportDisplay extends StatelessWidget {
  const TrainingProgressReportDisplay({
    super.key,
    required this.report,
  });

  final TrainingReport? report;

  @override
  Widget build(BuildContext context) {
    final progressCategoryLabelStyle = Theme.of(context).textTheme.bodyMedium!;
    final baseProgressLabelStyle = Theme.of(context).textTheme.titleSmall!;
    TextStyle progressLabelStyle(SimpleRating rating) {
      return baseProgressLabelStyle.copyWith(color: darkThemeSimpleRatingColors[rating]);
    }

    final bool reportUnavailable = report == null;

    SimpleRating getProgress(TrainingProgressCategory category) {
      return report!.ratings[category]!;
    }

    Widget buildNonEmptyStateBody() {
      return Column(
        children: [
          const Gap(20),
          Text(
            'Raport z treningu',
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
                  getProgress(TrainingProgressCategory.takeoff),
                  context: context,
                ),
                style: progressLabelStyle(getProgress(TrainingProgressCategory.takeoff)),
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
                  getProgress(TrainingProgressCategory.flight),
                  context: context,
                ),
                style: progressLabelStyle(getProgress(TrainingProgressCategory.flight)),
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
                  getProgress(TrainingProgressCategory.landing),
                  context: context,
                ),
                style: progressLabelStyle(getProgress(TrainingProgressCategory.landing)),
              ),
            ],
          ),
          const Gap(5),
          Row(
            children: [
              Text(
                '- Równość: ',
                style: progressCategoryLabelStyle,
              ),
              Text(
                translateTrainingProgress(
                  getProgress(TrainingProgressCategory.consistency),
                  context: context,
                ),
                style:
                    progressLabelStyle(getProgress(TrainingProgressCategory.consistency)),
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
                  getProgress(TrainingProgressCategory.form),
                  context: context,
                ),
                style: progressLabelStyle(getProgress(TrainingProgressCategory.form)),
              ),
            ],
          ),
        ],
      );
    }

    const emptyStateBody = Center(
      child: Text(
        'Pojawi się za jakiś czas',
        textAlign: TextAlign.center,
      ),
    );

    return reportUnavailable ? emptyStateBody : buildNonEmptyStateBody();
  }
}
