// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/enums/db_editable_item_type.dart';
import 'package:sj_manager/json/db_items_json.dart';

import 'package:sj_manager/models/db/country.dart';
import 'package:sj_manager/models/db/db_file_system_entity_names.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_items_json_configuration.dart';
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

  static Future<LocalDbRepo> fromDirectory(Directory dir,
      {required BuildContext context}) async {
    final dbFsEntityNames = context.read<DbFileSystemEntityNames>();
    File getFile(String fileName) => File('${dir.path}/$fileName');

    final maleJumpers = EditableDbItemsRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.maleJumpers),
      fromJson: context.read<DbItemsJsonConfiguration<MaleJumper>>().fromJson,
    ));
    if (!context.mounted) throw StateError('The context is unmounted');
    final femaleJumpers = EditableDbItemsRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.femaleJumpers),
      fromJson: context.read<DbItemsJsonConfiguration<FemaleJumper>>().fromJson,
    ));
    if (!context.mounted) throw StateError('The context is unmounted');
    final hills = EditableDbItemsRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.hills),
      fromJson: context.read<DbItemsJsonConfiguration<Hill>>().fromJson,
    ));
    if (!context.mounted) throw StateError('The context is unmounted');
    final countries = CountriesRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.countries),
      fromJson: context.read<DbItemsJsonConfiguration<Country>>().fromJson,
    ));
    return LocalDbRepo(
      maleJumpers: maleJumpers,
      femaleJumpers: femaleJumpers,
      hills: hills,
      countries: countries,
    );
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
