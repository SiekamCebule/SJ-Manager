import 'package:sj_manager/enums/db_editable_item_type.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';

class DefaultItemsRepo {
  DefaultItemsRepo({
    required this.defaultFemaleJumper,
    required this.defaultMaleJumper,
    required this.defaultHill,
  });

  final MaleJumper defaultMaleJumper;
  final FemaleJumper defaultFemaleJumper;
  final Hill defaultHill;

  dynamic byDatabaseItemType(DbEditableItemType type) {
    return switch (type) {
      DbEditableItemType.maleJumper => defaultMaleJumper,
      DbEditableItemType.femaleJumper => defaultFemaleJumper,
      DbEditableItemType.hill => defaultHill,
    };
  }
}
