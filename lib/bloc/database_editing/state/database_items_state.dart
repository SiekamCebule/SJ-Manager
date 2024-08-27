import 'package:equatable/equatable.dart';
import 'package:sj_manager/filters/filter.dart';

abstract class DatabaseItemsState with EquatableMixin {
  const DatabaseItemsState({
    required this.itemsType,
  });

  final Type itemsType;

  @override
  List<Object?> get props => [
        itemsType,
      ];
}

class DatabaseItemsNonEmpty extends DatabaseItemsState {
  const DatabaseItemsNonEmpty({
    required super.itemsType,
    required this.filteredItems,
    required this.validFilters,
  });

  final List<dynamic> filteredItems;
  final List<Filter> validFilters;

  bool get hasValidFilters => validFilters.isNotEmpty;

  @override
  List<Object?> get props => [
        super.props,
        filteredItems,
      ];
}

class DatabaseItemsEmpty extends DatabaseItemsState {
  const DatabaseItemsEmpty({
    required super.itemsType,
    required this.nonSearchingFiltersActive,
    required this.searchingActive,
  });

  final bool nonSearchingFiltersActive;
  final bool searchingActive;
  bool get hasValidFilters => nonSearchingFiltersActive || searchingActive;

  @override
  List<Object?> get props => [
        super.props,
        nonSearchingFiltersActive,
        searchingActive,
      ];
}
