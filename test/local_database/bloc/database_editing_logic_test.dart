import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/subjects.dart';
import 'package:sj_manager/database_editing/copied_local_db_cubit.dart';
import 'package:sj_manager/database_editing/local_db_filtered_items_cubit.dart';
import 'package:sj_manager/filters/hills/hill_matching_algorithms.dart';
import 'package:sj_manager/filters/hills/hills_filter.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_items_local_storage_repository.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';
import 'package:sj_manager/repositories/database_editing/local_db_repos_repository.dart';

import 'database_editing_logic_test.mocks.dart';

@GenerateMocks([DbItemsRepository, DbItemsLocalStorageRepository])
void main() {
  group(LocalDbReposRepository, () {
    late final MockDbItemsRepository<MaleJumper> maleJumpersRepo;
    late final MockDbItemsRepository<FemaleJumper> femaleJumpersRepo;
    late final MockDbItemsRepository<Hill> hillsRepo;
    late final LocalDbReposRepository originalRepos;
    setUp(() {
      maleJumpersRepo = MockDbItemsRepository();
      femaleJumpersRepo = MockDbItemsRepository();
      hillsRepo = MockDbItemsRepository();
      originalRepos = LocalDbReposRepository(
        maleJumpersRepo: maleJumpersRepo,
        femaleJumpersRepo: femaleJumpersRepo,
        hillsRepo: hillsRepo,
      );
    });
    test('Copying local database', () async {
      final clonedMales = MockDbItemsRepository<MaleJumper>();
      final clonedFemales = MockDbItemsRepository<FemaleJumper>();
      final clonedHills = MockDbItemsRepository<Hill>();
      when(clonedMales.items).thenAnswer((_) {
        return BehaviorSubject.seeded([
          MaleJumper.empty(country: const Country(code: 'none', name: 'None')),
          MaleJumper.empty(country: const Country(code: 'none', name: 'None')).copyWith(
            name: 'Adrian',
            surname: 'Nowak',
          ),
        ])
          ..close();
      });
      when(clonedFemales.items).thenAnswer((_) {
        return BehaviorSubject.seeded([
          FemaleJumper.empty(country: const Country(code: 'none', name: 'None')),
          FemaleJumper.empty(country: const Country(code: 'none', name: 'None'))
              .copyWith(name: 'Gabrysia', surname: 'Bąk'),
          FemaleJumper.empty(country: const Country(code: 'none', name: 'None'))
              .copyWith(name: 'Adrianna', surname: 'Nowaczka'),
        ])
          ..close();
      });
      when(clonedHills.items).thenAnswer((_) {
        return BehaviorSubject.seeded([]);
      });

      when(maleJumpersRepo.clone()).thenAnswer((_) {
        return Future(() => clonedMales);
      });
      when(femaleJumpersRepo.clone()).thenAnswer((_) {
        return Future(() => clonedFemales);
      });
      when(hillsRepo.clone()).thenAnswer((_) {
        return Future(() => clonedHills);
      });

      await testBloc(
        build: () {
          return CopiedLocalDbCubit(originalRepositories: originalRepos);
        },
        act: (bloc) async {
          await bloc.setUp();
          await bloc.saveChangesToOriginalRepos();
        },
        expect: () {
          return [
            LocalDbReposRepository(
              maleJumpersRepo: clonedMales,
              femaleJumpersRepo: clonedFemales,
              hillsRepo: clonedHills,
            ),
          ];
        },
      );

      verify(maleJumpersRepo.saveToSource()).called(1);
      verify(maleJumpersRepo.clone()).called(1);
      verify(femaleJumpersRepo.clone()).called(1);
      verify(hillsRepo.clone()).called(1);
    });
  });

  group(LocalDbFilteredItemsCubit, () {
    late DbFiltersRepository filtersRepo;
    late LocalDbReposRepository itemsRepo;

    // To initialize in test()
    late LocalDbFilteredItemsCubit cubit;

    setUp(() {
      filtersRepo = DbFiltersRepository();
      itemsRepo = LocalDbReposRepository(
        maleJumpersRepo: MockDbItemsLocalStorageRepository(),
        femaleJumpersRepo: MockDbItemsLocalStorageRepository(),
        hillsRepo: MockDbItemsLocalStorageRepository(),
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
