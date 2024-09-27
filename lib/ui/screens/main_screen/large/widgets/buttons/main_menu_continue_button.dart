part of '../../../main_screen.dart';

UserSimulation computeLastPlayedSave({
  required List<UserSimulation> simulations,
}) {
  return simulations.reduce((first, second) {
    return first.saveTime.isBefore(second.saveTime) ? first : second;
  });
}

class MainMenuContinueButton extends StatelessWidget {
  const MainMenuContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    final simulationsRepo = context.watch<EditableItemsRepo<UserSimulation>>();
    return StreamBuilder(
        stream: simulationsRepo.items,
        builder: (context, snapshot) {
          final enabled = simulationsRepo.last.isNotEmpty;
          final UserSimulation? lastPlayed =
              enabled ? computeLastPlayedSave(simulations: simulationsRepo.last) : null;
          return MainMenuCard(
            borderRadius: const BorderRadius.all(UiMainMenuConstants.buttonsBorderRadius),
            onTap: enabled ? () {} : null,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: UiMainMenuConstants.horizontalSpaceBetweenButtonItems,
                  top: UiMainMenuConstants.verticalSpaceBetweenButtonItems),
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            width: 50,
                            height:
                                UiMainMenuConstants.continueButtonSimulationInfoIconSize,
                            child: Placeholder(),
                          ),
                          const Gap(
                            UiMainMenuConstants.continueButtonSimulationInfoVerticalGap,
                          ),
                          Text(
                            'Bułgaria',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
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
                            'Kwiecień \'26',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Symbols.person,
                            size:
                                UiMainMenuConstants.continueButtonSimulationInfoIconSize,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const Gap(
                            UiMainMenuConstants.continueButtonSimulationInfoVerticalGap,
                          ),
                          Text(
                            '5',
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
                ],
              ),
            ),
          );
        });
  }
}
