import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/user_db/jumper/jumps_consistency.dart';
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

String translatedJumpsConsistencyDescription(
    BuildContext context, JumpsConsistency consistency) {
  return switch (consistency) {
    JumpsConsistency.veryInconsistent => translate(context).veryInconsistent,
    JumpsConsistency.inconsistent => translate(context).inconsistent,
    JumpsConsistency.slightlyInconsistent => translate(context).slightlyInconsistent,
    JumpsConsistency.average => translate(context).averageForConsistency,
    JumpsConsistency.quiteConsistent => translate(context).quiteConsistent,
    JumpsConsistency.consistent => translate(context).consistent,
    JumpsConsistency.veryConsistent => translate(context).veryConsistent,
  };
}
