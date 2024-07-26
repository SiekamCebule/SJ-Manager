import 'dart:math';

extension IterableRandomAccess<T> on Iterable<T> {
  T randomElement() {
    final random = Random();
    return elementAt(random.nextInt(length));
  }
}

extension PenultimateElement<T> on Iterable<T> {
  T get penultimate => elementAt(length - 2);
}
