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
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const Gap(UiMainMenuConstants.verticalSpaceBetweenButtonItems),
            Row(
              children: [
                const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
                Flexible(
                  child: Text(
                    translate(context).newSimulationButtonContent,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
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
