import 'package:equatable/equatable.dart';
import 'package:sj_manager/enums/db_editable_item_type.dart';
import 'package:sj_manager/models/db/hill/hill.dart';

import 'package:sj_manager/models/db/jumper/jumper.dart';

class LocalDbFilteredItemsState extends Equatable {
  const LocalDbFilteredItemsState({
    required this.maleJumpers,
    required this.femaleJumpers,
    required this.hills,
  });

  final List<MaleJumper> maleJumpers;
  final List<FemaleJumper> femaleJumpers;
  final List<Hill> hills;

  List<dynamic> byType(DbEditableItemType type) {
    return switch (type) {
      DbEditableItemType.maleJumper => maleJumpers,
      DbEditableItemType.femaleJumper => femaleJumpers,
      DbEditableItemType.hill => hills,
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
