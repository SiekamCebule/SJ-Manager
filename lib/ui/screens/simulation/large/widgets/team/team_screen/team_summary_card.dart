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
    final baseTextStyle = Theme.of(context).textTheme.titleLarge!;
    return SizedBox(
      height: 150,
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
              const Spacer(),
              Row(
                children: [
                  Text(
                    'Ogólnie bardzo dobre morale',
                    style: baseTextStyle.copyWith(
                        color: darkThemeSimpleRatingColors[SimpleRating.veryGood]),
                  ),
                  const Gap(15),
                  const Icon(Symbols.emoji_emotions),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    'Ogólnie przeciętne wyniki',
                    style: baseTextStyle.copyWith(
                        color: darkThemeSimpleRatingColors[SimpleRating.correct]),
                  ),
                  const Gap(15),
                  const Icon(Symbols.analytics),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    'Ogólnie efektywny trening',
                    style: baseTextStyle.copyWith(
                        color: darkThemeSimpleRatingColors[SimpleRating.good]),
                  ),
                  const Gap(15),
                  const Icon(Symbols.fitness_center),
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
