import 'package:flutter/material.dart';
import 'package:sj_manager/data/models/game_variants/default_game_variants/test_variant.dart';
import 'package:sj_manager/data/models/game_variants/game_variant.dart';

Future<List<GameVariant>> constructDefaultGameVariants({
  required BuildContext context,
}) async {
  final testVariant = await constructTestGameVariant(context: context);
  return [
    testVariant,
  ];
}
