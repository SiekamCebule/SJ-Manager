extension SetToggle<T> on Set<T> {
  /// Returns 'true', if the [element] had not been contained in the Set, and was added.
  /// Returns 'false', if the [element] had been already contained in the Set, and was removed.
  bool toggle(T element) {
    if (contains(element)) {
      remove(element);
      return false;
    } else {
      add(element);
      return true;
    }
  }
}
