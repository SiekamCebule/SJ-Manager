part of '../../../database_editor_screen.dart';

class _ForHills extends StatefulWidget {
  const _ForHills();

  @override
  State<_ForHills> createState() => _ForHillsState();
}

class _ForHillsState extends State<_ForHills> {
  var _byCountry = const HillsFilterByCountry(countries: {});
  var _byTypeBySize = const HillsFilterByTypeBySie(type: null);
  var _bySearchText = const HillsFilterBySearch(
      searchAlgorithm: DefaultHillMatchingByTextAlgorithm(text: ''));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 400,
          child: SearchTextField(
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
        const Gap(30),
        CountriesDropdown(
          label: const Text('Filtruj wg kraju'),
          countriesApi: context.read(),
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

  CountriesRepo get countries => context.read();
  Country get noneCountry => countries.none;

  void _setFilters() {
    context.read<DbFiltersRepo>().setHillsFilters([
      _byCountry,
      _byTypeBySize,
      _bySearchText,
    ]);
  }

  void _clearSelection() {
    context.read<SelectedIndexesRepo>().clearSelection();
  }
}
