import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/jumper/jumper_simple_list_tile.dart';
import 'package:sj_manager/l10n/jumper_ratings_translations.dart';

class CountryTeamProfileSubteamsNonEmpty extends StatelessWidget {
  const CountryTeamProfileSubteamsNonEmpty({
    super.key,
    required this.subteams,
  });

  final Iterable<Subteam> subteams;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (final subteam in subteams)
          Column(
            children: [
              Text(
                translateJumperSubteamType(context: context, subteamType: subteam.type),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(10),
              Expanded(
                child: SizedBox(
                  width: 350,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: subteam.jumpers.length,
                    itemBuilder: (context, index) => JumperSimpleListTile(
                      jumper: subteam.jumpers.elementAt(index),
                      subtitle: JumperSimpleListTileSubtitle.none,
                    ),
                    separatorBuilder: (context, index) => const Gap(10),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
