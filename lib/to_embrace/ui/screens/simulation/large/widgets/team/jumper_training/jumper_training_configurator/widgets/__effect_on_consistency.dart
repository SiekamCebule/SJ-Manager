part of '../jumper_training_configurator.dart';

class _EffectOnConsistency extends StatelessWidget {
  const _EffectOnConsistency({
    required this.rating,
  });

  final SimpleRating rating;

  @override
  Widget build(BuildContext context) {
    final effectText = translateTrainingEffectOnConsistency(
      context: context,
      rating: rating,
    );
    final iconData = switch (rating.impactScore) {
      1 => Symbols.thumb_up_alt_rounded,
      0 => Symbols.circle,
      -1 => Symbols.thumb_down_alt_rounded,
      _ => Symbols.abc,
    };
    final iconColor = switch (rating.impactScore) {
      1 => Theme.of(context).colorScheme.primary,
      0 => Theme.of(context).colorScheme.onSurfaceVariant,
      -1 => Theme.of(context).colorScheme.error,
      _ => Colors.transparent,
    };
    final iconsCount = rating != SimpleRating.correct ? rating.impactValue.abs() : 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Gap(5),
        const Text('Wpływ treningu na równość skoków: '),
        const Gap(5),
        Text(
          effectText,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Gap(5),
        for (var i = 0; i < iconsCount; i++)
          Icon(
            iconData,
            size: 20,
            color: iconColor,
          ),
      ],
    );
  }
}
