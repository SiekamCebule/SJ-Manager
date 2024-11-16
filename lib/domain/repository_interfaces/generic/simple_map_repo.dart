import 'package:sj_manager/domain/repository_interfaces/generic/value_repo.dart';

class SimpleMapRepo<K, V> extends ValueRepo<Map<K, V>> {
  void emitCopiedCurrent() {
    set(Map.of(last));
  }
}
