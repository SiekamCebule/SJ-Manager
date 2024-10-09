import 'package:flutter/material.dart';

enum SimpleRating {
  excellent,
  veryGood,
  good,
  correct,
  belowExpectations,
  poor,
  veryPoor,
}

const darkThemeSimpleRatingColors = {
  SimpleRating.excellent: Color.fromRGBO(177, 222, 243, 1),
  SimpleRating.veryGood: Color.fromRGBO(148, 233, 165, 1.0),
  SimpleRating.good: Color.fromRGBO(193, 233, 203, 1.0),
  SimpleRating.correct: Color.fromRGBO(227, 240, 191, 1.0),
  SimpleRating.belowExpectations: Color.fromRGBO(236, 216, 186, 1.0),
  SimpleRating.poor: Color.fromRGBO(231, 169, 169, 1.0),
  SimpleRating.veryPoor: Color.fromRGBO(225, 140, 136, 1.0),
};
