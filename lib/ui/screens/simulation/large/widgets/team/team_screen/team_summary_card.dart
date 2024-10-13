import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

class TeamSummaryCard extends StatelessWidget {
  const TeamSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Make it dynamic
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Card(
                elevation: 2,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: Row(
                  children: [
                    Text(
                      'Ogólnie bardzo dobre morale',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: darkThemeSimpleRatingColors[SimpleRating.veryGood]),
                    ),
                    const Gap(15),
                    const Icon(Symbols.emoji_emotions),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Card(
                elevation: 2,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: Row(
                  children: [
                    Text(
                      'Ogólnie przeciętne wyniki',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: darkThemeSimpleRatingColors[SimpleRating.correct]),
                    ),
                    const Gap(15),
                    const Icon(Symbols.analytics),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Card(
                elevation: 2,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: Row(
                  children: [
                    Text(
                      'Ogólnie efektywny trening',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: darkThemeSimpleRatingColors[SimpleRating.good]),
                    ),
                    const Gap(15),
                    const Icon(Symbols.fitness_center),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
