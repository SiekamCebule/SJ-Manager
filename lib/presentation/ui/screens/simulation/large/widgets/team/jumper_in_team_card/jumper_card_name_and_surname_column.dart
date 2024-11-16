import 'package:flutter/material.dart';
import 'package:sj_manager/data/models/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/data/models/database/team/country_team/subteam_type.dart';
import 'package:sj_manager/data/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/countries/country_flag.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/utils/jumper_ratings_translations.dart';

class JumperCardNameAndSurnameColumn extends StatelessWidget {
  const JumperCardNameAndSurnameColumn({
    super.key,
    required this.jumper,
    required this.jumperRatings,
    required this.subteamType,
  });

  final SimulationJumper jumper;
  final JumperReports jumperRatings;
  final SubteamType? subteamType;

  @override
  Widget build(BuildContext context) {
    final levelDescription = jumperRatings.levelReport?.levelDescription;
    final jumperLevelDescriptionText = translateJumperLevelDescription(
      context: context,
      levelDescription: levelDescription,
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
        if (subteamType != null) ...[
          const Gap(10),
          Text(
            translateJumperSubteamType(
              context: context,
              subteamType: subteamType!,
            ),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontStyle: FontStyle.italic),
          ),
        ],
        const Spacer(),
      ],
    );
  }
}
