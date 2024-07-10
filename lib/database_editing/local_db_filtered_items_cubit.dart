import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/database_editing/local_db_filtered_items_state.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';
import 'package:sj_manager/repositories/database_editing/local_db_repos_repository.dart';
import 'package:sj_manager/filters/filter.dart';

class LocalDbFilteredItemsCubit extends Cubit<LocalDbFilteredItemsState> {
  LocalDbFilteredItemsCubit({
    required this.filtersRepo,
    required this.itemsRepo,
  }) : super(_initial) {
    _setUp();
  }

  final DbFiltersRepository filtersRepo;
  final LocalDbReposRepository itemsRepo;

  late final StreamSubscription _maleJumperChangesSubscription;
  late final StreamSubscription _femaleJumperChangesSubscription;
  late final StreamSubscription _hillChangesSubscription;

  void _setUp() {
    final maleStream = Rx.combineLatest2(itemsRepo.maleJumpersRepo.items,
        filtersRepo.maleJumpersFilters, (items, filters) => (items, filters));
    _maleJumperChangesSubscription = maleStream.listen((event) {
      final jumpers = event.$1.toList();
      final filters = event.$2;
      emit(state.copyWith(maleJumpers: Filter.filterAll(jumpers, filters)));
    });

    final femaleStream = Rx.combineLatest2(itemsRepo.femaleJumpersRepo.items,
        filtersRepo.femaleJumpersFilters, (items, filters) => (items, filters));
    _femaleJumperChangesSubscription = femaleStream.listen((event) {
      final jumpers = event.$1.toList();
      final filters = event.$2;
      emit(state.copyWith(femaleJumpers: Filter.filterAll(jumpers, filters)));
    });

    print('hills repo: ${itemsRepo.hillsRepo.items.value}');
    final hillsStream = Rx.combineLatest2(itemsRepo.hillsRepo.items,
        filtersRepo.hillsFilters, (items, filters) => (items, filters));
    _hillChangesSubscription = hillsStream.listen((event) {
      final hills = event.$1.toList();
      final filters = event.$2;
      emit(state.copyWith(hills: Filter.filterAll(hills, filters)));
    });
  }

  void dispose() {
    _maleJumperChangesSubscription.cancel();
    _femaleJumperChangesSubscription.cancel();
    _hillChangesSubscription.cancel();
  }

  static const LocalDbFilteredItemsState _initial =
      LocalDbFilteredItemsState(maleJumpers: [], femaleJumpers: [], hills: []);
}
