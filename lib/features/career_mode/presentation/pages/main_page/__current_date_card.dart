part of 'simulation_route.dart';

class _CurrentDateCard extends StatelessWidget {
  const _CurrentDateCard();

  @override
  Widget build(BuildContext context) {
    final simulationState = context.watch<SimulationCubit>().state as SimulationDefault;
    final textStyle = Theme.of(context).textTheme.bodyMedium!;

    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Column(
          children: [
            const Spacer(),
            Text(
              DateFormat('EEE, d MMMM').format(simulationState.currentDate),
              style: textStyle.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              DateFormat('yyyy').format(simulationState.currentDate),
              style: textStyle,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
