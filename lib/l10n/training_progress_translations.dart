import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/data/models/simulation/flow/simple_rating.dart';

String translateTrainingProgress(
  SimpleRating rating, {
  required BuildContext context,
}) {
  final translator = translate(context);
  return switch (rating) {
    SimpleRating.excellent => translator.excellentTrainingProgressShortLabel,
    SimpleRating.veryGood => translator.veryGoodTrainingProgressShortLabel,
    SimpleRating.good => translator.goodTrainingProgressShortLabel,
    SimpleRating.correct => translator.correctTrainingProgressShortLabel,
    SimpleRating.belowExpectations =>
      translator.belowExpectationsTrainingProgressShortLabel,
    SimpleRating.poor => translator.poorTrainingProgressShortLabel,
    SimpleRating.veryPoor => translator.veryPoorTrainingProgressShortLabel,
  };
}
