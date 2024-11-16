import 'package:uuid/v4.dart';
import 'package:nanoid/nanoid.dart' as nanoid;

abstract interface class IdGenerator {
  const IdGenerator();

  String generate();
}

class UuidV4Generator implements IdGenerator {
  const UuidV4Generator();

  static const _uuid = UuidV4();

  @override
  String generate() {
    return _uuid.generate();
  }
}

class NanoIdGenerator implements IdGenerator {
  const NanoIdGenerator({
    required this.size,
  });

  final int size;

  @override
  String generate() {
    return nanoid.nanoid(size);
  }
}
