import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/subjects.dart';
import 'package:sj_manager/database_editing/copied_local_db_cubit.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/database_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/local_db_repos_repository.dart';

import 'database_editing_logic_test.mocks.dart';

@GenerateMocks([DatabaseItemsRepository])
void main() {
  group(LocalDbReposRepository, () {
    late final MockDatabaseItemsRepository<MaleJumper> maleJumpersRepo;
    late final MockDatabaseItemsRepository<FemaleJumper> femaleJumpersRepo;
    late final MockDatabaseItemsRepository<Hill> hillsRepo;
    late final LocalDbReposRepository originalRepos;
    setUp(() {
      maleJumpersRepo = MockDatabaseItemsRepository();
      femaleJumpersRepo = MockDatabaseItemsRepository();
      hillsRepo = MockDatabaseItemsRepository();
      originalRepos = LocalDbReposRepository(
        maleJumpersRepo: maleJumpersRepo,
        femaleJumpersRepo: femaleJumpersRepo,
        hillsRepo: hillsRepo,
      );
    });
    test('Copying local database', () async {
      final clonedMales = MockDatabaseItemsRepository<MaleJumper>();
      final clonedFemales = MockDatabaseItemsRepository<FemaleJumper>();
      final clonedHills = MockDatabaseItemsRepository<Hill>();
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
}
