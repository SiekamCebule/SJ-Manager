part of 'search_for_charges_jumpers_dialog.dart';

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.jumper,
    required this.levelReport,
    required this.selected,
    required this.onTap,
  });

  final Jumper jumper;
  final JumperLevelReport? levelReport;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: selected,
      leading: SimulationJumperImage(
        jumper: jumper,
        aspectRatio: 3 / 2,
      ),
      trailing: CountryFlag(
        country: jumper.country,
        width: 40,
      ),
      title: Text(
        jumper.nameAndSurname(),
      ),
      subtitle: Text(
        getJumperLevelDescription(
          context: context,
          levelDescription: levelReport?.levelDescription,
        ),
      ),
    );
  }
}
