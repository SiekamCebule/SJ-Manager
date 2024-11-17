part of '../../../main_screen.dart';

SimulationModel? computeLastPlayedSave({
  required List<SimulationModel> simulations,
}) {
  if (simulations.isEmpty) return null;
  return simulations.reduce((first, second) {
    return first.saveTime.isAfter(second.saveTime) ? first : second;
  });
}

class MainMenuContinueButton extends StatefulWidget {
  const MainMenuContinueButton({super.key});

  @override
  State<MainMenuContinueButton> createState() => _MainMenuContinueButtonState();
}

class _MainMenuContinueButtonState extends State<MainMenuContinueButton> {
  @override
  Widget build(BuildContext context) {
    final simulationsRepo = context.watch<EditableItemsRepo<SimulationModel>>();
    final greyedOutTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    return StreamBuilder(
      stream: simulationsRepo.items,
      builder: (context, snapshot) {
        final SimulationModel? lastPlayed =
            computeLastPlayedSave(simulations: simulationsRepo.last);
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
                borderRadius:
                    const BorderRadius.all(UiMainMenuConstants.buttonsBorderRadius),
                onTap: () {
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
                                size: UiMainMenuConstants
                                    .continueButtonSimulationInfoIconSize,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const Gap(
                                UiMainMenuConstants
                                    .continueButtonSimulationInfoVerticalGap,
                              ),
                              Text(
                                DateFormat("MMMM ''yy")
                                    .format(lastPlayed.database!.currentDate),
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
      },
    );
  }

  Widget _constructFirstInfoWidget({required SimulationModel lastPlayed}) {
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
          child: Image.file(
            File(lastPlayed.subteamCountryFlagName!),
            height: 30,
            fit: BoxFit.fitHeight,
            errorBuilder: (context, error, stackTrace) => const Placeholder(),
          ),
        );
        labelWidget = Text(
          'Kadra B',
          style: labelTextStyle,
        );
      case SimulationMode.personalCoach:
        final chargesCount =
            lastPlayed.database!.managerData.personalCoachTeam!.jumpers.length;
        iconWidget = const Icon(Symbols.group,
            size: UiMainMenuConstants.continueButtonSimulationInfoIconSize);
        final text = chargesCount != 0
            ? '$chargesCount ${translate(context).charges(chargesCount).toLowerCase()}'
            : translate(context).charges(chargesCount);
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
