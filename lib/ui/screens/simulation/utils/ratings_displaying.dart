import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_level_description.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

String getMoraleDescription({
  required BuildContext context,
  required SimpleRating rating,
}) {
  final translator = translate(context);
  return switch (rating) {
    SimpleRating.excellent => translator.moraleExcellent,
    SimpleRating.veryGood => translator.moraleVeryGood,
    SimpleRating.good => translator.moraleGood,
    SimpleRating.correct => translator.moraleCorrect,
    SimpleRating.belowExpectations => translator.moraleBelowExpectations,
    SimpleRating.poor => translator.moralePoor,
    SimpleRating.veryPoor => translator.moraleVeryPoor,
  };
}

String getResultsDescription({
  required BuildContext context,
  required SimpleRating rating,
}) {
  final translator = translate(context);
  ;
  return switch (rating) {
    SimpleRating.excellent => translator.resultsExcellent,
    SimpleRating.veryGood => translator.resultsVeryGood,
    SimpleRating.good => translator.resultsGood,
    SimpleRating.correct => translator.resultsCorrect,
    SimpleRating.belowExpectations => translator.resultsBelowExpectations,
    SimpleRating.poor => translator.resultsPoor,
    SimpleRating.veryPoor => translator.resultsVeryPoor,
  };
}

String getTrainingDescription({
  required BuildContext context,
  required SimpleRating rating,
}) {
  final translator = translate(context);
  return switch (rating) {
    SimpleRating.excellent => translator.trainingExcellent,
    SimpleRating.veryGood => translator.trainingVeryGood,
    SimpleRating.good => translator.trainingGood,
    SimpleRating.correct => translator.trainingCorrect,
    SimpleRating.belowExpectations => translator.trainingBelowExpectations,
    SimpleRating.poor => translator.trainingPoor,
    SimpleRating.veryPoor => translator.trainingVeryPoor,
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

IconData getThumbIconBySimpleRating({required SimpleRating rating}) {
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
  }
}
