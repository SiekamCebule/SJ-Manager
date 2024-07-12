import 'package:equatable/equatable.dart';
import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';

class LocalDbReposRepo with EquatableMixin {
  const LocalDbReposRepo({
    required this.maleJumpersRepo,
    required this.femaleJumpersRepo,
    required this.hillsRepo,
  });

  final DbItemsRepo<Jumper> maleJumpersRepo;
  final DbItemsRepo<Jumper> femaleJumpersRepo;
  final DbItemsRepo<Hill> hillsRepo;

  DbItemsRepo<dynamic> byType<T>(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => maleJumpersRepo,
      DatabaseItemType.femaleJumper => femaleJumpersRepo,
      DatabaseItemType.hill => hillsRepo,
    };
  }

  DbItemsRepo<T> byGenericType<T>() {
    if (T == MaleJumper) return maleJumpersRepo as DbItemsRepo<T>;
    if (T == FemaleJumper) return femaleJumpersRepo as DbItemsRepo<T>;
    if (T == Hill) return hillsRepo as DbItemsRepo<T>;
    throw ArgumentError('Invalid type');
  }

  LocalDbReposRepo copyWith(
    DbItemsRepo<Jumper>? maleJumpersRepo,
    DbItemsRepo<Jumper>? femaleJumpersRepo,
    DbItemsRepo<Hill>? hillsRepo,
  ) {
    return LocalDbReposRepo(
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
