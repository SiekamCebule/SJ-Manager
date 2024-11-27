import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/core/general_utils/map_extensions.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/countries/get_all_database_editor_countries_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/countries/get_filtered_database_editor_countries_use_case.dart';

class DatabaseEditorCountriesCubit extends Cubit<DatabaseEditorCountriesState> {
  DatabaseEditorCountriesCubit({
    required this.getAllCountries,
    required this.getFilteredCountries,
  }) : super(const DatabaseEditorCountriesUninitialized());

  final GetAllDatabaseEditorCountriesUseCase getAllCountries;
  final Map<DatabaseEditorItemsType, GetFilteredDatabaseEditorCountriesUseCase>
      getFilteredCountries;

  Future<void> initialize() async {
    final filteredCountries = await getFilteredCountries.asyncMap(
      (itemsType, getFilteredCountries) async {
        return MapEntry(itemsType, await getFilteredCountries());
      },
    );
    emit(DatabaseEditorCountriesInitialized(
      countries: await getAllCountries(),
      filteredCountries: filteredCountries,
    ));
  }
}

abstract class DatabaseEditorCountriesState extends Equatable {
  const DatabaseEditorCountriesState();
}

class DatabaseEditorCountriesUninitialized extends DatabaseEditorCountriesState {
  const DatabaseEditorCountriesUninitialized();

  @override
  List<Object?> get props => [];
}

class DatabaseEditorCountriesInitialized extends DatabaseEditorCountriesState {
  const DatabaseEditorCountriesInitialized({
    required this.countries,
    required this.filteredCountries,
  });

  final CountriesRepository countries;
  final Map<DatabaseEditorItemsType, CountriesRepository> filteredCountries;
  CountriesRepository filtered(DatabaseEditorItemsType itemsType) =>
      filteredCountries[itemsType]!;

  @override
  List<Object?> get props => [
        countries,
        filteredCountries,
      ];
}
