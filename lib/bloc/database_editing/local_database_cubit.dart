import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/game_variants/game_variants_io_utils.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class LocalDatabaseCubit extends Cubit<ItemsReposRegistry?> {
  LocalDatabaseCubit({
    required this.gameVariant,
    required this.gameVariantsRepo,
  }) : super(null);

  final GameVariant gameVariant;
  final ItemsRepo<GameVariant> gameVariantsRepo;

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
      jumpers: [
        ...state!.get<MaleJumper>().last,
        ...state!.get<FemaleJumper>().last,
      ],
      countries: state!.get<Country>().last.toList(),
      teams: state!.get<Team>().last.toList(),
      hills: state!.get<Hill>().last.toList(),
    );
    gameVariantsRepo.set(gameVariantsRepo.last.map((variant) {
      return variant.id == newVariant.id ? newVariant : variant;
    }));
    await _saveNewGameVariantToFiles(newVariant: newVariant, context: context);
  }

  Future<void> _saveNewGameVariantToFiles({
    required GameVariant newVariant,
    required BuildContext context,
  }) async {
    await saveGameVariantItems<MaleJumper>(
      items: newVariant.jumpers.whereType<MaleJumper>().toList(),
      context: context,
      toJson: context.read<DbItemsJsonConfiguration<MaleJumper>>().toJson,
      gameVariantId: newVariant.id,
    );
    if (!context.mounted) return;
    await saveGameVariantItems<FemaleJumper>(
      items: newVariant.jumpers.whereType<FemaleJumper>().toList(),
      context: context,
      toJson: context.read<DbItemsJsonConfiguration<FemaleJumper>>().toJson,
      gameVariantId: newVariant.id,
    );
  }

  void dispose() {
    state?.dispose();
  }
}
