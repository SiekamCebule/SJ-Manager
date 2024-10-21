part of '../../../database_editor_screen.dart';

class _ForJumpersTyped<T extends Jumper> extends StatefulWidget {
  const _ForJumpersTyped({super.key});

  @override
  State<_ForJumpersTyped<T>> createState() => _ForJumpersTypedState<T>();
}

class _ForJumpersTypedState<T extends Jumper> extends State<_ForJumpersTyped<T>> {
  late final TextEditingController _searchingController;
  final _countriesDropdownKey = GlobalKey<CountriesDropdownState>();
  var _byCountry = const JumpersFilterByCountry(countries: {});
  var _bySearchText = const JumpersFilterBySearch(
      searchAlgorithm: DefaultJumperMatchingByTextAlgorithm(text: ''));
  late final StreamSubscription _subscription;

  @override
  void initState() {
    _searchingController = TextEditingController();
    scheduleMicrotask(() {
      final filtersRepo = context.read<DbFiltersRepo>();
      _subscription = filtersRepo.streamByTypeArgument(T).listen((filters) {
        final bySearch = filters.singleWhereTypeOrNull<
            ConcreteJumpersFilterWrapper<Jumper, JumpersFilterBySearch>>();
        _searchingController.text = bySearch?.filter.searchAlgorithm.text ?? '';
        final country = filters
            .singleWhereTypeOrNull<
                ConcreteJumpersFilterWrapper<Jumper, JumpersFilterByCountry>>()
            ?.filter
            .countries
            .singleOrNull;
        _countriesDropdownKey.currentState!.setManually(country ?? countriesRepo.none);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 400,
          child: SearchTextField(
            controller: _searchingController,
            onChanged: (changed) async {
              _clearSelection();
              await Future.delayed(Duration.zero);
              _bySearchText = JumpersFilterBySearch(
                  searchAlgorithm: DefaultJumperMatchingByTextAlgorithm(text: changed));
              _setFilters();
            },
          ),
        ),
        const Spacer(),
        LayoutBuilder(
          // TODO: IT DOESNT WORK
          builder: (context, constraints) {
            return CountriesDropdown(
              key: _countriesDropdownKey,
              width: 220,
              label: Text(translate(context).filterByCountry),
              countriesRepo: countriesRepo,
              firstAsInitial: true,
              menuHeight: 600,
              onSelected: (selected) async {
                _clearSelection();
                await Future.delayed(Duration.zero);
                var countries = <Country>{};
                if (selected != noneCountry || selected != null) {
                  countries = {selected!};
                }
                _byCountry = JumpersFilterByCountry(
                    countries: countries, noneCountry: noneCountry);
                _setFilters();
              },
            );
          },
        ),
      ],
    );
  }

  CountriesRepo get countriesRepo {
    final dbCountries = (context.read<DatabaseEditorCountriesCubit>().state
        as DatabaseEditorCountriesReady);
    final countries = T == MaleJumper
        ? dbCountries.maleJumpersCountries
        : dbCountries.femaleJumpersCountries;
    return countries;
  }

  Country get noneCountry => countriesRepo.none;

  void _setFilters() {
    context.read<DbFiltersRepo>().set<T>([
      ConcreteJumpersFilterWrapper(filter: _byCountry),
      ConcreteJumpersFilterWrapper(filter: _bySearchText),
    ]);
  }

  void _clearSelection() {
    context.read<SelectedIndexesRepo>().clearSelection();
  }
}
