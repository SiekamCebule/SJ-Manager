import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/bloc/database_editing/state/database_items_state.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/filters/mixins.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';

class DatabaseItemsCubit extends Cubit<DatabaseItemsState> {
  DatabaseItemsCubit({
    required this.filtersRepo,
    required this.itemsRepos,
  }) : super(_initial) {
    changeType(state.itemsType);
  }

  final DbFiltersRepo filtersRepo;
  final ItemsReposRegistry itemsRepos;

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

  void changeType(Type type) {
    _itemsSubscription?.cancel();
    final filtersStream = filtersRepo.streamByTypeArgument(type);
    final itemsStream = itemsRepos.byTypeArgument(type);
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

  void selectByIndex(int index) {
    final type = switch (index) {
      0 => MaleJumper,
      1 => FemaleJumper,
      2 => Hill,
      3 => EventSeriesSetup,
      4 => EventSeriesCalendarPreset,
      5 => DefaultCompetitionRulesPreset,
      _ => throw TypeError(),
    };
    changeType(type);
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    filtersRepo.close();
    itemsRepos.dispose();
  }

  static const DatabaseItemsState _initial = DatabaseItemsEmpty(
    itemsType: MaleJumper,
    nonSearchingFiltersActive: false,
    searchingActive: false,
  );
}
