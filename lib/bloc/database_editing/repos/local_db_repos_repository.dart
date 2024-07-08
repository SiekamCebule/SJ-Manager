import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/models/jumper.dart';
import 'package:sj_manager/repositories/database_items/database_items_repository.dart';

class LocalDbReposRepository {
  LocalDbReposRepository({
    required this.maleJumpersRepo,
    required this.femaleJumpersRepo,
  });

  final DatabaseItemsRepository<Jumper> maleJumpersRepo;
  final DatabaseItemsRepository<Jumper> femaleJumpersRepo;

  DatabaseItemsRepository<dynamic> byType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => maleJumpersRepo,
      DatabaseItemType.femaleJumper => femaleJumpersRepo,
    };
  }

  LocalDbReposRepository copyWith(
    DatabaseItemsRepository<Jumper>? maleJumpersRepo,
    DatabaseItemsRepository<Jumper>? femaleJumpersRepo,
  ) {
    return LocalDbReposRepository(
      maleJumpersRepo: maleJumpersRepo ?? this.maleJumpersRepo,
      femaleJumpersRepo: femaleJumpersRepo ?? this.femaleJumpersRepo,
    );
  }
}
