import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/core/career_mode/simple_rating.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/general_ui/reusable_widgets/link_text_button.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/simulation_jumper_image.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/team/jumper_in_team_card/jumper_card_name_and_surname_column.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/utils/jumper_ratings_translations.dart';

class JumperInTeamOverviewCard extends StatelessWidget {
  const JumperInTeamOverviewCard({
    super.key,
    required this.jumper,
    required this.subteamType,
    required this.reports,
    this.hideLinks = false,
    this.goToProfile,
    this.showStats,
  });

  final SimulationJumper jumper;
  final SubteamType? subteamType;
  final JumperReports reports;
  final bool hideLinks;
  final VoidCallback? goToProfile;
  final VoidCallback? showStats;

  @override
  Widget build(BuildContext context) {
    final moraleRating = reports.moraleRating;
    final jumpsRating = reports.jumpsRating;
    final trainingRating = reports.weeklyTrainingReport?.generalRating;

    final moraleDescription = getJumperMoraleDescription(
      context: context,
      rating: moraleRating,
    );
    final jumpsDescription = getJumperJumpsDescription(
      context: context,
      rating: jumpsRating,
    );
    final trainingDescription = getJumperTrainingDescription(
      context: context,
      rating: trainingRating,
    );

    final nameAndSurnameColumn = JumperCardNameAndSurnameColumn(
      jumper: jumper,
      jumperRatings: reports,
      subteamType: subteamType,
    );

    final linksColumn = Column(
      children: [
        const Spacer(),
        LinkTextButton(
          onPressed: goToProfile,
          labelText: 'Przejdź do profilu',
        ),
        LinkTextButton(
          onPressed: showStats,
          labelText: 'Zobacz statystyki',
        ),
        const Spacer(),
      ],
    );

    final ratingsColumn = SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Row(
            children: [
              Text(
                '- $moraleDescription',
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
              const Gap(5),
              Icon(
                getThumbIconBySimpleRating(rating: moraleRating),
                color: darkThemeSimpleRatingColors[moraleRating],
              ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              Text(
                '- $jumpsDescription',
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
              const Gap(5),
              Icon(
                getThumbIconBySimpleRating(rating: jumpsRating),
                color: darkThemeSimpleRatingColors[jumpsRating],
              ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              Text(
                '- $trainingDescription',
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
              const Gap(5),
              Icon(
                getThumbIconBySimpleRating(rating: trainingRating),
                color: darkThemeSimpleRatingColors[trainingRating],
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );

    final imageWidget = SimulationJumperImage(
      jumper: jumper,
      height: 140,
    );

    return SizedBox(
      height: 140,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Row(
          children: [
            const Gap(15),
            SizedBox(
              width: 90,
              child: imageWidget,
            ),
            const Gap(15),
            Expanded(
              child: Row(
                children: [
                  nameAndSurnameColumn,
                  const Gap(30),
                  ratingsColumn,
                  if (!hideLinks) ...[
                    const Gap(30),
                    linksColumn,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
