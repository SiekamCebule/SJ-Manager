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
            onChanged: (changed) {
              _bySearchText = HillsFilterBySearch(
                  searchAlgorithm: DefaultHillMatchingByTextAlgorithm(text: changed));
              _setFilters();
              _clearSelection();
            },
          ),
        ),
        const Spacer(),
        MyDropdownField(
          onChange: (selected) {
            _byTypeBySize = HillsFilterByTypeBySie(type: selected);
            _setFilters();
            _clearSelection();
          },
          entries: [
            DropdownMenuEntry(value: null, label: translate(context).none),
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
          onSelected: (selected) {
            var countries = <Country>{};
            if (selected != noneCountry || selected != null) {
              countries = {selected!};
            }
            _byCountry =
                HillsFilterByCountry(countries: countries, noneCountry: noneCountry);
            _setFilters();
            _clearSelection();
          },
        ),
      ],
    );
  }

  CountriesApi get countries => context.read();
  Country get noneCountry => countries.none;

  void _setFilters() {
    context.read<DbFiltersRepository>().setHillsFilters([
      _byCountry,
      _byTypeBySize,
      _bySearchText,
    ]);
  }

  void _clearSelection() {
    context.read<SelectedIndexesRepository>().clearSelection();
  }
}
