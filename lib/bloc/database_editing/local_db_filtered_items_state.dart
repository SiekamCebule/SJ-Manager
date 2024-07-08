import 'package:equatable/equatable.dart';
import 'package:sj_manager/enums/database_item_type.dart';

import 'package:sj_manager/models/jumper.dart';

class LocalDbFilteredItemsState extends Equatable {
  const LocalDbFilteredItemsState({
    required this.maleJumpers,
    required this.femaleJumpers,
  });

  final List<Jumper> maleJumpers;
  final List<Jumper> femaleJumpers;

  List<dynamic> byType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => maleJumpers,
      DatabaseItemType.femaleJumper => femaleJumpers,
    };
  }

  LocalDbFilteredItemsState copyWith({
    List<Jumper>? maleJumpers,
    List<Jumper>? femaleJumpers,
  }) {
    return LocalDbFilteredItemsState(
      maleJumpers: maleJumpers ?? this.maleJumpers,
      femaleJumpers: femaleJumpers ?? this.femaleJumpers,
    );
  }

  @override
  List<Object?> get props => [
        maleJumpers,
        femaleJumpers,
      ];
}
