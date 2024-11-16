import 'package:rxdart/rxdart.dart';

class ValueRepo<T> {
  ValueRepo({T? initial}) {
    if (initial != null) {
      _subject.add(initial);
    }
  }

  final _subject = BehaviorSubject<T>();

  void set(T value) {
    _subject.add(value);
  }

  void dispose() {
    _subject.close();
  }

  ValueStream<T> get items => _subject.stream;
  T get last => items.value;
}

class NullableValueRepo<T> extends ValueRepo<T?> {
  NullableValueRepo({T? initial, bool init = true}) {
    if (init) {
      _subject.add(initial);
    }
  }
}
