import 'dart:math';

import 'package:flutter/material.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/to_embrace/ui/assets/icons.dart';

Widget arrowIcon(BuildContext context, Degrees rotation) {
  final radians = (rotation.remainder.value.toDouble()) * (pi / 180);
  return Transform.rotate(
    angle: radians,
    child: Image(
      image: downArrowIcon,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}
