import 'package:equatable/equatable.dart';

enum EntitiesLimitType {
  exact,
  soft;
}

class EntitiesLimit with EquatableMixin {
  const EntitiesLimit({
    required this.type,
    required this.count,
  });

  const EntitiesLimit.soft(int count)
      : this(type: EntitiesLimitType.soft, count: count);
  const EntitiesLimit.exact(int count)
      : this(type: EntitiesLimitType.exact, count: count);

  final EntitiesLimitType type;
  final int count;

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
