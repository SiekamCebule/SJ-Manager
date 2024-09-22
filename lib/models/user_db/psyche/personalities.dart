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
  enlightened // Oświecenie, Oświecony
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
