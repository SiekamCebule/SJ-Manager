import 'package:sj_manager/models/database/psyche/level_of_consciousness.dart';
import 'package:sj_manager/models/database/psyche/personalities.dart';

const personalityByLoc = {
  LevelOfConsciousnessLabels.shame: Personalities.compromised, // Wstyd, Skompromitowany
  LevelOfConsciousnessLabels.guilt: Personalities.selfCritical, // Wina, Samokrytyczny
  LevelOfConsciousnessLabels.apathy: Personalities.resigned, // Apatia, Zrezygnowany
  LevelOfConsciousnessLabels.grief: Personalities.nostalgic, // Żal, Nostalgiczny
  LevelOfConsciousnessLabels.fear: Personalities.insecure, // Strach, Niepewny
  LevelOfConsciousnessLabels.desire: Personalities.yearning, // Pożądanie, Pragnący
  LevelOfConsciousnessLabels.anger: Personalities.stubborn, // Złość, Uparty
  LevelOfConsciousnessLabels.pride: Personalities.arrogant, // Duma, Dumny
  LevelOfConsciousnessLabels.courage: Personalities.resourceful, // Odwaga, Zaradny
  LevelOfConsciousnessLabels.neutrality: Personalities.balanced, // Neutralność, Wyważony
  LevelOfConsciousnessLabels.willingness:
      Personalities.optimistic, // Ochota, Optymistyczny
  LevelOfConsciousnessLabels.acceptance: Personalities.open, // Akceptacja, Otwarty
  LevelOfConsciousnessLabels.reason: Personalities.rational, // Rozsądek, Racjonalny
  LevelOfConsciousnessLabels.love: Personalities.devoted, // Miłość, Oddany
  LevelOfConsciousnessLabels.joy: Personalities.spiritualJoy, // Radość, Duchowa Radość
  LevelOfConsciousnessLabels.peace: Personalities.spiritualPeace, // Pokój, Duchowy Spokój
  LevelOfConsciousnessLabels.enlightenment:
      Personalities.enlightened, // Oświecenie, Oświecony
};

LevelOfConsciousness locByPersonality(Personalities personality) {
  final locLabel = personalityByLoc.keys.singleWhere(
    (locLabel) => personalityByLoc[locLabel]! == personality,
  );
  return LevelOfConsciousness(levelOfConsciousnessLog[locLabel]!);
}
