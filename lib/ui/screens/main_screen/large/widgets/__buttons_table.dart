part of '../../main_screen.dart';

class _ButtonsTable extends StatelessWidget {
  const _ButtonsTable();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 900,
      height: 450,
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
                Gap(UiConstants.spaceBetweenButtonsInMainMenu),
                Expanded(
                  child: MainMenuNewSimulationButton(),
                ),
              ],
            ),
          ),
          Gap(UiConstants.spaceBetweenButtonsInMainMenu),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MainMenuLoadSimulationButton(),
                ),
                Gap(UiConstants.spaceBetweenButtonsInMainMenu),
                Expanded(
                  child: MainMenuSettingsButton(),
                ),
              ],
            ),
          ),
          Gap(UiConstants.spaceBetweenButtonsInMainMenu),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MainMenuDatabaseEditorButton(),
                ),
                Gap(UiConstants.spaceBetweenButtonsInMainMenu),
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
