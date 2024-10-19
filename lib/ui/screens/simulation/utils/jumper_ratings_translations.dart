import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_level_description.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

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

String getJumperLevelDescription({
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
