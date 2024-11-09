import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/bloc/database_editing/state/database_items_state.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/filters/mixins.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/utils/id_generator.dart';

class DatabaseItemsCubit extends Cubit<DatabaseItemsState> {
  DatabaseItemsCubit({
    required this.filtersRepo,
    required this.selectedIndexesRepo,
    //required this.idsRepo,
    required this.idGenerator,
    required ItemsReposRegistry itemsRepos,
  })  : _itemsRepos = itemsRepos,
        super(_initial) {
    changeType(state.itemsType);
  }

  final DbFiltersRepo filtersRepo;
  final SelectedIndexesRepo selectedIndexesRepo;
  //final ItemsIdsRepo idsRepo;
  final IdGenerator idGenerator;
  ItemsReposRegistry _itemsRepos;
  ItemsReposRegistry get itemsRepos => _itemsRepos;

  final Set<StreamSubscription> _subscriptions = {};

  StreamSubscription? _itemsSubscription;

  List<T> _filter<T>(List<dynamic> items, List<Filter<dynamic>> filters) {
    return Filter.filterAll(items.cast<T>(), filters.cast<Filter<T>>());
  }

  List _filterByTypeArgument(
    Type type, {
    required List items,
    required List<Filter> filters,
  }) {
    if (type == MaleJumper) {
      return _filter<MaleJumper>(items, filters);
    } else if (type == FemaleJumper) {
      return _filter<FemaleJumper>(items, filters);
    } else if (type == Hill) {
      return _filter<Hill>(items, filters);
    } else if (type == EventSeriesSetup) {
      return _filter<EventSeriesSetup>(items, filters);
    } else if (type == EventSeriesCalendarPreset) {
      return _filter<EventSeriesCalendarPreset>(items, filters);
    } else if (type == DefaultCompetitionRulesPreset) {
      return _filter<DefaultCompetitionRulesPreset>(items, filters);
    } else {
      throw UnsupportedError('(LocalDbFilteredItemsCubit) Unsupported item type: $type');
    }
  }

  void updateItemsRepo(ItemsReposRegistry repo) {
    _itemsRepos = repo;
    changeType(state.itemsType);
  }

  void changeType(Type type) {
    _itemsSubscription?.cancel();
    final filtersStream = filtersRepo.streamByTypeArgument(type);
    final itemsStream = _itemsRepos.byTypeArgument(type);
    _itemsSubscription = Rx.combineLatest2(
      itemsStream.items,
      filtersStream,
      (items, filters) => (items, filters),
    ).listen((tuple) {
      final items = tuple.$1.toList();
      final filters = tuple.$2;
      final filtered = _filterByTypeArgument(type, items: items, filters: filters);
      if (filtered.isNotEmpty) {
        final validFilters = filters.where(
          (filter) => filter.isValid,
        );
        emit(DatabaseItemsNonEmpty(
          itemsType: type,
          filteredItems: filtered,
          validFilters: validFilters.toList(),
        ));
      } else {
        final preparedFilters = filters.map(
            (filter) => filter is ConcreteJumpersFilterWrapper ? filter.filter : filter);
        final nonSearchingFiltersActive = preparedFilters.any(
          (filter) => filter is SearchFilter == false && filter.isValid,
        );
        final searchingActive =
            preparedFilters.any((filter) => filter is SearchFilter && filter.isValid);
        emit(
          DatabaseItemsEmpty(
            itemsType: type,
            nonSearchingFiltersActive: nonSearchingFiltersActive,
            searchingActive: searchingActive,
          ),
        );
      }
    });
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
      0 => MaleJumper,
      1 => FemaleJumper,
      _ => throw TypeError(),
    };
    selectedIndexesRepo.clearSelection();
    filtersRepo.clear();
    changeType(type);
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    filtersRepo.close();
    _itemsRepos.dispose();
  }

  static const DatabaseItemsState _initial = DatabaseItemsEmpty(
    itemsType: MaleJumper,
    nonSearchingFiltersActive: false,
    searchingActive: false,
  );
}
