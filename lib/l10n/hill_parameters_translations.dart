import 'package:flutter/material.dart';
import 'package:sj_manager/enums/hill_type_by_size.dart';
import 'package:sj_manager/enums/typical_wind_direction.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/enums/hill_profile_type.dart';
import 'package:sj_manager/enums/jumps_variability.dart';
import 'package:sj_manager/enums/landing_ease.dart';

String translatedLandingEaseDescription(BuildContext context, LandingEase ease) {
  return switch (ease) {
    LandingEase.veryHigh => translate(context).veryEasyForLanding,
    LandingEase.high => translate(context).easyForLanding,
    LandingEase.fairlyHigh => translate(context).fairlyEasyForLanding,
    LandingEase.average => translate(context).averageForLanding,
    LandingEase.fairlyLow => translate(context).fairlyHardForLanding,
    LandingEase.low => translate(context).hardForLanding,
    LandingEase.veryLow => translate(context).veryHardForLanding,
  };
}

String translatedHillProfileDescription(
    BuildContext context, HillProfileType profileType) {
  return switch (profileType) {
    HillProfileType.highlyFavorsInFlight =>
      translate(context).highlyFavorsInFlightForProfile,
    HillProfileType.favorsInFlight => translate(context).favorsInFlightForProfile,
    HillProfileType.balanced => translate(context).averageForProfile,
    HillProfileType.favorsInTakeoff => translate(context).favorsInTakeoffForProfile,
    HillProfileType.highlyFavorsInTakeoff =>
      translate(context).highlyFavorsInTakeoffForProfile,
  };
}

String translatedJumpsVariabilityDescription(
    BuildContext context, JumpsVariability variability) {
  return switch (variability) {
    JumpsVariability.highlyVariable => translate(context).highlyVariable,
    JumpsVariability.variable => translate(context).variable,
    JumpsVariability.average => translate(context).averageForVariability,
    JumpsVariability.stable => translate(context).stable,
    JumpsVariability.highlyStable => translate(context).highlyStable,
  };
}

String translatedTypicalWindDirectionBriefDescription(
    BuildContext context, TypicalWindDirection direction) {
  return switch (direction) {
    TypicalWindDirection.headwind => translate(context).headwindBrief,
    TypicalWindDirection.leftHeadwind => translate(context).leftHeadwindBrief,
    TypicalWindDirection.rightHeadwind => translate(context).rightHeadwindBrief,
    TypicalWindDirection.leftWind => translate(context).leftWindBrief,
    TypicalWindDirection.rightWind => translate(context).rightWindBrief,
    TypicalWindDirection.leftTailwind => translate(context).leftTailwindBrief,
    TypicalWindDirection.rightTailwind => translate(context).rightTailwindBrief,
    TypicalWindDirection.tailwind => translate(context).tailwindBrief,
  };
}

String translatedHillTypeBySizeBriefDescription(
    BuildContext context, HillTypeBySize type) {
  return switch (type) {
    HillTypeBySize.skiFlying => translate(context).skiFlyingHillBrief,
    HillTypeBySize.big => translate(context).bigHillBrief,
    HillTypeBySize.large => translate(context).largeHillBrief,
    HillTypeBySize.normal => translate(context).normalHillBrief,
    HillTypeBySize.medium => translate(context).mediumHillBrief,
    HillTypeBySize.small => translate(context).smallHillBrief,
  };
}
