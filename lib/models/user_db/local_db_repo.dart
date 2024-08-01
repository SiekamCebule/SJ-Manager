// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/enums/db_editable_item_type.dart';
import 'package:sj_manager/json/db_items_json.dart';

import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/db_file_system_entity_names.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';

class LocalDbRepo with EquatableMixin {
  const LocalDbRepo({
    required this.maleJumpers,
    required this.femaleJumpers,
    required this.hills,
    required this.countries,
    required this.teams,
  });

  final EditableItemsRepo<MaleJumper> maleJumpers;
  final EditableItemsRepo<FemaleJumper> femaleJumpers;
  final EditableItemsRepo<Hill> hills;
  final CountriesRepo countries;
  final TeamsRepo<Team> teams;

  EditableItemsRepo<dynamic> editableByType(DbEditableItemType type) {
    return switch (type) {
      DbEditableItemType.maleJumper => maleJumpers,
      DbEditableItemType.femaleJumper => femaleJumpers,
      DbEditableItemType.hill => hills,
    };
  }

  EditableItemsRepo<T> editableByGenericType<T>() {
    if (T == MaleJumper) return maleJumpers as EditableItemsRepo<T>;
    if (T == FemaleJumper) return femaleJumpers as EditableItemsRepo<T>;
    if (T == Hill) return hills as EditableItemsRepo<T>;
    throw ArgumentError('Invalid type (Type: $T)');
  }

  ItemsRepo<T> byType<T>() {
    if (T == MaleJumper) return maleJumpers as ItemsRepo<T>;
    if (T == FemaleJumper) return femaleJumpers as ItemsRepo<T>;
    if (T == Hill) return hills as ItemsRepo<T>;
    if (T == Country) return countries as ItemsRepo<T>;
    if (T == Team) return teams as ItemsRepo<T>;
    throw ArgumentError('Invalid type');
  }

  static Future<LocalDbRepo> fromDirectory(Directory dir,
      {required BuildContext context}) async {
    final dbFsEntityNames = context.read<DbFileSystemEntityNames>();
    File getFile(String fileName) => File('${dir.path}/$fileName');

    final maleJumpers = EditableItemsRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.maleJumpers),
      fromJson: context.read<DbItemsJsonConfiguration<MaleJumper>>().fromJson,
    ));
    if (!context.mounted) throw StateError('The context is unmounted');
    final femaleJumpers = EditableItemsRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.femaleJumpers),
      fromJson: context.read<DbItemsJsonConfiguration<FemaleJumper>>().fromJson,
    ));
    if (!context.mounted) throw StateError('The context is unmounted');
    final hills = EditableItemsRepo(
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
    if (!context.mounted) throw StateError('The context is unmounted');
    final teams = await TeamsRepo.fromDirectory(
      dir,
      context: context,
      fromJson: context.read<DbItemsJsonConfiguration<Team>>().fromJson,
    );
    return LocalDbRepo(
      maleJumpers: maleJumpers,
      femaleJumpers: femaleJumpers,
      hills: hills,
      countries: countries,
      teams: TeamsRepo<Team>(initial: teams.last.cast()),
    );
  }

  LocalDbRepo copyWith({
    EditableItemsRepo<MaleJumper>? maleJumpers,
    EditableItemsRepo<FemaleJumper>? femaleJumpers,
    EditableItemsRepo<Hill>? hills,
    CountriesRepo? countries,
    TeamsRepo<Team>? teams,
  }) {
    return LocalDbRepo(
      maleJumpers: maleJumpers ?? this.maleJumpers,
      femaleJumpers: femaleJumpers ?? this.femaleJumpers,
      hills: hills ?? this.hills,
      countries: countries ?? this.countries,
      teams: teams ?? this.teams,
    );
  }

  @override
  List<Object?> get props => [
        maleJumpers,
        femaleJumpers,
        hills,
        countries,
      ];

  void dispose() {
    print('LocalDbRepo dispose()');
    maleJumpers.dispose();
    femaleJumpers.dispose();
    hills.dispose();
    countries.dispose();
    teams.dispose();
  }
}
