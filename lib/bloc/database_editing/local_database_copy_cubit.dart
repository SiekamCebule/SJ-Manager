import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/file_system.dart';

import 'package:path/path.dart' as path;

class LocalDatabaseCopyCubit extends Cubit<ItemsReposRegistry?> {
  LocalDatabaseCopyCubit({
    required this.originalDb,
    required this.idsRepo,
  }) : super(null);

  ItemsReposRegistry originalDb;
  final ItemsIdsRepo idsRepo;

  Future<void> setUp() async {
    emit(
      originalDb.clone(),
    );
  }

  Future<void> saveChangesToOriginalRepos(BuildContext context) async {
    final reposMayChange = state!.last.whereType<EditableItemsRepo>();
    for (var repo in reposMayChange) {
      final itemsType = repo.itemsType;
      originalDb.byTypeArgument(itemsType).set(repo.last);
      if (!context.mounted) return;
      final file = databaseFile(context.read(),
          context.read<DbItemsFilePathsRegistry>().byTypeArgument(itemsType));
      await _saveItemsToJsonByTypeArgument(itemsType, context: context, file: file);
    }
  }

  Future<void> _saveItemsToJsonByTypeArgument(Type type,
      {required BuildContext context, required File file}) async {
    if (type == MaleJumper) {
      await _saveItemsToJsonByType<MaleJumper>(
        file: file,
        context: context,
      );
    } else if (type == FemaleJumper) {
      await _saveItemsToJsonByType<FemaleJumper>(
        file: file,
        context: context,
      );
    } else if (type == Hill) {
      await _saveItemsToJsonByType<Hill>(
        file: file,
        context: context,
      );
    } else if (type == EventSeriesSetup) {
      await _saveItemsToJsonByType<EventSeriesSetup>(
        file: file,
        context: context,
      );
    } else if (type == EventSeriesCalendarPreset) {
      await _saveItemsToJsonByType<EventSeriesCalendarPreset>(
        file: file,
        context: context,
      );
    } else if (type == DefaultCompetitionRulesPreset) {
      await _saveItemsToJsonByType<DefaultCompetitionRulesPreset>(
        file: file,
        context: context,
      );
    }
  }

  Future<void> _saveItemsToJsonByType<T>({
    required BuildContext context,
    required File file,
  }) async {
    await saveItemsMapToJsonFile(
      file: file,
      items: originalDb.get<T>().last.toList(),
      toJson: context.read<DbItemsJsonConfiguration<T>>().toJson,
      idsRepo: idsRepo,
    );
  }

  Future<void> saveAs(BuildContext context, Directory directory) async {
    for (var repo in state!.last) {
      if (!context.mounted) return;
      final fileName = path.basename(
          context.read<DbItemsFilePathsRegistry>().byTypeArgument(repo.runtimeType));
      final file = fileInDirectory(directory, fileName);
      await _saveItemsToJsonByTypeArgument(repo.runtimeType,
          context: context, file: file);
    }
  }

  Future<void> loadExternal(BuildContext context, Directory directory) async {
    emit(await ItemsReposRegistry.fromDirectory(
      directory,
      context: context,
    ));
  }

  void dispose() {
    originalDb.dispose();
    state?.dispose();
  }
}
