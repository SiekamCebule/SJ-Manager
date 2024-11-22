import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_change_status_repository.dart';

class InMemoryDatabaseEditorChangeStatusRepository
    implements DatabaseEditorChangeStatusRepository {
  InMemoryDatabaseEditorChangeStatusRepository({
    bool initial = false,
  }) : _isChanged = initial;

  var _isChanged = false;
  final _streamController = PublishSubject<bool>();

  @override
  Future<void> markAsChanged() async {
    _isChanged = true;
    _streamController.add(_isChanged);
  }

  @override
  Future<bool> get isChanged async => _isChanged;

  @override
  Future<Stream<bool>> get stream async => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}
