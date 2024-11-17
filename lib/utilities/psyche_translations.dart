import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/domain/entities/simulation/psyche/level_of_consciousness.dart';
import 'package:sj_manager/core/psyche/personalities.dart';

String levelOfConsciousnessName({
  required BuildContext context,
  required LevelOfConsciousnessLabels levelOfConsciousness,
}) {
  final translator = translate(context);
  return switch (levelOfConsciousness) {
    LevelOfConsciousnessLabels.shame => translator.shame,
    LevelOfConsciousnessLabels.guilt => translator.guilt,
    LevelOfConsciousnessLabels.apathy => translator.apathy,
    LevelOfConsciousnessLabels.grief => translator.grief,
    LevelOfConsciousnessLabels.fear => translator.fear,
    LevelOfConsciousnessLabels.desire => translator.desire,
    LevelOfConsciousnessLabels.anger => translator.anger,
    LevelOfConsciousnessLabels.pride => translator.pride,
    LevelOfConsciousnessLabels.courage => translator.courage,
    LevelOfConsciousnessLabels.neutrality => translator.neutrality,
    LevelOfConsciousnessLabels.willingness => translator.willingness,
    LevelOfConsciousnessLabels.acceptance => translator.acceptance,
    LevelOfConsciousnessLabels.reason => translator.reason,
    LevelOfConsciousnessLabels.love => translator.love,
    LevelOfConsciousnessLabels.joy => translator.joy,
    LevelOfConsciousnessLabels.peace => translator.peace,
    LevelOfConsciousnessLabels.enlightenment => translator.enlightenment,
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
