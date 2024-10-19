part of '../../../main_screen.dart';

class MainMenuNewSimulationButton extends StatelessWidget {
  const MainMenuNewSimulationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuCard(
      borderRadius: const BorderRadius.all(UiMainMenuConstants.buttonsBorderRadius),
      onTap: () async {
        await ShowSimulationWizardCommand(
            context: context,
            onFinish: (options) async {
              if (options != null) {
                await CreateNewSimulationCommand(
                        context: context, simulationOptions: options)
                    .execute();
              }
            }).execute();
      },
      child: MainMenuTextContentButtonBody(
        titleText: translate(context).newSimulation,
        contentText: translate(context).newSimulationButtonContent,
      ),
    );
  }
}
