import 'package:equatable/equatable.dart';
import 'package:sj_manager/domain/repository_interfaces/countries/countries_repo.dart';

abstract class DatabaseEditorCountriesState with EquatableMixin {
  const DatabaseEditorCountriesState();

  @override
  List<Object?> get props => [];
}

class DatabaseEditorCountriesInitial extends DatabaseEditorCountriesState {
  const DatabaseEditorCountriesInitial();
}

class DatabaseEditorCountriesReady extends DatabaseEditorCountriesState {
  const DatabaseEditorCountriesReady({
    required this.maleJumpersCountries,
    required this.femaleJumpersCountries,
    required this.universalCountries,
  });

  final CountriesRepo maleJumpersCountries;
  final CountriesRepo femaleJumpersCountries;
  final CountriesRepo universalCountries;

  @override
  List<Object?> get props => [
        maleJumpersCountries,
        femaleJumpersCountries,
        universalCountries,
      ];
}
