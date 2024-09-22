import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/user_db/psyche/levels_of_consciousness.dart';
import 'package:sj_manager/models/user_db/psyche/personalities.dart';

String levelOfConsciousnessName({
  required BuildContext context,
  required LevelsOfConsciousness levelOfConsciousness,
}) {
  final translator = translate(context);
  return switch (levelOfConsciousness) {
    LevelsOfConsciousness.shame => translator.shame,
    LevelsOfConsciousness.guilt => translator.guilt,
    LevelsOfConsciousness.apathy => translator.apathy,
    LevelsOfConsciousness.grief => translator.grief,
    LevelsOfConsciousness.fear => translator.fear,
    LevelsOfConsciousness.desire => translator.desire,
    LevelsOfConsciousness.anger => translator.anger,
    LevelsOfConsciousness.pride => translator.pride,
    LevelsOfConsciousness.courage => translator.courage,
    LevelsOfConsciousness.neutrality => translator.neutrality,
    LevelsOfConsciousness.willingness => translator.willingness,
    LevelsOfConsciousness.acceptance => translator.acceptance,
    LevelsOfConsciousness.reason => translator.reason,
    LevelsOfConsciousness.love => translator.love,
    LevelsOfConsciousness.joy => translator.joy,
    LevelsOfConsciousness.peace => translator.peace,
    LevelsOfConsciousness.enlightenment => translator.enlightenment,
  };
}

String personalityName({
  required BuildContext context,
  required Personalities personality,
}) {
  final translator = translate(context);
  return switch (personality) {
    Personalities.compromised => translator.compromised,
    Personalities.selfCritical => translator.selfCritical,
    Personalities.resigned => translator.resigned,
    Personalities.nostalgic => translator.nostalgic,
    Personalities.insecure => translator.insecure,
    Personalities.yearning => translator.yearning,
    Personalities.stubborn => translator.stubborn,
    Personalities.arrogant => translator.arrogant,
    Personalities.resourceful => translator.resourceful,
    Personalities.balanced => translator.balanced,
    Personalities.optimistic => translator.optimistic,
    Personalities.open => translator.open,
    Personalities.rational => translator.rational,
    Personalities.devoted => translator.devoted,
    Personalities.spiritualJoy => translator.spiritualJoy,
    Personalities.spiritualPeace => translator.spiritualPeace,
    Personalities.enlightened => translator.enlightened,
  };
}
