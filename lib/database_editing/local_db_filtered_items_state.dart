import 'package:equatable/equatable.dart';
import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/models/hill/hill.dart';

import 'package:sj_manager/models/jumper/jumper.dart';

class LocalDbFilteredItemsState extends Equatable {
  const LocalDbFilteredItemsState({
    required this.maleJumpers,
    required this.femaleJumpers,
    required this.hills,
  });

  final List<MaleJumper> maleJumpers;
  final List<FemaleJumper> femaleJumpers;
  final List<Hill> hills;

  List<dynamic> byType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => maleJumpers,
      DatabaseItemType.femaleJumper => femaleJumpers,
      DatabaseItemType.hill => hills,
    };
  }

  LocalDbFilteredItemsState copyWith({
    List<MaleJumper>? maleJumpers,
    List<FemaleJumper>? femaleJumpers,
    List<Hill>? hills,
  }) {
    return LocalDbFilteredItemsState(
      maleJumpers: maleJumpers ?? this.maleJumpers,
      femaleJumpers: femaleJumpers ?? this.femaleJumpers,
      hills: hills ?? this.hills,
    );
  }

  @override
  List<Object?> get props => [
        maleJumpers,
        femaleJumpers,
        hills,
      ];
}
