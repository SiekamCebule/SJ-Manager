import 'package:uuid/v4.dart';

abstract interface class IdGenerator<T extends Object> {
  T generate();
}

class Uuid4 implements IdGenerator<String> {
  static const _uuid = UuidV4();

  @override
  String generate() {
    return _uuid.generate();
  }
}
