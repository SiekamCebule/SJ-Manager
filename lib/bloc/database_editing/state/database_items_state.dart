import 'package:equatable/equatable.dart';

abstract class DatabaseItemsState with EquatableMixin {
  const DatabaseItemsState({
    required this.itemsType,
    required this.hasValidFilters,
  });

  final Type itemsType;
  final bool hasValidFilters;

  @override
  List<Object?> get props => [
        itemsType,
        hasValidFilters,
      ];
}

class DatabaseItemsNonEmpty extends DatabaseItemsState {
  const DatabaseItemsNonEmpty({
    required super.itemsType,
    required super.hasValidFilters,
    required this.filteredItems,
  });

  final List<dynamic> filteredItems;

  @override
  List<Object?> get props => [
        super.props,
        filteredItems,
      ];
}

class DatabaseItemsEmpty extends DatabaseItemsState {
  const DatabaseItemsEmpty({
    required super.itemsType,
    required super.hasValidFilters,
  });

  @override
  List<Object?> get props => [
        super.props,
      ];
}
