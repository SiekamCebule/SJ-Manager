import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';

class CountryTeamOverviewListTile extends StatelessWidget {
  const CountryTeamOverviewListTile({
    super.key,
    required this.team,
    this.onTap,
    this.selected = false,
    this.showProfile,
  });

  final CountryTeam team;
  final VoidCallback? onTap;
  final bool selected;
  final VoidCallback? showProfile;

  @override
  Widget build(BuildContext context) {
    final sexIconData = switch (team.sex) {
      Sex.male => Symbols.male,
      Sex.female => Symbols.female,
    };
    final countryName = team.country.multilingualName.translate(context);
    final titleText = countryName;

    return ListTile(
      leading: CountryFlag(
        country: team.country,
        width: 30,
      ),
      title: Text(titleText),
      trailing: Icon(sexIconData),
      onTap: onTap,
      selected: selected,
    );
  }
}
