import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/subjects.dart';
import 'package:sj_manager/bloc/database_editing/local_db_filtered_items_cubit.dart';
import 'package:sj_manager/filters/hills/hill_matching_algorithms.dart';
import 'package:sj_manager/filters/hills/hills_filter.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';

import 'database_editing_logic_test.mocks.dart';

@GenerateMocks([EditableItemsRepo, CountriesRepo, TeamsRepo])
void main() {
  group(LocalDbFilteredItemsCubit, () {
    late DbFiltersRepo filtersRepo;
    late ItemsReposRegistry itemsRepo;

    // To initialize in test()
    late LocalDbFilteredItemsCubit cubit;

    setUp(() {
      filtersRepo = DbFiltersRepo();
      itemsRepo = ItemsReposRegistry(
        initial: {
          MockEditableItemsRepo<MaleJumper>(),
          MockEditableItemsRepo<FemaleJumper>(),
          MockEditableItemsRepo<Hill>(),
          MockEditableItemsRepo<EventSeriesSetup>(),
          MockEditableItemsRepo<EventSeriesCalendar>(),
          MockEditableItemsRepo<DefaultCompetitionRulesPreset>(),
          MockCountriesRepo(),
          MockTeamsRepo(),
        },
      );
    });
    test('filtering', () async {
      final poland = Country.monolingual(code: 'pl', language: 'pl', name: 'Polska');
      final norway = Country.monolingual(code: 'no', language: 'pl', name: 'Norwegia');
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

      when(itemsRepo.get<MaleJumper>().items).thenAnswer((_) {
        malesSubject.add(males);
        return malesSubject;
      });
      when(itemsRepo.get<FemaleJumper>().items).thenAnswer((_) {
        femalesSubject.add(females);
        return femalesSubject;
      });
      when(itemsRepo.get<Hill>().items).thenAnswer((_) {
        hillsSubject.add(hills);
        return hillsSubject;
      });

      cubit = LocalDbFilteredItemsCubit(filtersRepo: filtersRepo, itemsRepos: itemsRepo);

      filtersRepo.set<FemaleJumper>([
        ConcreteJumpersFilterWrapper(filter: JumpersFilterByCountry(countries: {poland})),
      ]);
      filtersRepo.set<Hill>([
        HillsFilterByCountry(countries: {norway}),
      ]);

      await Future.delayed(Duration.zero);

      expect(cubit.state.get<MaleJumper>(), males);
      expect(cubit.state.get<FemaleJumper>(), [
        FemaleJumper.empty(country: poland),
      ]);
      expect(cubit.state.get<Hill>().length, 2);

      filtersRepo.set<Hill>(const [
        HillsFilterBySearch(
            searchAlgorithm: DefaultHillMatchingByTextAlgorithm(text: 'Lillehammer')),
      ]);
      await Future.delayed(Duration.zero);

      expect(
          cubit.state.get<Hill>().where((hill) => hill.locality == 'Lillehammer').length,
          1);

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
