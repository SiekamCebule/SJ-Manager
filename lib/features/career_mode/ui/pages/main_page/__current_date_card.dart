part of 'simulation_route.dart';

class _CurrentDateCard extends StatelessWidget {
  const _CurrentDateCard();

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabase>();
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
              DateFormat('EEE, d MMMM').format(database.currentDate),
              style: textStyle.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              DateFormat('yyyy').format(database.currentDate),
              style: textStyle,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
