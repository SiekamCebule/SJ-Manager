import 'package:flutter/material.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/general_ui/reusable_widgets/link_text_button.dart';

class TeamScreenNoJumpersInfoWidget extends StatelessWidget {
  const TeamScreenNoJumpersInfoWidget({
    super.key,
    required this.mode,
    required this.searchForCandidates,
  });

  final SimulationMode mode;
  final VoidCallback searchForCandidates;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final normalBodyStyle = Theme.of(context).textTheme.bodyMedium;

    if (mode == SimulationMode.observer) {
      throw ArgumentError('TeamScreen doesn\'t appear in the observer mode');
    }

    final titleText = switch (mode) {
      SimulationMode.classicCoach =>
        'Jeszcze nie powołano skoczków' 'Jeszcze nie powołano skoczków',
      SimulationMode.personalCoach => 'Jeszcze z nikim nie współpracujesz',
      _ => throw ArgumentError(),
    };

    final descriptionWidget = switch (mode) {
      SimulationMode.classicCoach => Text(
          'Za niedługo zostaniesz poproszony o powołanie skoczków do kadry. W przyszłości wyświetli się tu lista twoich podopiecznych',
          style: normalBodyStyle,
        ),
      SimulationMode.personalCoach => Column(
          children: [
            Text(
              'W każdej chwili możesz zacząć trenować jakiegoś przystojnego skoczka, lub ładną skoczkinię narciarską.\nNiestety w grze nie ma jeszcze skaczących kangurów.',
              style: normalBodyStyle,
              textAlign: TextAlign.center,
            ),
            const Gap(2),
            LinkTextButton(
              onPressed: searchForCandidates,
              labelText: 'Wyszukaj kandydatów',
              excludeIcon: true,
            ),
          ],
        ),
      _ => throw ArgumentError(),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          titleText,
          style: titleStyle,
        ),
        const Gap(10),
        descriptionWidget,
      ],
    );
  }
}
