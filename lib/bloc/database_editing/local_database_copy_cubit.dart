import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class LocalDatabaseCopyCubit extends Cubit<ItemsReposRegistry?> {
  LocalDatabaseCopyCubit({
    required this.gameVariant,
    required this.gameVariantsRepo,
    required this.idsRepo,
  }) : super(null);

  final GameVariant gameVariant;
  final ItemsRepo<GameVariant> gameVariantsRepo;
  final ItemsIdsRepo idsRepo;

  Future<void> setUp() async {
    emit(
      ItemsReposRegistry(initial: {
        CountriesRepo(initial: gameVariant.countries.toList()),
        TeamsRepo(initial: gameVariant.teams.toList()),
        EditableItemsRepo<MaleJumper>(
            initial: gameVariant.jumpers.whereType<MaleJumper>().toList()),
        EditableItemsRepo<FemaleJumper>(
            initial: gameVariant.jumpers.whereType<FemaleJumper>().toList()),
        ItemsRepo<Hill>(initial: gameVariant.hills.toList()),
      }),
    );
  }

  Future<void> saveChangesToGameVariant(BuildContext context) async {
    final newVariant = gameVariant.copyWith(
      jumpers: state!.get<Jumper>().last.toList(),
      countries: state!.get<Country>().last.toList(),
      teams: state!.get<Team>().last.toList(),
      hills: state!.get<Hill>().last.toList(),
    );
    gameVariantsRepo.set(gameVariantsRepo.last.map((variant) {
      return variant.id == newVariant.id ? newVariant : variant;
    }));
    // TODO: Save to file
  }

  Future<void> loadExternal(BuildContext context, Directory directory) async {
    emit(await ItemsReposRegistry.fromDirectory(
      directory,
      context: context,
    ));
  }

  void dispose() {
    state?.dispose();
  }
}
