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
                JumpersFilterByCountry(countries: countries, noneCountry: noneCountry);
            _setFilters();
          },
        ),
      ],
    );
  }

  CountriesRepo get countriesRepo =>
      context.read<ItemsReposRegistry>().get<Country>() as CountriesRepo;
  Country get noneCountry => countriesRepo.none;

  void _setFilters() {
    context.read<DbFiltersRepo>().set<MaleJumper>([
      ConcreteJumpersFilterWrapper(filter: _byCountry),
      ConcreteJumpersFilterWrapper(filter: _bySearchText),
    ]);
    context.read<DbFiltersRepo>().set<FemaleJumper>([
      ConcreteJumpersFilterWrapper(filter: _byCountry),
      ConcreteJumpersFilterWrapper(filter: _bySearchText),
    ]);
  }

  void _clearSelection() {
    context.read<SelectedIndexesRepo>().clearSelection();
  }
}
