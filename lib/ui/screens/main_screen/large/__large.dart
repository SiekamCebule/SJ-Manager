part of '../main_screen.dart';

class _Large extends StatelessWidget {
  const _Large();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          _BackgroundImage(),
          Center(
            child: Column(
              children: [
                Spacer(
                  flex: 1,
                ),
                ShakingAppTitle(),
                Spacer(
                  flex: 1,
                ),
                _ButtonsTable(),
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
