import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

String translateTrainingEffectOnConsistency({
  required BuildContext context,
  required SimpleRating rating,
}) {
  final translator = translate(context);
  return switch (rating) {
    SimpleRating.excellent => translator.trainingEffectOnConsistencyExcellent,
    SimpleRating.veryGood => translator.trainingEffectOnConsistencyVeryGood,
    SimpleRating.good => translator.trainingEffectOnConsistencyGood,
    SimpleRating.correct => translator.trainingEffectOnConsistencyCorrect,
    SimpleRating.belowExpectations =>
      translator.trainingEffectOnConsistencyBelowExpectations,
    SimpleRating.poor => translator.trainingEffectOnConsistencyPoor,
    SimpleRating.veryPoor => translator.trainingEffectOnConsistencyVeryPoor,
  };
}
