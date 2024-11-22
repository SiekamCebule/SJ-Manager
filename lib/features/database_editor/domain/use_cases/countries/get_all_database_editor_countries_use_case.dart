import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';

class GetAllDatabaseEditorCountriesUseCase {
  const GetAllDatabaseEditorCountriesUseCase({
    required this.countriesRepository,
  });

  final CountriesRepository countriesRepository;

  Future<dynamic> call() async {
    return countriesRepository.getAll();
  }
}
