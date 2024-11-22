import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items_type/get_database_editor_items_type_stream_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items_type/set_database_editor_items_type_by_index_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items_type/set_database_editor_items_type_use_case.dart';

class DatabaseEditorItemsTypeCubit extends Cubit<DatabaseEditorItemsTypeState> {
  DatabaseEditorItemsTypeCubit({
    required this.getStreamUseCase,
    required this.setItemsTypeUseCase,
    required this.setItemsTypeByIndexUseCase,
  }) : super(initial);

  static const initial = DatabaseEditorItemsTypeState(
    type: DatabaseEditorItemsType.maleJumper,
  );

  late StreamSubscription<DatabaseEditorItemsType> _subscription;

  final GetDatabaseEditorItemsTypeStreamUseCase getStreamUseCase;
  final SetDatabaseEditorItemsTypeUseCase setItemsTypeUseCase;
  final SetDatabaseEditorItemsTypeByIndexUseCase setItemsTypeByIndexUseCase;

  Future<void> initialize() async {
    _subscription = (await getStreamUseCase()).listen((type) {
      emit(DatabaseEditorItemsTypeState(type: type));
    });
  }

  Future<void> set(DatabaseEditorItemsType type) async {
    await setItemsTypeUseCase(type);
  }

  Future<void> setByIndex(int index) async {
    await setItemsTypeByIndexUseCase(index);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}

class DatabaseEditorItemsTypeState extends Equatable {
  const DatabaseEditorItemsTypeState({
    required this.type,
  });

  final DatabaseEditorItemsType type;

  @override
  List<Object?> get props => [type];
}
