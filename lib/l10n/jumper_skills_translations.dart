import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/data/models/database/jumper/jumping_technique.dart';
import 'package:sj_manager/data/models/database/jumper/landing_style.dart';

String translatedLandingStyleDescription(
    BuildContext context, LandingStyle landingStyle) {
  return switch (landingStyle) {
    LandingStyle.veryUgly => translate(context).veryUgly,
    LandingStyle.ugly => translate(context).ugly,
    LandingStyle.slightlyUgly => translate(context).slightlyUgly,
    LandingStyle.average => translate(context).averageForLandingStyle,
    LandingStyle.quiteGraceful => translate(context).quiteGraceful,
    LandingStyle.graceful => translate(context).graceful,
    LandingStyle.veryGraceful => translate(context).veryGraceful,
  };
}

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
