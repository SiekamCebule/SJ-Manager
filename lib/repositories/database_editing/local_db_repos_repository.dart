import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/database_items_repository.dart';

class LocalDbReposRepository {
  LocalDbReposRepository({
    required this.maleJumpersRepo,
    required this.femaleJumpersRepo,
    required this.hillsRepo,
  });

  final DatabaseItemsRepository<Jumper> maleJumpersRepo;
  final DatabaseItemsRepository<Jumper> femaleJumpersRepo;
  final DatabaseItemsRepository<Hill> hillsRepo;

  DatabaseItemsRepository<dynamic> byType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => maleJumpersRepo,
      DatabaseItemType.femaleJumper => femaleJumpersRepo,
      DatabaseItemType.hill => hillsRepo,
    };
  }

  LocalDbReposRepository copyWith(
    DatabaseItemsRepository<Jumper>? maleJumpersRepo,
    DatabaseItemsRepository<Jumper>? femaleJumpersRepo,
    DatabaseItemsRepository<Hill>? hillsRepo,
  ) {
    return LocalDbReposRepository(
      maleJumpersRepo: maleJumpersRepo ?? this.maleJumpersRepo,
      femaleJumpersRepo: femaleJumpersRepo ?? this.femaleJumpersRepo,
      hillsRepo: hillsRepo ?? this.hillsRepo,
    );
  }
}
