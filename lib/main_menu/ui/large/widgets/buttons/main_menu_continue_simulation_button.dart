part of '../../../main_screen.dart';

SjmSimulation? computeLastPlayedSave({
  required List<SjmSimulation> simulations,
}) {
  if (simulations.isEmpty) return null;
  return simulations.reduce((first, second) {
    return first.saveTime.isAfter(second.saveTime) ? first : second;
  });
}

class MainMenuContinueSimulationButton extends StatefulWidget {
  const MainMenuContinueSimulationButton({super.key});

  @override
  State<MainMenuContinueSimulationButton> createState() =>
      _MainMenuContinueSimulationButtonState();
}

class _MainMenuContinueSimulationButtonState
    extends State<MainMenuContinueSimulationButton> {
  @override
  Widget build(BuildContext context) {
    var simulationsState = context.watch<AvailableSimulationsCubit>().state;
    if (simulationsState is AvailableSimulationsInitial) {
      return const SizedBox();
    }
    simulationsState = simulationsState as AvailableSimulationsInitialized;

    final greyedOutTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    final SjmSimulation? lastPlayed =
        computeLastPlayedSave(simulations: simulationsState.simulations);

    final enabled = lastPlayed != null;
    final emptyBody = MainMenuCard(
      borderRadius: const BorderRadius.all(UiMainMenuConstants.buttonsBorderRadius),
      onTap: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: UiMainMenuConstants.horizontalSpaceBetweenButtonItems,
              top: UiMainMenuConstants.verticalSpaceBetweenButtonItems,
            ),
            child: Text(
              translate(context).continueConfirm,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const Spacer(),
          const Center(
            child: Text('Zacznij pierwszą symulację naciskając przycisk obok'),
          ),
          const Spacer(),
        ],
      ),
    );
    return enabled
        ? MainMenuCard(
            borderRadius: const BorderRadius.all(UiMainMenuConstants.buttonsBorderRadius),
            onTap: () async {
              await context.read<SimulationCubit>().choose(lastPlayed);
              if (!context.mounted) return;
              router.navigateTo(context, '/simulation/${lastPlayed.id}');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UiMainMenuConstants.horizontalSpaceBetweenButtonItems,
                vertical: UiMainMenuConstants.verticalSpaceBetweenButtonItems,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        translate(context).continueConfirm,
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        lastSaveDateTimeFormat.format(lastPlayed.saveTime),
                        style: greyedOutTextStyle,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _constructFirstInfoWidget(lastPlayed: lastPlayed),
                      Column(
                        children: [
                          Icon(
                            Symbols.calendar_month,
                            size:
                                UiMainMenuConstants.continueButtonSimulationInfoIconSize,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const Gap(
                            UiMainMenuConstants.continueButtonSimulationInfoVerticalGap,
                          ),
                          Text(
                            DateFormat("MMMM ''yy").format(lastPlayed.currentDate),
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      lastPlayed.name,
                      style: greyedOutTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          )
        : emptyBody;
  }

  Widget _constructFirstInfoWidget({required SjmSimulation lastPlayed}) {
    late Widget iconWidget;
    late Widget labelWidget;
    final labelTextStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w400,
        );
    switch (lastPlayed.mode) {
      case SimulationMode.classicCoach:
        iconWidget = ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: const Icon(
            Symbols.fitness_center,
            size: 30,
          ),
        );
        labelWidget = Text(
          '${lastPlayed.subteamCountryName!.translate(context)} ${lastPlayed.subteamType!.name.toUpperCase()}',
          style: labelTextStyle,
        );
      case SimulationMode.personalCoach:
        final traineesCount = lastPlayed.traineesCount!;
        iconWidget = const Icon(Symbols.group,
            size: UiMainMenuConstants.continueButtonSimulationInfoIconSize);
        final text = traineesCount != 0
            ? '$traineesCount ${translate(context).trainees(traineesCount).toLowerCase()}'
            : translate(context).trainees(traineesCount);
        labelWidget = Text(
          text,
          style: labelTextStyle,
        );
      case SimulationMode.observer:
        iconWidget = const Icon(Symbols.eye_tracking,
            size: UiMainMenuConstants.continueButtonSimulationInfoIconSize);
        labelWidget = Text(
          'Obserwator',
          style: labelTextStyle,
        );
    }
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: UiMainMenuConstants.continueButtonSimulationInfoIconSize,
          child: iconWidget,
        ),
        const Gap(
          UiMainMenuConstants.continueButtonSimulationInfoVerticalGap,
        ),
        labelWidget,
      ],
    );
  }
}
