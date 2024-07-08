part of '../../../database_editor_screen.dart';

class _ForJumpers extends StatefulWidget {
  const _ForJumpers();

  @override
  State<_ForJumpers> createState() => _ForJumpersState();
}

class _ForJumpersState extends State<_ForJumpers> {
  final _byCountry = JumpersFilterByCountry(countries: {});

  @override
  Widget build(BuildContext context) {
    final localDbFiltersCubit = context.read<FiltersRepository>();
    final CountriesApi countries = context.read();
    final noneCountry = countries.none;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CountriesDropdown(
          label: const Text('Filtruj wg kraju'),
          countriesApi: context.read(),
          firstAsInitial: true,
          onSelected: (selected) {
            if (selected == noneCountry || selected == null) {
              _byCountry.countries = {};
            } else {
              _byCountry.countries = {selected};
            }
            localDbFiltersCubit.setJumpersFilters(
              {
                _byCountry,
              }.where((filter) => filter.countries.isNotEmpty).toSet(),
            );
          },
        ),
      ],
    );
  }
}
