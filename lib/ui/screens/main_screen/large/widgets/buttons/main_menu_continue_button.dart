part of '../../../main_screen.dart';

class MainMenuContinueButton extends StatelessWidget {
  const MainMenuContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuCard(
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
                  '28-06-2024 19:05',
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
                    const CountryFlag(
                      country: Country(
                        code: 'bg',
                        name: 'Bułgaria',
                      ),
                      height: UiMainMenuConstants.continueButtonSimulationInfoIconSize,
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
                      size: UiMainMenuConstants.continueButtonSimulationInfoIconSize,
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
                      size: UiMainMenuConstants.continueButtonSimulationInfoIconSize,
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
      onTap: () {},
    );
  }
}
