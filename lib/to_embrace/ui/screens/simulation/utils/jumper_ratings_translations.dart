import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_level_description.dart';
import 'package:sj_manager/core/career_mode/simple_rating.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/subteam_type.dart';

String getJumperMoraleDescription({
  required BuildContext context,
  required SimpleRating? rating,
}) {
  final translator = translate(context);
  return switch (rating) {
    SimpleRating.excellent => translator.jumperMoraleExcellent,
    SimpleRating.veryGood => translator.jumperMoraleVeryGood,
    SimpleRating.good => translator.jumperMoraleGood,
    SimpleRating.correct => translator.jumperMoraleCorrect,
    SimpleRating.belowExpectations => translator.jumperMoraleBelowExpectations,
    SimpleRating.poor => translator.jumperMoralePoor,
    SimpleRating.veryPoor => translator.jumperMoraleVeryPoor,
    _ => translator.jumperMoraleNoData,
  };
}

String getJumperJumpsDescription({
  required BuildContext context,
  required SimpleRating? rating,
}) {
  final translator = translate(context);
  return switch (rating) {
    SimpleRating.excellent => translator.jumperJumpsExcellent,
    SimpleRating.veryGood => translator.jumperJumpsVeryGood,
    SimpleRating.good => translator.jumperJumpsGood,
    SimpleRating.correct => translator.jumperJumpsCorrect,
    SimpleRating.belowExpectations => translator.jumperJumpsBelowExpectations,
    SimpleRating.poor => translator.jumperJumpsPoor,
    SimpleRating.veryPoor => translator.jumperJumpsVeryPoor,
    _ => translator.jumperJumpsNoData,
  };
}

String getJumperTrainingDescription({
  required BuildContext context,
  required SimpleRating? rating,
}) {
  final translator = translate(context);
  return switch (rating) {
    SimpleRating.excellent => translator.jumperTrainingExcellent,
    SimpleRating.veryGood => translator.jumperTrainingVeryGood,
    SimpleRating.good => translator.jumperTrainingGood,
    SimpleRating.correct => translator.jumperTrainingCorrect,
    SimpleRating.belowExpectations => translator.jumperTrainingBelowExpectations,
    SimpleRating.poor => translator.jumperTrainingPoor,
    SimpleRating.veryPoor => translator.jumperTrainingVeryPoor,
    _ => translator.jumperTrainingNoData,
  };
}

String translateJumperLevelDescription({
  required BuildContext context,
  required JumperLevelDescription? levelDescription,
}) {
  final translator = translate(context);
  return switch (levelDescription) {
    JumperLevelDescription.top => translator.jumperLevelTop,
    JumperLevelDescription.broadTop => translator.jumperLevelBroadTop,
    JumperLevelDescription.international => translator.jumperLevelInternational,
    JumperLevelDescription.regional => translator.jumperLevelRegional,
    JumperLevelDescription.local => translator.jumperLevelLocal,
    JumperLevelDescription.national => translator.jumperLevelNational,
    JumperLevelDescription.amateur => translator.jumperLevelAmateur,
    _ => translator.jumperLevelNoData,
  };
}

String translateJumperSubteamType({
  required BuildContext context,
  required SubteamType subteamType,
}) {
  final translator = translate(context);
  return switch (subteamType) {
    SubteamType.a => translator.subteamA,
    SubteamType.b => translator.subteamB,
    SubteamType.c => translator.subteamC,
    SubteamType.d => translator.subteamD,
    SubteamType.noSubteam => translator.jumperSubteamNoSubteam,
  };
}

IconData getThumbIconBySimpleRating({required SimpleRating? rating}) {
  switch (rating) {
    case SimpleRating.excellent:
    case SimpleRating.veryGood:
    case SimpleRating.good:
      return Symbols.thumb_up_alt_rounded;
    case SimpleRating.correct:
      return Symbols.horizontal_rule;
    case SimpleRating.belowExpectations:
    case SimpleRating.poor:
    case SimpleRating.veryPoor:
      return Symbols.thumb_down_alt_rounded;
    default:
      return Symbols.question_mark;
  }
}
