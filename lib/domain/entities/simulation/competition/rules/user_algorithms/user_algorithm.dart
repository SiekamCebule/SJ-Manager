// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sj_manager/domain/entities/simulation/competition/rules/user_algorithms/unary_algorithm.dart';

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

  UserAlgorithm<T> copyWith({
    String? id,
    String? name,
    String? description,
    T? algorithm,
  }) {
    return UserAlgorithm<T>(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      algorithm: algorithm ?? this.algorithm,
    );
  }

  UserAlgorithm<R> cast<R extends UnaryAlgorithm>() {
    return UserAlgorithm<R>(
      id: id,
      name: name,
      description: description,
      algorithm: algorithm as R,
    );
  }
}
