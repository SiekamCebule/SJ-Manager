part of '../../pages/simulation_wizard_dialog.dart';

class _TeamPreview extends StatelessWidget {
  const _TeamPreview({
    required this.team,
  });

  final Team team;

  @override
  Widget build(BuildContext context) {
    final previewCreator = context.read<TeamPreviewCreator>();

    final record = previewCreator.record(team);

    final none = translate(context).none;

    final stars = previewCreator.stars(team) ?? -1;
    final bestJumperText = previewCreator.bestJumper(team)?.nameAndSurname() ?? none;
    final recordText = record != null
        ? '${record.distance.toStringAsFixed(1)}m (${record.jumperNameAndSurname})'
        : 'Brak';
    final risingStarText = previewCreator.risingStar(team)?.nameAndSurname() ?? 'Brak';
    final largestHillText = previewCreator.largestHill(team)?.toString() ?? 'Brak';

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20), topLeft: Radius.circular(20))),
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          const Gap(15),
          if (team is CountryTeam) CountryTitle(country: (team as CountryTeam).country),
          const Gap(15),
          PreviewStatTexts(
            description: 'Poziom: ',
            content: Stars(stars: stars),
          ),
          const Gap(5),
          PreviewStatTexts(
            description: 'Najlepszy zawodnik: ',
            contentText: bestJumperText,
          ),
          const Gap(5),
          PreviewStatTexts(
            description: 'Rekord: ',
            contentText: recordText,
          ),
          const Gap(5),
          PreviewStatTexts(
            description: 'Wschodząca gwiazda: ',
            contentText: risingStarText,
          ),
          const Gap(5),
          PreviewStatTexts(
            description: 'Największa skocznia: ',
            contentText: largestHillText,
          ),
        ],
      ),
    );
  }
}
