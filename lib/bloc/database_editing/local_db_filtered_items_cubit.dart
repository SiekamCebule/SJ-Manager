import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/bloc/database_editing/local_db_filtered_items_state.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';

class LocalDbFilteredItemsCubit extends Cubit<LocalDbFilteredItemsState> {
  LocalDbFilteredItemsCubit({
    required this.filtersRepo,
    required this.itemsRepos,
  }) : super(_initial) {
    _setUp();
  }

  final DbFiltersRepo filtersRepo;
  final ItemsReposRegistry itemsRepos;

  final Set<StreamSubscription> _subscriptions = {};

  void _setUp() {
    for (final repo in itemsRepos.last) {
      final Type itemType = repo.itemsType;
      if (!filtersRepo.containsType(itemType)) continue;
      final filtersStream = filtersRepo.streamByTypeArgument(itemType);
      final combinedStream =
          Rx.combineLatest2<dynamic, dynamic, (List<dynamic>, List<Filter<dynamic>>)>(
              repo.items, filtersStream, (items, filters) => (items, filters));

      final subscription = combinedStream.listen((data) {
        final items = data.$1;
        final filters = data.$2;

        late List filtered;
        if (itemType == MaleJumper) {
          filtered = Filter.filterAll<MaleJumper>(
              items.cast<MaleJumper>(), filters.cast<Filter<MaleJumper>>());
        } else if (itemType == FemaleJumper) {
          filtered = Filter.filterAll<FemaleJumper>(
              items.cast<FemaleJumper>(), filters.cast<Filter<FemaleJumper>>());
        } else if (itemType == Hill) {
          filtered =
              Filter.filterAll<Hill>(items.cast<Hill>(), filters.cast<Filter<Hill>>());
        } else if (itemType == EventSeriesSetup) {
          filtered = Filter.filterAll<EventSeriesSetup>(
              items.cast<EventSeriesSetup>(), filters.cast<Filter<EventSeriesSetup>>());
        } else if (itemType == EventSeriesSetup) {
          filtered = Filter.filterAll<EventSeriesCalendarPreset>(
              items.cast<EventSeriesCalendarPreset>(),
              filters.cast<Filter<EventSeriesCalendarPreset>>());
        } else if (itemType == CompetitionRulesPreset) {
          filtered = Filter.filterAll<CompetitionRulesPreset>(
              items.cast<CompetitionRulesPreset>(),
              filters.cast<Filter<CompetitionRulesPreset>>());
        } else {
          throw UnsupportedError(
              '(LocalDbFilteredItemsCubit) Unsupported item type: $itemType');
        }

        emit(state.copyWith(type: repo.itemsType, items: filtered));
      });

      _subscriptions.add(subscription);
    }
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    filtersRepo.close();
    itemsRepos.dispose();
  }

  static const LocalDbFilteredItemsState _initial = LocalDbFilteredItemsState(
    filteredItemsByType: {
      MaleJumper: [],
      FemaleJumper: [],
      Hill: [],
      EventSeriesSetup: [],
      EventSeriesCalendarPreset: [],
      CompetitionRulesPreset: [],
    },
  );
}
