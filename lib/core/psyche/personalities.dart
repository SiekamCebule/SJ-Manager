import 'package:sj_manager/core/psyche/level_of_consciousness.dart';

enum Personalities {
  compromised, // Wstyd, Skompromitowany
  selfCritical, // Wina, Samokrytyczny
  resigned, // Apatia, Zrezygnowany
  nostalgic, // Żal, Nostalgiczny
  insecure, // Strach, Niepewny
  yearning, // Pożądanie, Pragnący
  stubborn, // Złość, Uparty
  arrogant, // Duma, Dumny
  resourceful, // Odwaga, Zaradny
  balanced, // Neutralność, Wyważony
  optimistic, // Ochota, Optymistyczny
  open, // Akceptacja, Otwarty
  rational, // Rozsądek, Racjonalny
  devoted, // Miłość, Oddany
  spiritualJoy, // Radość, Duchowa Radość
  spiritualPeace, // Pokój, Duchowy Spokój
  enlightened; // Oświecenie, Oświecony

  static Personalities fromLevelOfConsciousness(LevelOfConsciousnessLabels label) {
    switch (label) {
      case LevelOfConsciousnessLabels.shame:
        return Personalities.compromised;
      case LevelOfConsciousnessLabels.guilt:
        return Personalities.selfCritical;
      case LevelOfConsciousnessLabels.apathy:
        return Personalities.resigned;
      case LevelOfConsciousnessLabels.grief:
        return Personalities.nostalgic;
      case LevelOfConsciousnessLabels.fear:
        return Personalities.insecure;
      case LevelOfConsciousnessLabels.desire:
        return Personalities.yearning;
      case LevelOfConsciousnessLabels.anger:
        return Personalities.stubborn;
      case LevelOfConsciousnessLabels.pride:
        return Personalities.arrogant;
      case LevelOfConsciousnessLabels.courage:
        return Personalities.resourceful;
      case LevelOfConsciousnessLabels.neutrality:
        return Personalities.balanced;
      case LevelOfConsciousnessLabels.willingness:
        return Personalities.optimistic;
      case LevelOfConsciousnessLabels.acceptance:
        return Personalities.open;
      case LevelOfConsciousnessLabels.reason:
        return Personalities.rational;
      case LevelOfConsciousnessLabels.love:
        return Personalities.devoted;
      case LevelOfConsciousnessLabels.joy:
        return Personalities.spiritualJoy;
      case LevelOfConsciousnessLabels.peace:
        return Personalities.spiritualPeace;
      case LevelOfConsciousnessLabels.enlightenment:
        return Personalities.enlightened;
    }
  }
}

var sjmPersonalities = Personalities.values.where(
  (personality) {
    const exclude = {
      Personalities.compromised,
      Personalities.selfCritical,
      Personalities.spiritualJoy,
      Personalities.spiritualPeace,
      Personalities.enlightened,
    };
    if (exclude.contains(personality)) {
      return false;
    } else {
      return true;
    }
  },
);
