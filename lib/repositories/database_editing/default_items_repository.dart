import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';

class DefaultItemsRepository {
  DefaultItemsRepository({
    required this.defaultFemaleJumper,
    required this.defaultMaleJumper,
    required this.defaultHill,
  });

  final MaleJumper defaultMaleJumper;
  final FemaleJumper defaultFemaleJumper;
  final Hill defaultHill;

  dynamic byDatabaseItemType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => defaultMaleJumper,
      DatabaseItemType.femaleJumper => defaultFemaleJumper,
      DatabaseItemType.hill => defaultHill,
    };
  }
}
