import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';

abstract interface class DatabaseEditorItemsTypeRepository {
  Future<DatabaseEditorItemsType> get();
  Future<void> set(DatabaseEditorItemsType type);
  Future<void> setByIndex(int index);
  Future<Stream<DatabaseEditorItemsType>> get stream;
}
