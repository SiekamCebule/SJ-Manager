part of '../../../database_editor_screen.dart';

class _ForJumpers<T extends JumperDbRecord> extends StatefulWidget {
  const _ForJumpers({super.key});

  @override
  State<_ForJumpers<T>> createState() => _ForJumpersState<T>();
}

class _ForJumpersState<T extends JumperDbRecord> extends State<_ForJumpers<T>> {
  late final TextEditingController _searchingController;
  final _countriesDropdownKey = GlobalKey<CountriesDropdownState>();
  var _byCountry = Filter<JumperDbRecord>(
    shouldPass: (item) {
      return true;
    },
  );
  var _bySearch = Filter<JumperDbRecord>(
    shouldPass: (item) {
      return DefaultJumperMatchingByTextAlgorithm(
              fullName: item.nameAndSurname(), text: '')
          .matches();
    },
  );

  @override
  void initState() {
    _searchingController = TextEditingController();
    scheduleMicrotask(() {
      final filtersRepo = context.read<DbFiltersRepo>();
      /*filtersRepo.changesStream.listen((_) {
        _searchingController.text = '';
        _countriesDropdownKey.currentState!.setManually(null);
      });*/
    });
    super.initState();
  }

  @override
  void dispose() {
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
              _bySearch = Filter(shouldPass: (jumper) {
                return DefaultJumperMatchingByTextAlgorithm(
                        fullName: jumper.nameAndSurname(), text: changed)
                    .matches();
              });
              _setFilters();
            },
          ),
        ),
        const Spacer(),
        CountriesDropdown(
          key: _countriesDropdownKey,
          width: 220,
          label: Text(translate(context).filterByCountry),
          countriesRepo: countriesRepo,
          firstAsInitial: true,
          menuHeight: 600,
          onSelected: (selected) async {
            _clearSelection();
            await Future.delayed(Duration.zero);
            _byCountry = Filter(shouldPass: (jumper) {
              return jumper.country == selected;
            });
            _setFilters();
          },
        ),
      ],
    );
  }

  CountriesRepo get countriesRepo {
    final dbCountries = (context.read<DatabaseEditorCountriesCubit>().state
        as DatabaseEditorCountriesReady);
    final countries = T == MaleJumperDbRecord
        ? dbCountries.maleJumpersCountries
        : dbCountries.femaleJumpersCountries;
    return countries;
  }

  Country get noneCountry => countriesRepo.none;

  void _setFilters() {
    final filtersRepo = context.read<DbFiltersRepo>();
    if (T == MaleJumperDbRecord) {
      filtersRepo.maleJumpersCountryFilter = _byCountry;
      filtersRepo.maleJumpersSearchFilter = _bySearch;
    } else if (T == FemaleJumperDbRecord) {
      filtersRepo.femaleJumpersCountryFilter = _byCountry;
      filtersRepo.femaleJumpersSearchFilter = _bySearch;
    }
    filtersRepo.notify();
  }

  void _clearSelection() {
    context.read<SelectedIndexesRepo>().clearSelection();
  }
}
