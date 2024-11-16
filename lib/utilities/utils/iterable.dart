import 'dart:math';

extension IterableRandomAccess<T> on Iterable<T> {
  T randomElement() {
    final random = Random();
    return elementAt(random.nextInt(length));
  }
}

extension MaybeElementAt<T> on Iterable<T> {
  T? maybeElementAt(int index) {
    return index < length ? elementAt(index) : null;
  }
}

extension PenultimateElement<T> on Iterable<T> {
  T get penultimate => elementAt(length - 2);
}
