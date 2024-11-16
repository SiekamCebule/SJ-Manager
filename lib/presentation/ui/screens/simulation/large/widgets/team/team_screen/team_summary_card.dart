import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/data/models/simulation/flow/reports/team_reports.dart';
import 'package:sj_manager/data/models/simulation/flow/simple_rating.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/utils/jumper_ratings_translations.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/utils/team_ratings_translations.dart';

class TeamSummaryCard extends StatelessWidget {
  const TeamSummaryCard({
    super.key,
    this.excludeTitle = false,
    required this.reports,
  });

  final bool excludeTitle;
  final TeamReports reports;

  @override
  Widget build(BuildContext context) {
    final moraleDescription = getTeamMoraleDescription(
      context: context,
      rating: reports.generalMoraleRating,
    );
    final jumpsDescription = getTeamJumpsDescription(
      context: context,
      rating: reports.generalJumpsRating,
    );
    final trainingDescription = getTeamTrainingDescription(
      context: context,
      rating: reports.generalTrainingRating,
    );
    final baseTextStyle = Theme.of(context).textTheme.titleSmall!;

    return SizedBox(
      height: excludeTitle ? 120 : 150,
      child: Card(
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!excludeTitle) ...[
                const Gap(3),
                Text(
                  'Podsumowanie',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  Text(
                    moraleDescription,
                    style: baseTextStyle.copyWith(
                      color: darkThemeSimpleRatingColors[reports.generalMoraleRating],
                    ),
                  ),
                  const Gap(15),
                  Icon(
                    getThumbIconBySimpleRating(rating: reports.generalMoraleRating),
                    color: darkThemeSimpleRatingColors[reports.generalMoraleRating],
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    jumpsDescription,
                    style: baseTextStyle.copyWith(
                      color: darkThemeSimpleRatingColors[reports.generalJumpsRating],
                    ),
                  ),
                  const Gap(15),
                  Icon(
                    getThumbIconBySimpleRating(rating: reports.generalJumpsRating),
                    color: darkThemeSimpleRatingColors[reports.generalJumpsRating],
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    trainingDescription,
                    style: baseTextStyle.copyWith(
                      color: darkThemeSimpleRatingColors[reports.generalTrainingRating],
                    ),
                  ),
                  const Gap(15),
                  Icon(
                    getThumbIconBySimpleRating(rating: reports.generalTrainingRating),
                    color: darkThemeSimpleRatingColors[reports.generalTrainingRating],
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
