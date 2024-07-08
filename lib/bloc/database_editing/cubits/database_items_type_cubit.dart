import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/enums/database_item_type.dart';

class DatabaseItemsTypeCubit extends Cubit<DatabaseItemType> {
  DatabaseItemsTypeCubit() : super(DatabaseItemType.maleJumper);

  void select(DatabaseItemType type) {
    emit(type);
  }
}
