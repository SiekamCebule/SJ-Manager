import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/enums/db_editable_item_type.dart';

class DatabaseItemsTypeCubit extends Cubit<DbEditableItemType> {
  DatabaseItemsTypeCubit() : super(DbEditableItemType.maleJumper);

  void select(DbEditableItemType type) {
    emit(type);
  }
}
