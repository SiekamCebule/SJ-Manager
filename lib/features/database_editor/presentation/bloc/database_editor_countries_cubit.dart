import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/countries/get_all_database_editor_countries_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/countries/get_filtered_database_editor_countries_use_case.dart';

class DatabaseEditorCountriesCubit extends Cubit<DatabaseEditorCountriesState> {
  DatabaseEditorCountriesCubit({
    required this.getAllCountriesUseCase,
    required this.getFilteredCountriesUseCase,
  }) : super(const DatabaseEditorCountriesUninitialized());

  final GetAllDatabaseEditorCountriesUseCase getAllCountriesUseCase;
  final Map<DatabaseEditorItemsType, GetFilteredDatabaseEditorCountriesUseCase>
      getFilteredCountriesUseCase;

  Future<void> initialize() async {
    emit(DatabaseEditorCountriesInitialized(
      countries: await getAllCountriesUseCase(),
      maleJumperCountries:
          await getFilteredCountriesUseCase[DatabaseEditorItemsType.maleJumper]!(),
      femaleJumperCountries:
          await getFilteredCountriesUseCase[DatabaseEditorItemsType.femaleJumper]!(),
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
    required this.maleJumperCountries,
    required this.femaleJumperCountries,
  });

  final CountriesRepository countries;
  final CountriesRepository maleJumperCountries;
  final CountriesRepository femaleJumperCountries;

  @override
  List<Object?> get props => [
        countries,
        femaleJumperCountries,
        femaleJumperCountries,
      ];
}
