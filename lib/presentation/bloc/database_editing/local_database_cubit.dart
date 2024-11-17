import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/core/team/country_team/country_team.dart';
import 'package:sj_manager/data/models/game_variant/game_variant.dart';
import 'package:sj_manager/data/models/game_variant/game_variants_io_utils.dart';
import 'package:sj_manager/features/game_variants/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/domain/repository_interfaces/countries/countries_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/db_items_json_configuration.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/editable_items_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_repo.dart';

class LocalDatabaseState {
  const LocalDatabaseState({
    required this.maleJumpersRepo,
    required this.femaleJumpersRepo,
    required this.countriesRepo,
    required this.countryTeamsRepo,
  });

  final EditableItemsRepo<MaleJumperDbRecord> maleJumpersRepo;
  final EditableItemsRepo<FemaleJumperDbRecord> femaleJumpersRepo;
  final CountriesRepo countriesRepo;
  final ItemsRepo<CountryTeam> countryTeamsRepo;
}

class LocalDatabaseCubit extends Cubit<LocalDatabaseState?> {
  LocalDatabaseCubit({
    required this.gameVariant,
    required this.gameVariantsRepo,
  }) : super(null);

  final GameVariant gameVariant;
  final ItemsRepo<GameVariant> gameVariantsRepo;

  Future<void> setUp() async {
    emit(
      LocalDatabaseState(
        countriesRepo: CountriesRepo(countries: gameVariant.countries.toList()),
        maleJumpersRepo: EditableItemsRepo<MaleJumperDbRecord>(
            initial: gameVariant.jumpers.whereType<MaleJumperDbRecord>().toList()),
        femaleJumpersRepo: EditableItemsRepo<FemaleJumperDbRecord>(
            initial: gameVariant.jumpers.whereType<FemaleJumperDbRecord>().toList()),
        countryTeamsRepo: ItemsRepo(initial: gameVariant.countryTeams),
      ),
    );
  }

  Future<void> saveChangesToGameVariant(BuildContext context) async {
    final newVariant = gameVariant.copyWith(
      jumpers: [
        ...state!.maleJumpersRepo.last,
        ...state!.femaleJumpersRepo.last,
      ],
    );
    gameVariantsRepo.set(gameVariantsRepo.last.map((variant) {
      return variant.id == newVariant.id ? newVariant : variant;
    }).toList());
    await _saveNewGameVariantToFiles(newVariant: newVariant, context: context);
  }

  Future<void> _saveNewGameVariantToFiles({
    required GameVariant newVariant,
    required BuildContext context,
  }) async {
    await saveGameVariantItems<MaleJumperDbRecord>(
      items: newVariant.jumpers.whereType<MaleJumperDbRecord>().toList(),
      pathsCache: context.read(),
      pathsRegistry: context.read(),
      toJson: context.read<DbItemsJsonConfiguration<MaleJumperDbRecord>>().toJson,
      gameVariantId: newVariant.id,
    );
    if (!context.mounted) return;
    await saveGameVariantItems<FemaleJumperDbRecord>(
      items: newVariant.jumpers.whereType<FemaleJumperDbRecord>().toList(),
      pathsCache: context.read(),
      pathsRegistry: context.read(),
      toJson: context.read<DbItemsJsonConfiguration<FemaleJumperDbRecord>>().toJson,
      gameVariantId: newVariant.id,
    );
  }
}
