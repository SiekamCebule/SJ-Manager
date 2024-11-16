import 'package:sj_manager/data/models/simulation/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/user_algorithms/user_algorithm.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/value_repo.dart';

typedef UserAlgorithmsList = List<UserAlgorithm<UnaryAlgorithm>>;

class UserAlgorithmsRepo extends ValueRepo<Map<Type, UserAlgorithmsList>> {
  UserAlgorithmsRepo({Map<Type, UserAlgorithmsList> initial = const {}}) {
    set(initial);
  }

  void addAlgorithms({
    required Type type,
    required UserAlgorithmsList algorithms,
    bool overwrite = false,
  }) {
    if (last.containsKey(type) && overwrite == false) {
      throw StateError(
        'UserAlgorithmsRepo already contains the $type type, but the \'overwrite\' flag is set to false',
      );
    }
    final map = Map.of(last);
    map[type] = algorithms;
    set(map);
  }

  void removeAlgorithms(Type typeToRemove) {
    final map = Map.of(last)
      ..removeWhere(
        (type, algorithm) => type == typeToRemove,
      );
    set(map);
  }

  UserAlgorithmsList algorithms(Type type) {
    if (!last.containsKey(type)) {
      throw StateError(
        'UserAlgorithmsRepo does not contain any UserAlgorithm list associated with that type ($type)',
      );
    }
    return last[type]!;
  }
}
