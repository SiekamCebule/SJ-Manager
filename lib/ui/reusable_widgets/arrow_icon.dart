import 'dart:math';

import 'package:flutter/material.dart';
import 'package:osje_sim/osje_sim.dart';

Widget arrowIcon(BuildContext context, Degrees rotation) {
  final radians = (rotation.remainder.value.toDouble()) * (pi / 180);
  return Transform.rotate(
    angle: radians,
    child: Image.asset(
      'assets/icons/arrow_down.png',
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}
