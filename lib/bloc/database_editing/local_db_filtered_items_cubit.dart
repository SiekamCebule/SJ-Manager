import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/database_editing/local_db_filtered_items_state.dart';
import 'package:sj_manager/bloc/database_editing/repos/filters_repository.dart';
import 'package:sj_manager/bloc/database_editing/repos/local_db_repos_repository.dart';
import 'package:sj_manager/filters/filter.dart';

class LocalDbFilteredItemsCubit extends Cubit<LocalDbFilteredItemsState> {
  LocalDbFilteredItemsCubit({
    required this.filtersRepo,
    required this.editableItemsRepo,
  }) : super(_initial) {
    _setUp();
  }

  final FiltersRepository filtersRepo;
  final LocalDbReposRepository editableItemsRepo;

  late final StreamSubscription _maleFiltersSubscription;
  late final StreamSubscription _femaleFiltersSubscription;
  late final StreamSubscription _itemsSubscription;

  void _setUp() {
    _maleFiltersSubscription = filtersRepo.maleJumpersFilters.listen((filters) async {
      final maleJumpers = editableItemsRepo.maleJumpersRepo.items.value.toList();
      emit(state.copyWith(
        maleJumpers: Filter.filterAll(maleJumpers, filters),
      ));
    });
    _femaleFiltersSubscription = filtersRepo.femaleJumpersFilters.listen((filters) {
      final femaleJumpers = editableItemsRepo.femaleJumpersRepo.items.value.toList();
      emit(state.copyWith(
        femaleJumpers: Filter.filterAll(femaleJumpers, filters),
      ));
    });
  }

  void dispose() {
    _maleFiltersSubscription.cancel();
    _femaleFiltersSubscription.cancel();
    _itemsSubscription.cancel();
  }

  static const LocalDbFilteredItemsState _initial = LocalDbFilteredItemsState(
    maleJumpers: [],
    femaleJumpers: [],
  );
}
