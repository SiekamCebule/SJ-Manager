import 'package:flutter/material.dart';
import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/domain/repository_interfaces/countries/countries_repo.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/countries/country_flag.dart';

class CountriesDropdown extends StatefulWidget {
  const CountriesDropdown({
    super.key,
    required this.countriesRepo,
    required this.onSelected,
    this.firstAsInitial = false,
    this.label,
    this.focusNode,
    this.width,
    this.menuHeight,
    this.enabled,
  });

  final CountriesRepo countriesRepo;
  final Function(Country?) onSelected;
  final bool firstAsInitial;
  final Widget? label;
  final FocusNode? focusNode;
  final double? width;
  final double? menuHeight;
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
    final countries = widget.countriesRepo.countries;
    final entries = [
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
    ];
    return MyDropdownField<Country>(
      enabled: widget.enabled ?? true,
      width: widget.width,
      enableSearch: true,
      requestFocusOnTap: false,
      label: widget.label,
      menuHeight: widget.menuHeight,
      focusNode: widget.focusNode,
      controller: controller,
      initial: widget.firstAsInitial ? countries.first : null,
      onChange: (selected) {
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
      entries: entries,
    );
  }

  void setManually(Country? selected) {
    setState(() {
      _selected = selected;
    });
    controller.text = selected?.multilingualName.translate(context) ?? '';
  }

  Country? get current => _selected;
}
