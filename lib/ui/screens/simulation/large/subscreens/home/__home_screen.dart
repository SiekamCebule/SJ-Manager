part of '../../../simulation_route.dart';

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                flex: 45,
                child: _NextCompetitionCard(),
              ),
              Expanded(
                flex: 100,
                child: _TeamOverviewCard(),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                flex: 100,
                child: Placeholder(),
              ),
              Expanded(
                flex: 100,
                child: Placeholder(),
              ),
              Expanded(
                flex: 100,
                child: Placeholder(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
