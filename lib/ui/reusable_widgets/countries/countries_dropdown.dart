import 'package:flutter/material.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';

class CountriesDropdown extends StatefulWidget {
  const CountriesDropdown({
    super.key,
    required this.countriesRepo,
    required this.onSelected,
    this.firstAsInitial = false,
    this.label,
    this.focusNode,
    this.width,
    this.enabled,
  });

  final CountriesRepo countriesRepo;
  final Function(Country?) onSelected;
  final bool firstAsInitial;
  final Widget? label;
  final FocusNode? focusNode;
  final double? width;
  final bool? enabled;

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
    final countries = widget.countriesRepo.last;
    final windowHeight = MediaQuery.of(context).size.height;
    return DropdownMenu<Country>(
      enabled: widget.enabled ?? true,
      width: widget.width,
      menuHeight: windowHeight * 0.6,
      enableSearch: true,
      requestFocusOnTap: false,
      label: widget.label,
      focusNode: widget.focusNode,
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
              width: UiGlobalConstants.smallCountryFlagWidth,
            )
          : null,
      dropdownMenuEntries: [
        ...countries.map((country) {
          return DropdownMenuEntry(
            value: country,
            label: country.name(context),
            trailingIcon: CountryFlag(
              country: country,
              width: UiGlobalConstants.smallCountryFlagWidth,
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
    controller.text = selected?.multilingualName.translate(context) ?? '';
  }
}
