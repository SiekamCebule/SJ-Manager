import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/subjects.dart';
import 'package:sj_manager/database_editing/local_db_filtered_items_cubit.dart';
import 'package:sj_manager/filters/hills/hill_matching_algorithms.dart';
import 'package:sj_manager/filters/hills/hills_filter.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/local_db_repos_repository.dart';

import 'database_editing_logic_test.mocks.dart';

@GenerateMocks([DbItemsRepo])
void main() {
  group(LocalDbFilteredItemsCubit, () {
    late DbFiltersRepo filtersRepo;
    late LocalDbReposRepo itemsRepo;

    // To initialize in test()
    late LocalDbFilteredItemsCubit cubit;

    setUp(() {
      filtersRepo = DbFiltersRepo();
      itemsRepo = LocalDbReposRepo(
        maleJumpersRepo: MockDbItemsRepo(),
        femaleJumpersRepo: MockDbItemsRepo(),
        hillsRepo: MockDbItemsRepo(),
      );
    });
    test('filtering', () async {
      const poland = Country(code: 'pl', name: 'Polska');
      const norway = Country(code: 'no', name: 'Norwegia');
      final males = [
        MaleJumper.empty(country: poland),
        MaleJumper.empty(country: poland),
        MaleJumper.empty(country: norway)
      ];
      final females = [
        FemaleJumper.empty(country: norway),
        FemaleJumper.empty(country: poland),
        FemaleJumper.empty(country: norway)
      ];
      final hills = [
        Hill.empty(country: norway).copyWith(locality: 'Lillehammer'),
        Hill.empty(country: norway).copyWith(locality: 'Oslo')
      ];

      final malesSubject = BehaviorSubject<List<MaleJumper>>.seeded([]);
      final femalesSubject = BehaviorSubject<List<FemaleJumper>>.seeded([]);
      final hillsSubject = BehaviorSubject<List<Hill>>.seeded([]);

      when(itemsRepo.maleJumpersRepo.items).thenAnswer((_) {
        malesSubject.add(males);
        return malesSubject;
      });
      when(itemsRepo.femaleJumpersRepo.items).thenAnswer((_) {
        femalesSubject.add(females);
        return femalesSubject;
      });
      when(itemsRepo.hillsRepo.items).thenAnswer((_) {
        hillsSubject.add(hills);
        return hillsSubject;
      });

      cubit = LocalDbFilteredItemsCubit(filtersRepo: filtersRepo, itemsRepo: itemsRepo);

      filtersRepo.setFemaleJumpersFilters(const [
        JumpersFilterByCountry(countries: {poland})
      ]);
      filtersRepo.setHillsFilters(const [
        HillsFilterByCountry(countries: {norway}),
      ]);

      await Future.delayed(Duration.zero);

      expect(cubit.state.maleJumpers, males);
      expect(cubit.state.femaleJumpers, [
        FemaleJumper.empty(country: poland),
      ]);
      expect(cubit.state.hills.length, 2);

      filtersRepo.setHillsFilters(const [
        HillsFilterBySearch(
            searchAlgorithm: DefaultHillMatchingByTextAlgorithm(text: 'Lillehammer')),
      ]);
      await Future.delayed(Duration.zero);

      expect(cubit.state.hills.where((hill) => hill.locality == 'Lillehammer').length, 1);

      malesSubject.close();
      femalesSubject.close();
      hillsSubject.close();
    });

    tearDown(() {
      cubit.close();
      cubit.dispose();
    });
  });
}
