import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';
import 'package:sj_manager/utilities/extensions/set_toggle.dart';

class InMemoryDatabaseEditorSelectionRepository
    implements DatabaseEditorSelectionRepository {
  InMemoryDatabaseEditorSelectionRepository({
    Set<int>? initial,
  }) : _selection = Set.of(initial ?? {});

  Set<int> _selection;
  final _streamController = PublishSubject<Set<int>>();

  @override
  Future<void> clear() async {
    _selection = {};
    _updateStream();
  }

  @override
  Future<void> deselect(int index) async {
    _selection = Set.of(_selection)..remove(index);
    _updateStream();
  }

  @override
  Future<void> toggle(int index) async {
    _selection = Set.of(_selection)..toggle(index);
    _updateStream();
  }

  @override
  Future<void> selectOnly(int index) async {
    _selection = {index};
    _updateStream();
  }

  @override
  Future<void> selectRange(int start, int end) async {
    _selection = {for (var index = start; index < end; index++) index};
    _updateStream();
  }

  void _updateStream() => _streamController.add(_selection);

  @override
  Future<Set<int>> getSelection() async => _selection;
  @override
  Future<Stream<Set<int>>> get stream async => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}
