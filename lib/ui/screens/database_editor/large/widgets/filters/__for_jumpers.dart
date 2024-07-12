part of '../../../database_editor_screen.dart';

class _ForJumpers extends StatefulWidget {
  const _ForJumpers();

  @override
  State<_ForJumpers> createState() => _ForJumpersState();
}

class _ForJumpersState extends State<_ForJumpers> {
  var _byCountry = const JumpersFilterByCountry(countries: {});
  var _bySearchText = const JumpersFilterBySearch(
      searchAlgorithm: DefaultJumperMatchingByTextAlgorithm(text: ''));

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
              _bySearchText = JumpersFilterBySearch(
                  searchAlgorithm: DefaultJumperMatchingByTextAlgorithm(text: changed));
              _setFilters();
            },
          ),
        ),
        const Spacer(),
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
                JumpersFilterByCountry(countries: countries, noneCountry: noneCountry);
            _setFilters();
          },
        ),
      ],
    );
  }

  CountriesRepo get countries => context.read();
  Country get noneCountry => countries.none;

  void _setFilters() {
    context.read<DbFiltersRepo>().setMaleAndFemaleJumpersFilters([
      _byCountry,
      _bySearchText,
    ]);
  }

  void _clearSelection() {
    context.read<SelectedIndexesRepo>().clearSelection();
  }
}
