part of '../../pages/simulation_wizard_dialog.dart';

class _CountryTeamsGrid extends StatelessWidget {
  const _CountryTeamsGrid({
    required this.teams,
    this.selected,
    required this.onTap,
  });

  final List<CountryTeam> teams;
  final CountryTeam? selected;
  final void Function(CountryTeam) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 130,
        childAspectRatio: 0.9,
      ),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return _CountryTile(
          key: ValueKey(team.country.code),
          isSelected: selected?.country == team.country,
          country: team.country,
          onTap: () {
            onTap(team);
          },
        );
      },
    );
  }
}
