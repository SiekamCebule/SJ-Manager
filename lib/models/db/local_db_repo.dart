// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:sj_manager/enums/db_editable_item_type.dart';

import 'package:sj_manager/models/db/country.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repo.dart';
import 'package:sj_manager/repositories/database_editing/editable_db_items_repo.dart';

class LocalDbRepo with EquatableMixin {
  const LocalDbRepo({
    required this.maleJumpers,
    required this.femaleJumpers,
    required this.hills,
    required this.countries,
  });

  final EditableDbItemsRepo<MaleJumper> maleJumpers;
  final EditableDbItemsRepo<FemaleJumper> femaleJumpers;
  final EditableDbItemsRepo<Hill> hills;
  final CountriesRepo countries;

  EditableDbItemsRepo<dynamic> editableByType(DbEditableItemType type) {
    return switch (type) {
      DbEditableItemType.maleJumper => maleJumpers,
      DbEditableItemType.femaleJumper => femaleJumpers,
      DbEditableItemType.hill => hills,
    };
  }

  EditableDbItemsRepo<T> editableByGenericType<T>() {
    if (T == MaleJumper) return maleJumpers as EditableDbItemsRepo<T>;
    if (T == FemaleJumper) return femaleJumpers as EditableDbItemsRepo<T>;
    if (T == Hill) return hills as EditableDbItemsRepo<T>;
    throw ArgumentError('Invalid type (Type: $T)');
  }

  DbItemsRepo<T> byType<T>() {
    if (T == MaleJumper) return maleJumpers as DbItemsRepo<T>;
    if (T == FemaleJumper) return femaleJumpers as DbItemsRepo<T>;
    if (T == Hill) return hills as DbItemsRepo<T>;
    if (T == Country) return countries as DbItemsRepo<T>;
    throw ArgumentError('Invalid type');
  }

  LocalDbRepo copyWith({
    EditableDbItemsRepo<MaleJumper>? maleJumpers,
    EditableDbItemsRepo<FemaleJumper>? femaleJumpers,
    EditableDbItemsRepo<Hill>? hills,
    CountriesRepo? countries,
  }) {
    return LocalDbRepo(
      maleJumpers: maleJumpers ?? this.maleJumpers,
      femaleJumpers: femaleJumpers ?? this.femaleJumpers,
      hills: hills ?? this.hills,
      countries: countries ?? this.countries,
    );
  }

  @override
  List<Object?> get props => [
        maleJumpers,
        femaleJumpers,
        hills,
        countries,
      ];
}
