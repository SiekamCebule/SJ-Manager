import 'package:equatable/equatable.dart';

class LocalDbFilteredItemsState extends Equatable {
  const LocalDbFilteredItemsState({required this.filteredItemsByType});

  final Map<Type, List> filteredItemsByType;

  List<T> get<T>() {
    return filteredItemsByType[T]! as List<T>;
  }

  List byTypeArgument(Type type) {
    return filteredItemsByType[type]!;
  }

  LocalDbFilteredItemsState copyWith({
    required Type type,
    required List items,
  }) {
    final map = Map.of(filteredItemsByType);
    map[type] = items;
    return LocalDbFilteredItemsState(filteredItemsByType: map);
  }

  @override
  List<Object?> get props => [
        filteredItemsByType.keys,
        filteredItemsByType.values,
      ];
}
