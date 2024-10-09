part of '../simulation_route.dart';

class _CurrentDateCard extends StatelessWidget {
  const _CurrentDateCard();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!;
    return Container(
      //margin: const EdgeInsets.only(top: 0, bottom: 0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Column(
        children: [
          const Spacer(),
          Text(
            '17 Aug',
            style: textStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            '2024',
            style: textStyle,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
