part of '../../../main_screen.dart';

class MainMenuNewSimulationButton extends StatelessWidget {
  const MainMenuNewSimulationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Button(
      child: Padding(
        padding: const EdgeInsets.only(
          left: UiMainMenuConstants.horizontalSpaceBetweenButtonItems,
          top: UiMainMenuConstants.verticalSpaceBetweenButtonItems,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate(context).newSimulation,
              style: GoogleFonts.dosis(
                color: Theme.of(context).colorScheme.primary,
                textStyle: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const Gap(UiMainMenuConstants.verticalSpaceBetweenButtonItems),
            Row(
              children: [
                const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
                Flexible(
                  child: Text(
                    translate(context).newSimulationButtonContent,
                    style: GoogleFonts.dosis(
                      color: Theme.of(context).colorScheme.onSurface,
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
              ],
            ),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
