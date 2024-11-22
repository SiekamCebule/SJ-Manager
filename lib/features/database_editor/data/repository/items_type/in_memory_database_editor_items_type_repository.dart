import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';

class InMemoryDatabaseEditorItemsTypeRepository
    implements DatabaseEditorItemsTypeRepository {
  InMemoryDatabaseEditorItemsTypeRepository({
    required DatabaseEditorItemsType initial,
  }) : _current = initial;

  DatabaseEditorItemsType _current;
  final _streamController = PublishSubject<DatabaseEditorItemsType>();

  @override
  Future<DatabaseEditorItemsType> get() async {
    return _current;
  }

  @override
  Future<void> set(DatabaseEditorItemsType type) async {
    _current = type;
    _streamController.add(_current);
  }

  @override
  Future<void> setByIndex(int index) async {
    _current = sjmDatabaseEditorItemsTypeOrder[index];
    _updateStream();
  }

  void _updateStream() => _streamController.add(_current);

  @override
  Future<Stream<DatabaseEditorItemsType>> get stream async => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}
