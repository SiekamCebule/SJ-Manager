import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/db_editor_selection_clear_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/db_editor_selection_select_only_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/db_editor_selection_select_range_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/db_editor_selection_toggle_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/get_database_editor_selection_stream_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/get_db_editor_selection_use_case.dart';

class DatabaseEditorSelectionCubit extends Cubit<DatabaseEditorSelectionState> {
  DatabaseEditorSelectionCubit({
    required this.getStream,
    required this.getSelection,
    required this.selectOnly,
    required this.toggle,
    required this.selectRange,
    required this.clear,
  }) : super(initial);

  static const initial = DatabaseEditorSelectionState(selection: {});

  late StreamSubscription _selectionSubscription;

  final GetDatabaseEditorSelectionStreamUseCase getStream;
  final GetDbEditorSelectionUseCase getSelection;
  final DbEditorSelectionSelectOnlyUseCase selectOnly;
  final DbEditorSelectionToggleUseCase toggle;
  final DbEditorSelectionSelectRangeUseCase selectRange;
  final DbEditorSelectionClearUseCase clear;

  Future<void> initialize() async {
    _selectionSubscription = (await getStream()).listen((selection) {
      emit(DatabaseEditorSelectionState(selection: selection));
    });
  }

  /// Click
  Future<void> selectOnly(int index) async {
    await selectOnly(index);
  }

  /// Ctrl + click
  Future<void> toggle(int index) async {
    await toggle(index);
  }

  /// Shift + click
  Future<void> selectRange(int start, int end) async {
    await selectRange(start, end);
  }

  Future<void> clear() async {
    await clear();
  }

  @override
  Future<void> close() async {
    await _selectionSubscription.cancel();
    return super.close();
  }
}

class DatabaseEditorSelectionState extends Equatable {
  const DatabaseEditorSelectionState({
    required this.selection,
  });

  final Set<int> selection;

  @override
  List<Object?> get props => [selection];
}
