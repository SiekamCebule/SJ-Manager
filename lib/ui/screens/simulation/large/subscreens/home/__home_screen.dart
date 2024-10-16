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
              Gap(10),
              Expanded(
                flex: 100,
                child: _TeamOverviewCard(),
              ),
              Gap(10),
            ],
          ),
        ),
        Gap(10),
        Expanded(
          child: Column(
            children: [
              Expanded(
                flex: 100,
                child: Placeholder(),
              ),
              Gap(10),
              Expanded(
                flex: 100,
                child: Placeholder(),
              ),
              Gap(10),
            ],
          ),
        ),
      ],
    );
  }
}
