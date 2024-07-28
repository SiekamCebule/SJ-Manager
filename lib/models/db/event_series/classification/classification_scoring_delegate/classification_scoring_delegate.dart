abstract interface class ClassificationScoringDelegate<S, E, I> {
  const ClassificationScoringDelegate();

  S calculateScore({required E entity, required I input});
}
