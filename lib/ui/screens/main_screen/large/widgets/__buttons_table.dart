part of '../../main_screen.dart';

class _ButtonsTable extends StatelessWidget {
  const _ButtonsTable();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: UiMainMenuConstants.buttonsTableWidth,
      height: UiMainMenuConstants.buttonsTableHeight,
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MainMenuContinueButton(),
                ),
                Gap(UiMainMenuConstants.spaceBetweenButtons),
                Expanded(
                  child: MainMenuNewSimulationButton(),
                ),
              ],
            ),
          ),
          Gap(UiMainMenuConstants.spaceBetweenButtons),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MainMenuLoadSimulationButton(),
                ),
                Gap(UiMainMenuConstants.spaceBetweenButtons),
                Expanded(
                  child: MainMenuSettingsButton(),
                ),
              ],
            ),
          ),
          Gap(UiMainMenuConstants.spaceBetweenButtons),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MainMenuDatabaseEditorButton(),
                ),
                Gap(UiMainMenuConstants.spaceBetweenButtons),
                Expanded(
                  child: MainMenuAcknowledgementsButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
