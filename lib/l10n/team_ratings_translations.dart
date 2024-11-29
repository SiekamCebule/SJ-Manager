import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/core/career_mode/simple_rating.dart';

String getTeamMoraleDescription({
  required BuildContext context,
  required SimpleRating? rating,
}) {
  final translator = translate(context);
  return switch (rating) {
    SimpleRating.excellent => translator.teamMoraleExcellent,
    SimpleRating.veryGood => translator.teamMoraleVeryGood,
    SimpleRating.good => translator.teamMoraleGood,
    SimpleRating.correct => translator.teamMoraleCorrect,
    SimpleRating.belowExpectations => translator.teamMoraleBelowExpectations,
    SimpleRating.poor => translator.teamMoralePoor,
    SimpleRating.veryPoor => translator.teamMoraleVeryPoor,
    _ => translator.teamMoraleNoData,
  };
}

String getTeamJumpsDescription({
  required BuildContext context,
  required SimpleRating? rating,
}) {
  final translator = translate(context);
  return switch (rating) {
    SimpleRating.excellent => translator.teamJumpsExcellent,
    SimpleRating.veryGood => translator.teamJumpsVeryGood,
    SimpleRating.good => translator.teamJumpsGood,
    SimpleRating.correct => translator.teamJumpsCorrect,
    SimpleRating.belowExpectations => translator.teamJumpsBelowExpectations,
    SimpleRating.poor => translator.teamJumpsPoor,
    SimpleRating.veryPoor => translator.teamJumpsVeryPoor,
    _ => translator.teamJumpsNoData,
  };
}

String getTeamTrainingDescription({
  required BuildContext context,
  required SimpleRating? rating,
}) {
  final translator = translate(context);
  return switch (rating) {
    SimpleRating.excellent => translator.teamTrainingExcellent,
    SimpleRating.veryGood => translator.teamTrainingVeryGood,
    SimpleRating.good => translator.teamTrainingGood,
    SimpleRating.correct => translator.teamTrainingCorrect,
    SimpleRating.belowExpectations => translator.teamTrainingBelowExpectations,
    SimpleRating.poor => translator.teamTrainingPoor,
    SimpleRating.veryPoor => translator.teamTrainingVeryPoor,
    _ => translator.teamTrainingNoData,
  };
}
