import 'package:flutter/material.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/l10n/helpers.dart';

String translatedLandingStyleDescription(
    BuildContext context, LandingStyle landingStyle) {
  return switch (landingStyle) {
    LandingStyle.terrible => translate(context).terrible,
    LandingStyle.veryUgly => translate(context).veryUgly,
    LandingStyle.ugly => translate(context).ugly,
    LandingStyle.average => translate(context).average,
    LandingStyle.graceful => translate(context).graceful,
    LandingStyle.veryGraceful => translate(context).veryGraceful,
    LandingStyle.perfect => translate(context).perfect,
  };
}

String translatedJumpsConsistencyDescription(
    BuildContext context, JumpsConsistency consistency) {
  return switch (consistency) {
    JumpsConsistency.veryInconsistent => translate(context).veryInconsistent,
    JumpsConsistency.inconsistent => translate(context).inconsistent,
    JumpsConsistency.average => translate(context).average,
    JumpsConsistency.consistent => translate(context).consistent,
    JumpsConsistency.veryConsistent => translate(context).veryConsistent,
  };
}
