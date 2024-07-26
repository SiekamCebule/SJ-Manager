// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum EntitiesLimitType {
  exact,
  soft,
  none;
}

class EntitiesLimit with EquatableMixin {
  const EntitiesLimit({
    required this.type,
    required this.count,
  });

  final EntitiesLimitType type;
  final int? count;

  EntitiesLimit copyWith({
    EntitiesLimitType? type,
    int? count,
  }) {
    return EntitiesLimit(
      type: type ?? this.type,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [type, count];
}
