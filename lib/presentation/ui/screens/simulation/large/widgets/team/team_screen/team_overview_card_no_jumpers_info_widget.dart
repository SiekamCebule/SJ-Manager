import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/domain/use_cases/ui/simulation/simulation_screen_navigation_cubit.dart';
import 'package:sj_manager/domain/entities/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/link_text_button.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/simulation_route.dart';

class TeamOverviewCardNoJumpersInfoWidget extends StatelessWidget {
  const TeamOverviewCardNoJumpersInfoWidget({
    super.key,
    required this.mode,
  });

  final SimulationMode mode;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final normalBodyStyle = Theme.of(context).textTheme.bodyMedium;

    if (mode == SimulationMode.observer) {
      throw ArgumentError('TeamOverviewCard doesn\'t appear in the observer mode');
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
              'Zacznij trenować pierwszych zawodników wyszukując ich na odpowiednim ekranie',
              style: normalBodyStyle,
              textAlign: TextAlign.center,
            ),
            const Gap(2),
            LinkTextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  '/simulation/team',
                  arguments: TeamScreenMode.overview,
                );
                context
                    .read<SimulationScreenNavigationCubit>()
                    .change(screen: SimulationScreenNavigationTarget.team);
              },
              labelText: 'Przejdź',
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
