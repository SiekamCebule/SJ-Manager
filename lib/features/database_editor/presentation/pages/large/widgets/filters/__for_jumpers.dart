part of '../../../database_editor_page.dart';

class _ForJumpers<T extends JumperDbRecord> extends StatefulWidget {
  const _ForJumpers({
    super.key,
    required this.type,
  });

  final DatabaseEditorItemsType type;

  @override
  State<_ForJumpers<T>> createState() => _ForJumpersState<T>();
}

class _ForJumpersState<T extends JumperDbRecord> extends State<_ForJumpers<T>> {
  late final TextEditingController _searchingController;
  final _countriesDropdownKey = GlobalKey<CountriesDropdownState>();

  @override
  void initState() {
    _searchingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countriesCubit = context.watch<DatabaseEditorCountriesCubit>();
    final countriesState = countriesCubit.state as DatabaseEditorCountriesInitialized;
    final countries = countriesState.filtered(widget.type);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 400,
          child: SearchTextField(
            controller: _searchingController,
            onChanged: (changed) async {
              await _clearSelection();
              await _setSearchFilter(changed);
            },
          ),
        ),
        const Spacer(),
        CountriesDropdown(
          key: _countriesDropdownKey,
          width: 220,
          label: Text(translate(context).filterByCountry),
          countries: countries.getAll(),
          firstAsInitial: true,
          menuHeight: 600,
          onSelected: (selected) async {
            await _clearSelection();
            await _setCountryFilter(selected!);
          },
        ),
      ],
    );
  }

  CountriesRepository get countriesRepo {
    final dbCountries = (context.read<DatabaseEditorCountriesCubit>().state
        as DatabaseEditorCountriesInitialized);
    final countries = T == MaleJumperDbRecord
        ? dbCountries.filtered(DatabaseEditorItemsType.maleJumper)
        : dbCountries.filtered(DatabaseEditorItemsType.femaleJumper);
    return countries;
  }

  Future<void> _clearSelection() async {
    await context.read<DatabaseEditorSelectionCubit>().clear();
  }

  Future<void> _setSearchFilter(String text) async {
    await context.read<DatabaseEditorFiltersCubit>().setFilter(
          widget.type,
          DatabaseEditorFilterType.nameSurname,
          NameSurnameFilter(text: text),
        );
  }

  Future<void> _setCountryFilter(Country country) async {
    await context.read<DatabaseEditorFiltersCubit>().setFilter(
          widget.type,
          DatabaseEditorFilterType.country,
          CountryFilter(country: country),
        );
  }
}
