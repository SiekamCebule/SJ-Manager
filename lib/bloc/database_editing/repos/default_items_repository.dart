import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/models/jumper.dart';

class DefaultItemsRepository {
  DefaultItemsRepository({
    required this.defaultFemaleJumper,
    required this.defaultMaleJumper,
  });

  final MaleJumper defaultMaleJumper;
  final FemaleJumper defaultFemaleJumper;

  dynamic byDatabaseItemType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => defaultMaleJumper,
      DatabaseItemType.femaleJumper => defaultFemaleJumper,
    };
  }
}
