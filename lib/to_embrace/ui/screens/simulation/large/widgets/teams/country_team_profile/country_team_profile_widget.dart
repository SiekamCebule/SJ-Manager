import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/general_ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/teams/country_team_profile/overview/country_team_profile_overview.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/teams/country_team_profile/subteams/country_team_profile_subteams.dart';
import 'package:sj_manager/core/general_utils/icons.dart';

class CountryTeamProfileWidget extends StatefulWidget {
  const CountryTeamProfileWidget({
    super.key,
    required this.team,
  });

  final CountryTeam team;

  @override
  State<CountryTeamProfileWidget> createState() => _CountryTeamProfileWidgetState();
}

class _CountryTeamProfileWidgetState extends State<CountryTeamProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.surfaceContainerHigh;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            CountryFlag(
              country: widget.team.country,
              height: 20,
            ),
            const Gap(13),
            Text(widget.team.country.multilingualName.translate(context)),
            const Gap(8),
            Icon(sexIconData(widget.team.sex)),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  text: 'Przegląd',
                  icon: Icon(Symbols.overview),
                ),
                Tab(
                  text: 'Kadry',
                  icon: Icon(Symbols.groups),
                ),
                Tab(
                  text: 'Statystyki',
                  icon: Icon(Symbols.analytics),
                ),
              ],
            ),
            const Gap(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: TabBarView(
                  children: [
                    CountryTeamProfileOverview(
                      countryTeam: widget.team,
                    ),
                    CountryTeamProfileSubteams(
                      countryTeam: widget.team,
                    ),
                    const Placeholder(),
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
