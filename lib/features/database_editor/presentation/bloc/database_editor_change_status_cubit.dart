import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/change_status/get_database_editor_change_status_stream_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/change_status/mark_database_editor_as_changed_use_case.dart';

class DatabaseEditorChangeStatusCubit extends Cubit<DatabaseEditorChangeStatusState> {
  DatabaseEditorChangeStatusCubit({
    required this.getStream,
    required this.markAsChanged,
  }) : super(const DatabaseEditorChangeStatusNotChanged());

  Future<void> initialize() async {
    _subscription = (await getStream()).listen((changeStatus) {
      if (changeStatus == true) {
        emit(const DatabaseEditorChangeStatusChanged());
      } else {
        emit(const DatabaseEditorChangeStatusNotChanged());
      }
    });
  }

  late StreamSubscription _subscription;

  final GetDatabaseEditorChangeStatusStreamUseCase getStream;
  final MarkDatabaseEditorAsChangedUseCase markAsChanged;

  Future<void> markAsChanged() async {
    await markAsChanged();
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}

abstract class DatabaseEditorChangeStatusState extends Equatable {
  const DatabaseEditorChangeStatusState();

  @override
  List<Object?> get props => [];
}

class DatabaseEditorChangeStatusInitial extends DatabaseEditorChangeStatusState {
  const DatabaseEditorChangeStatusInitial();
}

class DatabaseEditorChangeStatusChanged extends DatabaseEditorChangeStatusState {
  const DatabaseEditorChangeStatusChanged();
}

class DatabaseEditorChangeStatusNotChanged extends DatabaseEditorChangeStatusState {
  const DatabaseEditorChangeStatusNotChanged();
}
