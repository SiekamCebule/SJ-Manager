import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/filters/jumpers/jumper_matching_algorithms.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/hill/hill_type_by_size.dart';
import 'package:sj_manager/filters/hills/hills_filter.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';

void main() {
  group(DbFiltersRepo, () {
    late DbFiltersRepo repo;
    setUp(() {
      repo = DbFiltersRepo();
    });
    test('integration test', () async {
      final jumpersFilters = [
        JumpersFilterByCountry(
            countries: {Country.monolingual(code: 'pl', language: 'pl', name: 'Polska')}),
        const JumpersFilterBySearch(
            searchAlgorithm: DefaultJumperMatchingByTextAlgorithm(text: 'Kamil Sto')),
      ];
      final forMales = jumpersFilters.map((filter) {
        return ConcreteJumpersFilterWrapper<MaleJumper, JumpersFilter>(filter: filter);
      }).toList();
      final hillsFilters = [
        const HillsFilterByTypeBySie(type: HillTypeBySize.large),
        HillsFilterByCountry(countries: {
          Country.monolingual(code: 'at', language: 'pl', name: 'Austria')
        }),
      ];

      repo.set<MaleJumper>(forMales);
      repo.set<Hill>(hillsFilters);

      expect(repo.stream<MaleJumper>().value, forMales);
      expect(repo.stream<Hill>().value, hillsFilters);
    });

    tearDown(() {
      repo.close();
    });
  });
}
