import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/entities/filtering/database_editor_filters.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/get_database_editor_filters_stream_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/add_database_editor_item_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/filter_database_editor_items_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/move_database_editor_item_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/remove_database_editor_item_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/update_database_editor_item_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items_type/get_database_editor_items_type_use_case.dart';

class DatabaseEditorItemsCubit extends Cubit<DatabaseEditorItemsState> {
  DatabaseEditorItemsCubit({
    required this.addItemUseCase,
    required this.removeItemUseCase,
    required this.updateItem,
    required this.filterItems,
    required this.moveItem,
    required this.getItemsType,
    required this.getFiltersStream,
  }) : super(const DatabaseEditorItemsInitial());

  late StreamSubscription<DatabaseEditorFilters> _filtersSubscription;

  final Map<DatabaseEditorItemsType, AddDatabaseEditorItemUseCase> addItemUseCase;
  final Map<DatabaseEditorItemsType, RemoveDatabaseEditorItemUseCase> removeItemUseCase;
  final Map<DatabaseEditorItemsType, UpdateDatabaseEditorItemUseCase> updateItem;
  final Map<DatabaseEditorItemsType, FilterDatabaseEditorItemsUseCase> filterItems;
  final Map<DatabaseEditorItemsType, MoveDatabaseEditorItemUseCase> moveItem;
  final GetDatabaseEditorItemsTypeUseCase getItemsType;
  final GetDatabaseEditorFiltersStreamUseCase getFiltersStream;

  Future<void> initialize() async {
    _filtersSubscription = (await getFiltersStream()).listen((filters) async {
      final type = await getItemsType();
      final items = await filterItems[type]!();
      emit(DatabaseEditorItemsInitialized(
        items: items,
      ));
    });
  }

  Future<void> add() async {
    if (state is DatabaseEditorItemsInitialized) {
      final type = await getItemsType();
      await addItemUseCase[type]!();
    } else {
      throw StateError(
        'Items can be added only when cubit\'s state is DatabaseEditorInitializedState',
      );
    }
  }

  Future<void> remove() async {
    if (state is DatabaseEditorItemsInitialized) {
      final type = await getItemsType();
      await removeItemUseCase[type]!();
    } else {
      throw StateError(
        'Items can be removed only when cubit\'s state is DatabaseEditorInitializedState',
      );
    }
  }

  Future<void> update(dynamic item) async {
    if (state is DatabaseEditorItemsInitialized) {
      final type = await getItemsType();
      await updateItem[type]!(item);
    } else {
      throw StateError(
        'Items can be updated only when cubit\'s state is DatabaseEditorInitializedState',
      );
    }
  }

  Future<void> move(int index, int targetIndex) async {
    if (state is DatabaseEditorItemsInitialized) {
      final type = await getItemsType();
      await moveItem[type]!(index, targetIndex);
    }
  }

  @override
  Future<void> close() async {
    await _filtersSubscription.cancel();
    return super.close();
  }
}

abstract class DatabaseEditorItemsState extends Equatable {
  const DatabaseEditorItemsState();

  @override
  List<Object?> get props => [];
}

class DatabaseEditorItemsInitial extends DatabaseEditorItemsState {
  const DatabaseEditorItemsInitial();
}

class DatabaseEditorItemsSwitchingType extends DatabaseEditorItemsState {
  const DatabaseEditorItemsSwitchingType();
}

class DatabaseEditorItemsInitialized extends DatabaseEditorItemsState {
  const DatabaseEditorItemsInitialized({
    required this.items,
  });

  final List<dynamic> items;
}
