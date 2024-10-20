enum JumpingStyle {
  veryDefensive,
  clearlyDefensive,
  defensive,
  cautious,
  slightlyCautious,
  balanced,
  fairlyUnpredictable,
  unpredictable,
  risky,
  clearlyRisky,
  veryRisky,
}

final Map<int, JumpingStyle> jumpingStyleMap = {
  -5: JumpingStyle.veryDefensive,
  -4: JumpingStyle.clearlyDefensive,
  -3: JumpingStyle.defensive,
  -2: JumpingStyle.cautious,
  -1: JumpingStyle.slightlyCautious,
  0: JumpingStyle.balanced,
  1: JumpingStyle.fairlyUnpredictable,
  2: JumpingStyle.unpredictable,
  3: JumpingStyle.risky,
  4: JumpingStyle.clearlyRisky,
  5: JumpingStyle.veryRisky,
};
