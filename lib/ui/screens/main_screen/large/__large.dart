part of '../main_screen.dart';

class _Large extends StatelessWidget {
  const _Large();

  @override
  Widget build(BuildContext context) {
    print('items repos: ${context.read<ItemsReposRegistry>()}');
    return const Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _BackgroundImage()),
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
