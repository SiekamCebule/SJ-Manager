import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/presentation/bloc/database_editing/state/database_items_state.dart';
import 'package:sj_manager/utilities/filters/filter.dart';
import 'package:sj_manager/data/repositories/items_repos_registry.dart';
import 'package:sj_manager/features/game_variants/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/domain/repository_interfaces/database_editing/db_filters_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/database_editing/selected_indexes_repository.dart';

class DatabaseItemsCubit extends Cubit<DatabaseItemsState> {
  DatabaseItemsCubit({
    required this.filtersRepo,
    required this.selectedIndexesRepo,
    required ItemsReposRegistry itemsRepos,
  })  : _itemsRepos = itemsRepos,
        super(_initial) {
    filtersRepo.addListener(() {
      _filtersStreamController.add(null);
    });
    changeType(state.itemsType);
  }

  final DbFiltersRepo filtersRepo;
  final SelectedIndexesRepo selectedIndexesRepo;
  ItemsReposRegistry _itemsRepos;
  ItemsReposRegistry get itemsRepos => _itemsRepos;

  final Set<StreamSubscription> _subscriptions = {};

  StreamSubscription? _itemsSubscription;
  final _filtersStreamController = BehaviorSubject.seeded(null);

  List<T> _filter<T>(List<dynamic> items, List<Filter<dynamic>> filters) {
    return Filter.filterAll(items.cast<T>(), filters.cast<Filter<T>>()).toList();
  }

  List _filterByTypeArgument(
    Type type, {
    required List items,
    required List<Filter> filters,
  }) {
    if (type == MaleJumperDbRecord) {
      return _filter<JumperDbRecord>(items, filters);
    } else if (type == FemaleJumperDbRecord) {
      return _filter<JumperDbRecord>(items, filters);
    } else {
      throw UnsupportedError('(DatabaseItemsCubit) Unsupported item type: $type');
    }
  }

  void updateItemsRepo(ItemsReposRegistry repo) {
    _itemsRepos = repo;
    changeType(state.itemsType);
  }

  void changeType(Type type) {
    _itemsSubscription?.cancel();
    final itemsStream = _itemsRepos.byTypeArgument(type);
    _itemsSubscription = Rx.combineLatest2(
        itemsStream.items, _filtersStreamController.stream, (items, _) => items).listen(
      (items) {
        late Iterable<Filter> filters;
        if (type == MaleJumperDbRecord) {
          filters = [
            filtersRepo.maleJumpersCountryFilter,
            filtersRepo.maleJumpersSearchFilter
          ].nonNulls;
        } else if (type == FemaleJumperDbRecord) {
          filters = [
            filtersRepo.femaleJumpersCountryFilter,
            filtersRepo.femaleJumpersSearchFilter,
          ].nonNulls;
        }
        final filtered =
            _filterByTypeArgument(type, items: items, filters: filters.toList());
        if (filtered.isNotEmpty) {
          emit(
            DatabaseItemsNonEmpty(
              itemsType: type,
              filteredItems: filtered,
              hasValidFilters: filters.isNotEmpty,
            ),
          );
        } else {
          emit(
            DatabaseItemsEmpty(
              itemsType: type,
              hasValidFilters: filters.isNotEmpty,
            ),
          );
        }
      },
    );
  }

  void add({required dynamic item}) {
    if (selectedIndexesRepo.last.length > 1) {
      throw StateError(
        'Cannot add an item to DatabaseItemsCubit because there are more than one item selected',
      );
    }
    final singleSelectedOrNull = selectedIndexesRepo.last.singleOrNull;
    final lastIndex = state is DatabaseItemsNonEmpty
        ? itemsRepos.getEditable(state.itemsType).last.length
        : 0;
    int addIndex;
    if (singleSelectedOrNull != null) {
      addIndex = singleSelectedOrNull + 1;
    } else {
      addIndex = singleSelectedOrNull ?? lastIndex;
    }
    _itemsRepos.getEditable(state.itemsType).add(item, addIndex);
    if (singleSelectedOrNull != null) {
      selectedIndexesRepo.setSelection(addIndex - 1, false);
    }
    selectedIndexesRepo.setSelection(addIndex, true);
  }

  void remove() {
    final indexes = List.of(selectedIndexesRepo.last)..sort((a, b) => b.compareTo(a));
    if (indexes.isEmpty) {
      throw StateError(
        'Cannot remove an item from DatabaseItemsCubit because there is no item selected',
      );
    }
    if (indexes.length > 1) {
      final editableItems = itemsRepos.getEditable(state.itemsType);
      for (int index in indexes) {
        editableItems.removeAt(index);
      }
      selectedIndexesRepo.clearSelection();
    } else if (indexes.length == 1) {
      itemsRepos.getEditable(state.itemsType).removeAt(indexes.single);
      if (indexes.single != 0) {
        selectedIndexesRepo.selectOnlyAt(indexes.single - 1);
      } else {
        selectedIndexesRepo.clearSelection();
      }
    }
  }

  void replace({required dynamic changedItem}) async {
    if (selectedIndexesRepo.last.length != 1) {
      throw StateError(
        'Cannot replace an item in the database if there are no selected items',
      );
    }
    if (changedItem == null) {
      throw StateError('Cannot add a null item to the database');
    }

    final selectedIndex = selectedIndexesRepo.last.single;
    final filteredItems = (state as DatabaseItemsNonEmpty).filteredItems;
    final originalItems = itemsRepos.getEditable(state.itemsType).last;
    final originalIndex = originalItems.indexOf(filteredItems[selectedIndex]);

    final itemsByTypeRepo = itemsRepos.getEditable(state.itemsType);
    itemsByTypeRepo.replace(oldIndex: originalIndex, newItem: changedItem);
  }

  void move({required int from, required int to}) {
    if (to > from) {
      to -= 1;
    }
    itemsRepos.getEditable(state.itemsType).move(from: from, to: to);
    selectedIndexesRepo.moveSelection(from: from, to: to);
  }

  void selectTab(int index) {
    final type = switch (index) {
      0 => MaleJumperDbRecord,
      1 => FemaleJumperDbRecord,
      _ => throw TypeError(),
    };
    selectedIndexesRepo.clearSelection();
    changeType(type);
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _filtersStreamController.close();
    _itemsRepos.dispose();
  }

  static const DatabaseItemsState _initial = DatabaseItemsEmpty(
    itemsType: MaleJumperDbRecord,
    hasValidFilters: false,
  );
}
