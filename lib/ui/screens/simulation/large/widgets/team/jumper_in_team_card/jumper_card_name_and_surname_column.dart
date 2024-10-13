import 'package:flutter/material.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/ui/screens/simulation/utils/ratings_displaying.dart';

class JumperCardNameAndSurnameColumn extends StatelessWidget {
  const JumperCardNameAndSurnameColumn({
    super.key,
    required this.jumper,
    required this.jumperRatings,
  });

  final Jumper jumper;
  final JumperSimulationRatings jumperRatings;

  @override
  Widget build(BuildContext context) {
    final jumperLevelDescriptionText = getJumperLevelDescription(
      context: context,
      levelDescription: jumperRatings.levelReport.levelDescription,
    );

    return Column(
      children: [
        const Spacer(),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                jumper.nameAndSurname(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Gap(8),
              LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  height: 15,
                  child: CountryFlag(
                    country: jumper.country,
                    height: 15,
                  ),
                );
              }),
            ],
          ),
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
    );
  }
}
