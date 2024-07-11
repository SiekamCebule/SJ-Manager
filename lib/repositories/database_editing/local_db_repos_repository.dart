import 'package:equatable/equatable.dart';
import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';

class LocalDbReposRepository with EquatableMixin {
  const LocalDbReposRepository({
    required this.maleJumpersRepo,
    required this.femaleJumpersRepo,
    required this.hillsRepo,
  });

  final DbItemsRepository<Jumper> maleJumpersRepo;
  final DbItemsRepository<Jumper> femaleJumpersRepo;
  final DbItemsRepository<Hill> hillsRepo;

  DbItemsRepository<dynamic> byType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => maleJumpersRepo,
      DatabaseItemType.femaleJumper => femaleJumpersRepo,
      DatabaseItemType.hill => hillsRepo,
    };
  }

  LocalDbReposRepository copyWith(
    DbItemsRepository<Jumper>? maleJumpersRepo,
    DbItemsRepository<Jumper>? femaleJumpersRepo,
    DbItemsRepository<Hill>? hillsRepo,
  ) {
    return LocalDbReposRepository(
      maleJumpersRepo: maleJumpersRepo ?? this.maleJumpersRepo,
      femaleJumpersRepo: femaleJumpersRepo ?? this.femaleJumpersRepo,
      hillsRepo: hillsRepo ?? this.hillsRepo,
    );
  }

  @override
  List<Object?> get props => [
        maleJumpersRepo,
        femaleJumpersRepo,
        hillsRepo,
      ];
}
