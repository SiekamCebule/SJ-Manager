import 'package:sj_manager/repositories/generic/value_repo.dart';

class SimpleMapRepo<K, V> extends ValueRepo<Map<K, V>> {
  void emitCopiedCurrent() {
    set(Map.of(last));
  }
}
