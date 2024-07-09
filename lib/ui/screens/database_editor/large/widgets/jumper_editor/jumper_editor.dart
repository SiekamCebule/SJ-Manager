import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/l10n/jumper_skills_translations.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/jumper.dart';
import 'package:sj_manager/models/jumper_skills.dart';
import 'package:sj_manager/models/sex.dart';
import 'package:sj_manager/repositories/countries/countries_api.dart';
import 'package:sj_manager/ui/responsiveness/ui_main_menu_constants.dart';
import 'package:sj_manager/ui/reusable/countries_dropdown.dart';
import 'package:sj_manager/ui/reusable/text_formatters.dart';

part '__jumps_consistency_dropdown.dart';
part '__sex_segmented_button.dart';
part '__landing_style_dropdown.dart';
part '__text_field.dart';
part '__numeral_text_field.dart';

class JumperEditor extends StatefulWidget {
  const JumperEditor({
    super.key,
    required this.onChange,
    this.forceUpperCaseOnSurname = false,
  });

  final bool forceUpperCaseOnSurname;

  /// Callback executed when some fields change.
  ///
  /// Returns 'null', if has some nullable fields (so jumper is unfinished)
  /// Returns [Jumper] object, if the current jumper is ready to use
  final Function(Jumper? current) onChange;

  @override
  State<JumperEditor> createState() => JumperEditorState();
}

class JumperEditorState extends State<JumperEditor> {
  final _countriesDropdownKey = GlobalKey<CountriesDropdownState>();

  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _ageController;
  late final TextEditingController _qualityOnSmallerHillsController;
  late final TextEditingController _qualityOnLargerHillsController;
  late final TextEditingController _jumpsConsistencyController;
  late final TextEditingController _landingStyleController;

  var _sex = Sex.male;
  JumpsConsistency? _jumpsConsistency;
  LandingStyle? _landingStyle;
  Country? _country;

  @override
  void initState() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _ageController = TextEditingController();
    _qualityOnSmallerHillsController = TextEditingController();
    _qualityOnLargerHillsController = TextEditingController();
    _jumpsConsistencyController = TextEditingController();
    _landingStyleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _ageController.dispose();
    _qualityOnSmallerHillsController.dispose();
    _qualityOnLargerHillsController.dispose();
    _jumpsConsistencyController.dispose();
    _landingStyleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);
    return Form(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              gap,
              Builder(builder: (context) {
                return _TextField(
                  controller: _nameController,
                  onChange: () {
                    widget.onChange(_constructJumper());
                  },
                  formatters: const [
                    CapitalizeTextFormatter(),
                  ],
                  labelText: 'Imię',
                );
              }),
              gap,
              _TextField(
                controller: _surnameController,
                onChange: () {
                  widget.onChange(_constructJumper());
                },
                formatters: [
                  if (widget.forceUpperCaseOnSurname) const UpperCaseTextFormatter(),
                ],
                labelText: 'Nazwisko',
              ),
              gap,
              CountriesDropdown(
                key: _countriesDropdownKey,
                countriesApi: RepositoryProvider.of<CountriesApi>(context),
                onSelected: (maybeCountry) {
                  _country = maybeCountry;
                  widget.onChange(_constructJumper());
                },
              ),
              gap,
              _NumeralTextField(
                controller: _ageController,
                onChange: () {
                  widget.onChange(_constructJumper());
                },
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                labelText: 'Wiek',
                step: 1,
                min: 0,
                max: 99,
              ),
              gap,
              const Divider(),
              gap,
              _JumpsConsistencyDropdown(
                width: constraints.maxWidth,
                controller: _jumpsConsistencyController,
                initial: JumpsConsistency.average,
                onChange: (selected) {
                  _jumpsConsistency = selected!;
                  widget.onChange(_constructJumper());
                },
              ),
              gap,
              _LandingStyleDropdown(
                width: constraints.maxWidth,
                controller: _landingStyleController,
                initial: LandingStyle.average,
                onChange: (selected) {
                  _landingStyle = selected!;
                  widget.onChange(_constructJumper());
                },
              ),
              gap,
              _NumeralTextField(
                controller: _qualityOnSmallerHillsController,
                onChange: () {
                  widget.onChange(_constructJumper());
                },
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\.,]')),
                  const CommaToPeriodEnforcer(),
                  const SinglePeriodEnforcer(),
                ],
                labelText: 'Na mniejszych skoczniach',
                step: 1.0,
                min: 0.0,
                max: 100.0,
              ),
              gap,
              _NumeralTextField(
                controller: _qualityOnLargerHillsController,
                onChange: () {
                  widget.onChange(_constructJumper());
                },
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\.,]')),
                  const CommaToPeriodEnforcer(),
                  const SinglePeriodEnforcer(),
                ],
                labelText: 'Na większych skoczniach',
                step: 1.0,
                // TODO: Set it from the outside
                min: 0.0,
                max: 100.0,
              ),
              gap,
            ],
          );
        },
      ),
    );
  }

  Jumper? _constructJumper() {
    return Jumper(
      name: _nameController.text,
      surname: _surnameController.text,
      country: _country!,
      sex: _sex,
      age: int.parse(_ageController.text),
      skills: JumperSkills(
        qualityOnSmallerHills: double.parse(_qualityOnSmallerHillsController.text),
        qualityOnLargerHills: double.parse(_qualityOnLargerHillsController.text),
        landingStyle: _landingStyle!,
        jumpsConsistency: _jumpsConsistency!,
      ),
    );
  }

  void fillFields(Jumper jumper) {
    _nameController.text = jumper.name;
    _surnameController.text = jumper.surname;
    _ageController.text = jumper.age.toString();
    _qualityOnSmallerHillsController.text =
        jumper.skills.qualityOnSmallerHills.toString();
    _qualityOnLargerHillsController.text = jumper.skills.qualityOnLargerHills.toString();
    setState(() {
      _sex = jumper.sex;
      _jumpsConsistency = jumper.skills.jumpsConsistency;
      _landingStyle = jumper.skills.landingStyle;
    });

    _jumpsConsistencyController.text =
        translatedJumpsConsistencyDescription(context, _jumpsConsistency!);
    _landingStyleController.text =
        translatedLandingStyleDescription(context, _landingStyle!);

    _country = jumper.country;
    _countriesDropdownKey.currentState?.setupManually(jumper.country);
  }
}
