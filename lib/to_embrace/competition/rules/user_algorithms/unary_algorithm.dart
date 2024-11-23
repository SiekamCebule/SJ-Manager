abstract interface class UnaryAlgorithm<I, O> {
  const UnaryAlgorithm();
  O compute(I input);
}
