import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/bloc/database_editing/local_db_filtered_items_state.dart';
import 'package:sj_manager/bloc/database_editing/repos/db_filters_repository.dart';
import 'package:sj_manager/bloc/database_editing/repos/local_db_repos_repository.dart';
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

  late final StreamSubscription _maleJumpersSubscription;
  late final StreamSubscription _femaleJumpersSubscription;
  late final StreamSubscription _itemsSubscription;

  void _setUp() {
    final maleStream = Rx.combineLatest2(itemsRepo.maleJumpersRepo.items,
        filtersRepo.maleJumpersFilters, (items, filters) => (items, filters));
    _maleJumpersSubscription = maleStream.listen((event) {
      final jumpers = event.$1.toList();
      final filters = event.$2;
      emit(state.copyWith(maleJumpers: Filter.filterAll(jumpers, filters)));
    });

    final femaleStream = Rx.combineLatest2(itemsRepo.femaleJumpersRepo.items,
        filtersRepo.femaleJumpersFilters, (items, filters) => (items, filters));
    _femaleJumpersSubscription = femaleStream.listen((event) {
      final jumpers = event.$1.toList();
      final filters = event.$2;
      emit(state.copyWith(femaleJumpers: Filter.filterAll(jumpers, filters)));
    });
  }

  void dispose() {
    _maleJumpersSubscription.cancel();
    _femaleJumpersSubscription.cancel();
    _itemsSubscription.cancel();
  }

  static const LocalDbFilteredItemsState _initial = LocalDbFilteredItemsState(
    maleJumpers: [],
    femaleJumpers: [],
  );
}
