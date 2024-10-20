import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/user_db/jumper/jumping_style.dart';
import 'package:sj_manager/models/user_db/jumper/landing_style.dart';

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

String translatedJumpingStyleDescription(BuildContext context, JumpingStyle style) {
  final translator = translate(context);
  return switch (style) {
    JumpingStyle.veryDefensive => translator.jumpingStyleVeryDefensive,
    JumpingStyle.clearlyDefensive => translator.jumpingStyleClearlyDefensive,
    JumpingStyle.defensive => translator.jumpingStyleDefensive,
    JumpingStyle.cautious => translator.jumpingStyleCautious,
    JumpingStyle.slightlyCautious => translator.jumpingStyleSlightlyCautious,
    JumpingStyle.balanced => translator.jumpingStyleBalanced,
    JumpingStyle.fairlyUnpredictable => translator.jumpingStyleFairlyUnpredictable,
    JumpingStyle.unpredictable => translator.jumpingStyleUnpredictable,
    JumpingStyle.risky => translator.jumpingStyleRisky,
    JumpingStyle.clearlyRisky => translator.jumpingStyleClearlyRisky,
    JumpingStyle.veryRisky => translator.jumpingStyleVeryRisky,
  };
}
