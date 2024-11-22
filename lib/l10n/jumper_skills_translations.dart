import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumping_technique.dart';

String translatedJumpingStyleDescription(BuildContext context, JumpingTechnique style) {
  final translator = translate(context);
  return switch (style) {
    JumpingTechnique.veryDefensive => translator.jumpingStyleVeryDefensive,
    JumpingTechnique.clearlyDefensive => translator.jumpingStyleClearlyDefensive,
    JumpingTechnique.defensive => translator.jumpingStyleDefensive,
    JumpingTechnique.cautious => translator.jumpingStyleCautious,
    JumpingTechnique.slightlyCautious => translator.jumpingStyleSlightlyCautious,
    JumpingTechnique.balanced => translator.jumpingStyleBalanced,
    JumpingTechnique.fairlyUnpredictable => translator.jumpingStyleFairlyUnpredictable,
    JumpingTechnique.unpredictable => translator.jumpingStyleUnpredictable,
    JumpingTechnique.risky => translator.jumpingStyleRisky,
    JumpingTechnique.clearlyRisky => translator.jumpingStyleClearlyRisky,
    JumpingTechnique.veryRisky => translator.jumpingStyleVeryRisky,
  };
}
