import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/countries/countries_repository/in_memory_countries_repository.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';

class GetFilteredDatabaseEditorCountriesUseCase {
  const GetFilteredDatabaseEditorCountriesUseCase({
    required this.countriesRepository,
    required this.itemsTypeRepository,
    required this.itemsRepository,
  });

  final CountriesRepository countriesRepository;
  final DatabaseEditorItemsTypeRepository itemsTypeRepository;
  final DatabaseEditorItemsRepository itemsRepository;

  Future<CountriesRepository> call() async {
    final itemsType = await itemsTypeRepository.get();
    final countries = await countriesRepository.getAll();
    switch (itemsType) {
      case DatabaseEditorItemsType.maleJumper || DatabaseEditorItemsType.femaleJumper:
        final jumpers = (await itemsRepository.getAll()).cast<JumperDbRecord>();
        final jumperCountries = jumpers.map((jumper) => jumper.country).toSet();
        return InMemoryCountriesRepository(
            countries: countries.where(jumperCountries.contains));
    }
  }
}
