import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/item_image_not_found_placeholder.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/item_image_help_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/utils/ratings_displaying.dart';

class JumperInTeamCard extends StatelessWidget {
  const JumperInTeamCard({
    super.key,
    required this.jumper,
  });

  final Jumper jumper;

  @override
  Widget build(BuildContext context) {
    final ratings =
        context.read<SimulationDatabaseHelper>().jumpersDynamicParameters[jumper]!;
    final jumperLevelDescriptionText = getJumperLevelDescription(
      context: context,
      levelDescription: ratings.levelDescription,
    );
    final moraleRating = ratings.moraleRating;
    final resultsRating = ratings.resultsRating;
    final trainingRating = ratings.trainingRating;
    final moraleDescription = getMoraleDescription(
      context: context,
      rating: moraleRating,
    );
    final resultsDescription = getResultsDescription(
      context: context,
      rating: resultsRating,
    );
    final trainingDescription = getTrainingDescription(
      context: context,
      rating: trainingRating,
    );

    return SizedBox(
      height: 140,
      child: Card(
        elevation: 2,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: DbItemImage<Jumper>(
                item: jumper,
                setup: context.read(),
                errorBuilder: (_, __, ___) => ItemImageNotFoundPlaceholder(
                  width: UiItemEditorsConstants.jumperImagePlaceholderWidth,
                  height: UiItemEditorsConstants.jumperImageHeight,
                  helpDialog: ItemImageHelpDialog(
                    content: translate(context).jumperImageHelpContent,
                  ),
                ),
              ),
            ),
            const Gap(30),
            Expanded(
              flex: 300,
              child: Row(
                children: [
                  Column(
                    children: [
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            jumper.nameAndSurname(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Gap(8),
                          CountryFlag(
                            country: jumper.country,
                            height: 15,
                          ),
                        ],
                      ),
                      const Gap(10),
                      Text(
                        jumperLevelDescriptionText,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Gap(30),
                  Column(
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
                            '- $resultsDescription',
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                          const Gap(5),
                          Icon(
                            getThumbIconBySimpleRating(rating: resultsRating),
                            color: darkThemeSimpleRatingColors[resultsRating],
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
