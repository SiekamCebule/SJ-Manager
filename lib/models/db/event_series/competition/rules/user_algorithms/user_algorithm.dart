import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/unary_algorithm.dart';

abstract class UserAlgorithm<T extends UnaryAlgorithm> {
  const UserAlgorithm();

  String get id;
  String get name;
  String get description;
  T get algorithm;
}
