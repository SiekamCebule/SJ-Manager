import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/utils/icons.dart';

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
            TabBar(
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
            )
          ],
        ),
      ),
    );
  }
}
