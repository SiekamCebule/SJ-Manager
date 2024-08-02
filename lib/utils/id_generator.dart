import 'package:uuid/v4.dart';
import 'package:nanoid/nanoid.dart' as nanoid;

abstract interface class IdGenerator<T extends Object> {
  const IdGenerator();

  T generate();
}

class UuidV4Generator implements IdGenerator<String> {
  const UuidV4Generator();

  static const _uuid = UuidV4();

  @override
  String generate() {
    return _uuid.generate();
  }
}

class NanoIdGenerator implements IdGenerator<String> {
  const NanoIdGenerator({
    required this.size,
  });

  final int size;

  @override
  String generate() {
    return nanoid.nanoid(size);
  }
}
