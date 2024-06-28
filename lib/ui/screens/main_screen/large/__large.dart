part of '../main_screen.dart';

class _Large extends StatelessWidget {
  const _Large();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          MainMenuBackgroundImage(),
          Center(
            child: Column(
              children: [
                Spacer(
                  flex: 1,
                ),
                AppTitle(),
                Spacer(
                  flex: 1,
                ),
                SizedBox(
                  width: 900,
                  height: 360,
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
                    ],
                  ),
                ),
                Spacer(
                  flex: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
