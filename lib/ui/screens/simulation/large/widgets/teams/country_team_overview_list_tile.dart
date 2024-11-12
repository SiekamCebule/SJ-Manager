import 'package:flutter/material.dart';
import 'package:sj_manager/models/database/team/country_team/country_team.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/utils/icons.dart';

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
    final countryName = team.country.multilingualName.translate(context);
    final titleText = countryName;

    return ListTile(
      leading: CountryFlag(
        country: team.country,
        width: 30,
      ),
      title: Text(titleText),
      trailing: Icon(sexIconData(team.sex)),
      onTap: onTap,
      selected: selected,
    );
  }
}
