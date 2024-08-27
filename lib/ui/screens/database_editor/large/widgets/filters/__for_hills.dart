part of '../../../database_editor_screen.dart';

class _ForHills extends StatefulWidget {
  const _ForHills();

  @override
  State<_ForHills> createState() => _ForHillsState();
}

class _ForHillsState extends State<_ForHills> {
  late final TextEditingController _searchingController;
  late final TextEditingController _hillTypeController;
  final _countriesDropdownKey = GlobalKey<CountriesDropdownState>();
  var _byCountry = const HillsFilterByCountry(countries: {});
  var _byTypeBySize = const HillsFilterByTypeBySie(type: null);
  var _bySearchText = const HillsFilterBySearch(
      searchAlgorithm: DefaultHillMatchingByTextAlgorithm(text: ''));
  late final StreamSubscription _filtersSubscription;

  @override
  void initState() {
    _searchingController = TextEditingController();
    _hillTypeController = TextEditingController();

    scheduleMicrotask(() {
      final filtersRepo = context.read<DbFiltersRepo>();
      _filtersSubscription = filtersRepo.streamByTypeArgument(Hill).listen((filters) {
        final bySearch = filters.singleWhereTypeOrNull<HillsFilterBySearch>();
        _searchingController.text = bySearch?.searchAlgorithm.text ?? '';
        final country =
            filters.singleWhereTypeOrNull<HillsFilterByCountry>()?.countries.singleOrNull;
        _countriesDropdownKey.currentState!.setManually(country ?? countriesRepo.none);
        final hillTypeBySize =
            filters.singleWhereTypeOrNull<HillsFilterByTypeBySie>()?.type;

        _hillTypeController.text = hillTypeBySize != null
            ? translatedHillTypeBySizeBriefDescription(context, hillTypeBySize)
            : translate(context).none;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _filtersSubscription.cancel();
    _searchingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiDatabaseEditorConstants.gapBetweenFilters);
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
              _bySearchText = HillsFilterBySearch(
                  searchAlgorithm: DefaultHillMatchingByTextAlgorithm(text: changed));
              _setFilters();
            },
          ),
        ),
        const Spacer(),
        MyDropdownField(
          controller: _hillTypeController,
          onChange: (selected) async {
            _clearSelection();
            await Future.delayed(Duration.zero);
            _byTypeBySize = HillsFilterByTypeBySie(type: selected);
            _setFilters();
          },
          entries: [
            noneMenuEntry(context),
            ...HillTypeBySize.values.map((type) {
              return DropdownMenuEntry(
                value: type,
                label: translatedHillTypeBySizeBriefDescription(context, type),
              );
            })
          ],
        ),
        gap,
        CountriesDropdown(
          key: _countriesDropdownKey,
          width: 220,
          label: Text(translate(context).filterByCountry),
          countriesRepo: countriesRepo,
          firstAsInitial: true,
          onSelected: (selected) async {
            _clearSelection();
            await Future.delayed(Duration.zero);
            var countries = <Country>{};
            if (selected != noneCountry || selected != null) {
              countries = {selected!};
            }
            _byCountry =
                HillsFilterByCountry(countries: countries, noneCountry: noneCountry);
            _setFilters();
          },
        ),
      ],
    );
  }

  CountriesRepo get countriesRepo {
    return (context.read<DatabaseEditorCountriesCubit>().state
            as DatabaseEditorCountriesReady)
        .universalCountries;
  }

  Country get noneCountry => countriesRepo.none;

  void _setFilters() {
    context.read<DbFiltersRepo>().set<Hill>([
      _byCountry,
      _byTypeBySize,
      _bySearchText,
    ]);
  }

  void _clearSelection() {
    context.read<SelectedIndexesRepo>().clearSelection();
  }
}
