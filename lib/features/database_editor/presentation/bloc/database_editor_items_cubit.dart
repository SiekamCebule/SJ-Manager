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
import 'package:sj_manager/features/database_editor/domain/use_cases/items/save_database_editor_items_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/update_database_editor_item_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items_type/get_database_editor_items_type_use_case.dart';

class DatabaseEditorItemsCubit extends Cubit<DatabaseEditorItemsState> {
  DatabaseEditorItemsCubit({
    required this.addItemUseCase,
    required this.removeItemUseCase,
    required this.updateItemUseCase,
    required this.filterItemsUseCase,
    required this.moveItemUseCase,
    required this.saveItemsUseCase,
    required this.getItemsTypeUseCase,
    required this.getFiltersStreamUseCase,
  }) : super(const DatabaseEditorItemsInitial());

  late StreamSubscription<DatabaseEditorFilters> _filtersSubscription;

  final Map<DatabaseEditorItemsType, AddDatabaseEditorItemUseCase> addItemUseCase;
  final Map<DatabaseEditorItemsType, RemoveDatabaseEditorItemUseCase> removeItemUseCase;
  final Map<DatabaseEditorItemsType, UpdateDatabaseEditorItemUseCase> updateItemUseCase;
  final Map<DatabaseEditorItemsType, FilterDatabaseEditorItemsUseCase> filterItemsUseCase;
  final Map<DatabaseEditorItemsType, MoveDatabaseEditorItemUseCase> moveItemUseCase;
  final Map<DatabaseEditorItemsType, SaveDatabaseEditorItemsUseCase> saveItemsUseCase;
  final GetDatabaseEditorItemsTypeUseCase getItemsTypeUseCase;
  final GetDatabaseEditorFiltersStreamUseCase getFiltersStreamUseCase;

  Future<void> initialize() async {
    _filtersSubscription = (await getFiltersStreamUseCase()).listen((filters) async {
      final type = await getItemsTypeUseCase();
      final items = await filterItemsUseCase[type]!();
      emit(DatabaseEditorItemsInitialized(
        items: items,
      ));
    });
  }

  Future<void> addItem() async {
    if (state is DatabaseEditorItemsInitialized) {
      final type = await getItemsTypeUseCase();
      await addItemUseCase[type]!();
    } else {
      throw StateError(
        'Items can be added only when cubit\'s state is DatabaseEditorInitializedState',
      );
    }
  }

  Future<void> removeItem() async {
    if (state is DatabaseEditorItemsInitialized) {
      final type = await getItemsTypeUseCase();
      await removeItemUseCase[type]!();
    } else {
      throw StateError(
        'Items can be removed only when cubit\'s state is DatabaseEditorInitializedState',
      );
    }
  }

  Future<void> updateItem(dynamic item) async {
    if (state is DatabaseEditorItemsInitialized) {
      final type = await getItemsTypeUseCase();
      await updateItemUseCase[type]!(item);
    } else {
      throw StateError(
        'Items can be updated only when cubit\'s state is DatabaseEditorInitializedState',
      );
    }
  }

  Future<void> moveItem(int index, int targetIndex) async {
    if (state is DatabaseEditorItemsInitialized) {
      final type = await getItemsTypeUseCase();
      await moveItemUseCase[type]!(index, targetIndex);
    }
  }

  Future<void> saveItems() async {
    saveItemsUseCase.forEach(
      (itemsType, save) async => await save(),
    );
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
