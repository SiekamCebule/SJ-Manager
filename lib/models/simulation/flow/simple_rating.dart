import 'package:flutter/material.dart';

enum SimpleRating {
  excellent,
  veryGood,
  good,
  correct,
  belowExpectations,
  poor,
  veryPoor;

  static SimpleRating fromJson(String name) {
    return SimpleRating.values.singleWhere((value) => value.name == name);
  }

  int get impactScore {
    if (this == SimpleRating.excellent ||
        this == SimpleRating.veryGood ||
        this == SimpleRating.good) {
      return 1;
    } else if (this == SimpleRating.correct) {
      return 0;
    } else {
      return -1;
    }
  }

  int get impactValue {
    switch (this) {
      case SimpleRating.excellent:
        return 3;
      case SimpleRating.veryGood:
        return 2;
      case SimpleRating.good:
        return 1;
      case SimpleRating.correct:
        return 0;
      case SimpleRating.belowExpectations:
        return -1;
      case SimpleRating.poor:
        return -2;
      case SimpleRating.veryPoor:
        return -3;
    }
  }

  static SimpleRating fromImpactValue(int impactValue) {
    switch (impactValue) {
      case 3:
        return SimpleRating.excellent;
      case 2:
        return SimpleRating.veryGood;
      case 1:
        return SimpleRating.good;
      case 0:
        return SimpleRating.correct;
      case -1:
        return SimpleRating.belowExpectations;
      case -2:
        return SimpleRating.poor;
      case -3:
        return SimpleRating.veryPoor;
      default:
        throw ArgumentError('Invalid impact value: $impactValue');
    }
  }
}

const darkThemeSimpleRatingColors = {
  SimpleRating.excellent: Color.fromRGBO(177, 222, 243, 1),
  SimpleRating.veryGood: Color.fromRGBO(148, 233, 165, 1.0),
  SimpleRating.good: Color.fromRGBO(193, 233, 203, 1.0),
  SimpleRating.correct:
      Color.fromARGB(255, 230, 230, 230), //Color.fromRGBO(227, 240, 191, 1.0),
  SimpleRating.belowExpectations: Color.fromRGBO(236, 216, 186, 1.0),
  SimpleRating.poor: Color.fromRGBO(231, 169, 169, 1.0),
  SimpleRating.veryPoor: Color.fromRGBO(225, 140, 136, 1.0),
  null: Color.fromRGBO(201, 201, 201, 1),
};
