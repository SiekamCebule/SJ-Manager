import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_default_items_repository.dart';

class PredefinedDatabaseEditorDefaultItemsRepository
    implements DatabaseEditorDefaultItemsRepository {
  const PredefinedDatabaseEditorDefaultItemsRepository({
    required this.countriesRepository,
  });

  final CountriesRepository countriesRepository;

  @override
  Future<dynamic> get(DatabaseEditorItemsType type) async {
    return switch (type) {
      DatabaseEditorItemsType.maleJumper ||
      DatabaseEditorItemsType.femaleJumper =>
        JumperDbRecord.empty(
          country: await countriesRepository.none,
        ),
    };
  }
}
