import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Stars extends StatelessWidget {
  const Stars({
    super.key,
    required this.stars,
    this.color,
    this.fill,
    this.size,
  });

  final int stars;
  final Color? color;
  final double? fill;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(stars, (_) {
          return Icon(
            Symbols.star,
            color: color ?? Theme.of(context).colorScheme.secondary,
            fill: fill ?? 1.0,
            size: size,
          );
        }),
      ],
    );
  }
}
