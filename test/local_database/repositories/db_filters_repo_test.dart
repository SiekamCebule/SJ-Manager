import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/filters/jumpers/jumper_matching_algorithms.dart';
import 'package:sj_manager/models/hill/hill_type_by_size.dart';
import 'package:sj_manager/filters/hills/hills_filter.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';

void main() {
  group(DbFiltersRepo, () {
    late DbFiltersRepo repo;
    setUp(() {
      repo = DbFiltersRepo();
    });
    test('integration test', () async {
      const jumpersFilters = [
        JumpersFilterByCountry(countries: {Country(code: 'pl', name: 'Polska')}),
        JumpersFilterBySearch(
            searchAlgorithm: DefaultJumperMatchingByTextAlgorithm(text: 'Kamil Sto')),
      ];
      const hillsFilters = [
        HillsFilterByTypeBySie(type: HillTypeBySize.large),
        HillsFilterByCountry(countries: {Country(code: 'at', name: 'Austria')}),
      ];
      repo.setMaleAndFemaleJumpersFilters(jumpersFilters);
      repo.setHillsFilters(hillsFilters);

      expect(repo.maleJumpersFilters.value, jumpersFilters);
      expect(repo.hillsFilters.value, hillsFilters);
    });

    tearDown(() {
      repo.close();
    });
  });
}
