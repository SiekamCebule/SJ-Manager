import 'package:flutter/material.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/repositories/countries/countries_api.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';

class CountriesDropdown extends StatefulWidget {
  const CountriesDropdown({
    super.key,
    required this.countriesApi,
    required this.onSelected,
    this.firstAsInitial = false,
    this.label,
  });

  final CountriesApi countriesApi;
  final Function(Country?) onSelected;
  final bool firstAsInitial;
  final Widget? label;

  @override
  State<CountriesDropdown> createState() => CountriesDropdownState();
}

class CountriesDropdownState extends State<CountriesDropdown> {
  late final TextEditingController controller;
  Country? _selected;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countries = widget.countriesApi.countries;
    return DropdownMenu<Country>(
      enableSearch: false,
      requestFocusOnTap: false,
      label: widget.label,
      controller: controller,
      initialSelection: widget.firstAsInitial ? countries.first : null,
      onSelected: (selected) {
        setState(() {
          _selected = selected;
        });
        widget.onSelected(selected);
      },
      trailingIcon: _selected != null
          ? CountryFlag(
              country: _selected!,
              height: 20,
            )
          : null,
      dropdownMenuEntries: [
        ...countries.map((country) {
          return DropdownMenuEntry(
            value: country,
            label: country.name,
            trailingIcon: CountryFlag(
              country: country,
              height: 20,
            ),
          );
        }),
      ],
    );
  }

  void setupManually(Country? selected) {
    setState(() {
      _selected = selected;
    });
    controller.text = selected?.name ?? '';
  }
}
