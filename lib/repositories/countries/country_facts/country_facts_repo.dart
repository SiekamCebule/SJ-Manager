import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/db/country/country_facts.dart';
import 'package:sj_manager/models/db/db_file_system_entity_names.dart';
import 'package:sj_manager/repositories/generic/db_items_repo.dart';

class MaleCountryFactsRepo extends DbItemsRepo<MaleCountryFacts> {
  MaleCountryFactsRepo({super.initial});

  static Future<MaleCountryFactsRepo> fromDirectory(Directory dir,
      {required BuildContext context}) async {
    final dbFsEntityNames = context.read<DbFileSystemEntityNames>();
    final countryFactsFile = File('${dir.path}/${dbFsEntityNames.maleCountryFacts}');
    final items = await loadItemsListFromJsonFile(
        file: countryFactsFile, fromJson: MaleCountryFacts.fromJson);

    return MaleCountryFactsRepo(initial: items);
  }
}

class FemaleCountryFactsRepo extends DbItemsRepo<FemaleCountryFacts> {
  FemaleCountryFactsRepo({super.initial});

  static Future<FemaleCountryFactsRepo> fromDirectory(Directory dir,
      {required BuildContext context}) async {
    final dbFsEntityNames = context.read<DbFileSystemEntityNames>();
    final countryFactsFile = File('${dir.path}/${dbFsEntityNames.femaleCountryFacts}');
    final items = await loadItemsListFromJsonFile(
        file: countryFactsFile, fromJson: FemaleCountryFacts.fromJson);

    return FemaleCountryFactsRepo(initial: items);
  }
}
