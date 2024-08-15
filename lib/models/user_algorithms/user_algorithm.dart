import 'package:sj_manager/models/user_algorithms/unary_algorithm.dart';

class UserAlgorithm<T extends UnaryAlgorithm> {
  const UserAlgorithm({
    required this.id,
    required this.name,
    required this.description,
    required this.algorithm,
  });

  final String id;
  final String name;
  final String description;
  final T algorithm;
}
