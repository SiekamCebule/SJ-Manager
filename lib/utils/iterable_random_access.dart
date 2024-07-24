import 'dart:math';

extension IterableRandomAccess<T> on Iterable<T> {
  T randomElement() {
    final random = Random();
    return elementAt(random.nextInt(length));
  }
}
