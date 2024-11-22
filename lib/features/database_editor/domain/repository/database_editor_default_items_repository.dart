import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';

abstract interface class DatabaseEditorDefaultItemsRepository {
  Future<dynamic> get(DatabaseEditorItemsType type);
}
