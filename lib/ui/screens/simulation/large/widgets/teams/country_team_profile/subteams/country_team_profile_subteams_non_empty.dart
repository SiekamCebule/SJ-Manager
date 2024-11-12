import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/models/database/team/subteam.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper/jumper_simple_list_tile.dart';
import 'package:sj_manager/ui/screens/simulation/utils/jumper_ratings_translations.dart';

class CountryTeamProfileSubteamsNonEmpty extends StatelessWidget {
  const CountryTeamProfileSubteamsNonEmpty({
    super.key,
    required this.subteams,
    required this.jumpers,
  });

  final List<Subteam> subteams;
  final Map<Subteam, List<SimulationJumper>> jumpers;

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
                    itemCount: jumpers[subteam]!.length,
                    itemBuilder: (context, index) => JumperSimpleListTile(
                      jumper: jumpers[subteam]![index],
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
