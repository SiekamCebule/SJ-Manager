import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/item_image_not_found_placeholder.dart';
import 'package:sj_manager/ui/reusable_widgets/link_text_button.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/item_image_help_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_in_team_card/jumper_card_name_and_surname_column.dart';
import 'package:sj_manager/ui/screens/simulation/utils/ratings_displaying.dart';

class JumperInTeamOverviewCard extends StatelessWidget {
  const JumperInTeamOverviewCard({
    super.key,
    required this.jumper,
    required this.reports,
    this.hideLinks = false,
    this.goToProfile,
    this.showStats,
  });

  final Jumper jumper;
  final JumperReports reports;
  final bool hideLinks;
  final VoidCallback? goToProfile;
  final VoidCallback? showStats;

  @override
  Widget build(BuildContext context) {
    final noDataColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final moraleRating = reports.moraleRating;
    final resultsRating = reports.resultsRating;
    final trainingRating = reports.trainingProgressReport?.generalRating;

    final moraleDescription = moraleRating != null
        ? getMoraleDescription(
            context: context,
            rating: moraleRating,
          )
        : 'Brak danych o morale';
    final moraleIcon = moraleRating != null
        ? getThumbIconBySimpleRating(rating: moraleRating)
        : Symbols.question_mark;
    final moraleIconColor =
        moraleRating != null ? darkThemeSimpleRatingColors[moraleRating] : noDataColor;
    final resultsDescription = resultsRating != null
        ? getResultsDescription(
            context: context,
            rating: resultsRating,
          )
        : 'Brak danych o wynikach';
    final resultsIcon = resultsRating != null
        ? getThumbIconBySimpleRating(rating: resultsRating)
        : Symbols.question_mark;
    final resultsIconColor =
        moraleRating != null ? darkThemeSimpleRatingColors[moraleRating] : noDataColor;
    final trainingDescription = trainingRating != null
        ? getTrainingDescription(
            context: context,
            rating: trainingRating,
          )
        : 'Brak danych o treningu';
    final trainingIcon = trainingRating != null
        ? getThumbIconBySimpleRating(rating: trainingRating)
        : Symbols.question_mark;
    final trainingIconColor =
        moraleRating != null ? darkThemeSimpleRatingColors[moraleRating] : noDataColor;

    final nameAndSurnameColumn = JumperCardNameAndSurnameColumn(
      jumper: jumper,
      jumperRatings: reports,
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
                moraleIcon,
                color: moraleIconColor,
              ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              Text(
                '- $resultsDescription',
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
              const Gap(5),
              Icon(
                resultsIcon,
                color: resultsIconColor,
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
                trainingIcon,
                color: trainingIconColor,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );

    final imageWidget = DbItemImage<Jumper>(
      item: jumper,
      setup: context.read(),
      errorBuilder: (_, __, ___) => ItemImageNotFoundPlaceholder(
        width: UiItemEditorsConstants.jumperImagePlaceholderWidth,
        height: UiItemEditorsConstants.jumperImageHeight,
        helpDialog: ItemImageHelpDialog(
          content: translate(context).jumperImageHelpContent,
        ),
      ),
    );

    return SizedBox(
      height: 140,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
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
