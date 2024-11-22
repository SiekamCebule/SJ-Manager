import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_database.dart/jumper/jumper_db_record_model.dart';

import 'package:sj_manager/features/game_variants/data/models/game_variant_model.dart';
import 'package:sj_manager/utilities/json/countries.dart';
import 'package:sj_manager/utilities/json/db_items_json.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/team_loader.dart';
import 'package:sj_manager/utilities/utils/file_system.dart';

abstract interface class LocalGameVariantsDataSource {
  Future<List<GameVariantModel>> loadAllVariants();
  Future<GameVariantModel> loadVariant({required String gameVariantId});
  Future<void> saveVariant(GameVariantModel variantModel);
  Future<void> saveAllVariants(List<GameVariantModel> models);
}

class LocalGameVariantsDataSourceImpl implements LocalGameVariantsDataSource {
  const LocalGameVariantsDataSourceImpl({
    required this.gameVariantsDirectory,
    required this.jumpersFileName,
    required this.countriesFileName,
    required this.countryTeamsFileName,
    required this.jumperCountryJsonLoader,
  });

  final Directory gameVariantsDirectory;
  final String jumpersFileName;
  final String countriesFileName;
  final String countryTeamsFileName;
  final JsonCountryLoader jumperCountryJsonLoader;

  @override
  Future<List<GameVariantModel>> loadAllVariants() async {
    await _ensureVariantsDirectoryExists();
    final availableDirectories = gameVariantsDirectory
        .listSync(recursive: false, followLinks: false)
        .whereType<Directory>();
    final future = Future.wait([
      for (final directory in availableDirectories)
        loadVariant(gameVariantId: path.basename(directory.path)),
    ]);
    return await future;
  }

  @override
  Future<GameVariantModel> loadVariant({
    required String gameVariantId,
  }) async {
    await _ensureVariantsDirectoryExists();
    final variantDirectory = Directory(path.join(
      gameVariantsDirectory.path,
      gameVariantId,
    ));
    final countries = await loadItemsListFromJsonFile(
      file: fileInDirectory(variantDirectory, countriesFileName),
      fromJson: Country.fromJson,
    );
    Country countryByCode(String code) =>
        countries.firstWhere((country) => country.code == code);
    final jumperModels = await loadItemsListFromJsonFile(
      file: fileInDirectory(variantDirectory, jumpersFileName),
      fromJson: (json) => JumperDbRecordModel.fromJson(json,
          countryLoader: JsonCountryLoaderCustom(getCountry: countryByCode)),
    );
    final countryTeams = await loadItemsListFromJsonFile(
      file: fileInDirectory(variantDirectory, countryTeamsFileName),
      fromJson: (json) => loadCountryTeamFromJson(json,
          countryLoader: JsonCountryLoaderCustom(getCountry: countryByCode)),
    );

    return GameVariantModel(
      id: gameVariantId,
      jumpers: jumperModels,
      countries: countries,
      countryTeams: countryTeams,
    );
  }

  @override
  Future<void> saveVariant(GameVariantModel variantModel) async {
    await _ensureVariantsDirectoryExists();
    final variantDirectory = Directory(path.join(
      gameVariantsDirectory.path,
      variantModel.id,
    ));
    await saveItemsListToJsonFile(
      file: fileInDirectory(variantDirectory, jumpersFileName),
      items: variantModel.jumpers,
      toJson: (jumper) => jumper.toJson(countrySaver: const JsonCountryCodeSaver()),
    );
  }

  @override
  Future<void> saveAllVariants(List<GameVariantModel> models) async {
    for (var model in models) {
      saveVariant(model);
    }
  }

  Future<void> _ensureVariantsDirectoryExists() async {
    await gameVariantsDirectory.create(recursive: true);
  }
}
