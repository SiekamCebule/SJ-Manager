enum JumpingTechnique {
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

final Map<int, JumpingTechnique> jumpingStyleMap = {
  -5: JumpingTechnique.veryDefensive,
  -4: JumpingTechnique.clearlyDefensive,
  -3: JumpingTechnique.defensive,
  -2: JumpingTechnique.cautious,
  -1: JumpingTechnique.slightlyCautious,
  0: JumpingTechnique.balanced,
  1: JumpingTechnique.fairlyUnpredictable,
  2: JumpingTechnique.unpredictable,
  3: JumpingTechnique.risky,
  4: JumpingTechnique.clearlyRisky,
  5: JumpingTechnique.veryRisky,
};
