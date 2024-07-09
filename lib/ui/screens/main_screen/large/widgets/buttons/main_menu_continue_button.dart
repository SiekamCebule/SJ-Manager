part of '../../../main_screen.dart';

class MainMenuContinueButton extends StatelessWidget {
  const MainMenuContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Button(
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
                  style: GoogleFonts.dosis(
                    color: Theme.of(context).colorScheme.primary,
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const Spacer(),
                Text(
                  '28-06-2024 19:05',
                  style: GoogleFonts.dosis(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
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
                    SvgPicture.network(
                      'https://upload.wikimedia.org/wikipedia/commons/9/9a/Flag_of_Bulgaria.svg',
                      height: UiMainMenuConstants.continueButtonSimulationInfoIconSize,
                      fit: BoxFit.fitHeight,
                    ),
                    const Gap(
                      UiMainMenuConstants.continueButtonSimulationInfoVerticalGap,
                    ),
                    Text(
                      'Bułgaria',
                      style: GoogleFonts.dosis(
                        color: Theme.of(context).colorScheme.onSurface,
                        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
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
                      style: GoogleFonts.dosis(
                        color: Theme.of(context).colorScheme.onSurface,
                        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
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
                      style: GoogleFonts.dosis(
                        color: Theme.of(context).colorScheme.onSurface,
                        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
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
