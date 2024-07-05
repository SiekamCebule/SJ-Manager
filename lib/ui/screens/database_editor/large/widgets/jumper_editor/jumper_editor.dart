import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/jumper.dart';
import 'package:sj_manager/models/jumper_skills.dart';
import 'package:sj_manager/models/sex.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable/text_formatters.dart';

part '__jumps_consistency_dropdown.dart';
part '__sex_segmented_button.dart';
part '__landing_style_dropdown.dart';
part '__text_field.dart';

class JumperEditor<D> extends StatefulWidget {
  const JumperEditor({
    super.key,
    required this.onChange,
    this.forceUpperCaseOnSurname = false,
  });

  final bool forceUpperCaseOnSurname;
  final Function(Jumper current) onChange;

  @override
  State<JumperEditor> createState() => JumperEditorState();
}

class JumperEditorState extends State<JumperEditor> {
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

  // TODO: Change it
  static const _country = Country(code: 'at', name: 'Austria');

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
    const gap = Gap(UiConstants.verticalSpaceBetweenDatabaseItemEditorFields);
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gap,
          _TextField(
            controller: _nameController,
            onChange: () {
              widget.onChange(_constructJumper());
            },
            formatters: const [
              CapitalizeTextFormatter(),
            ],
            labelText: 'Imię',
          ),
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
          _TextField(
            maxLength: 2,
            controller: _ageController,
            onChange: () {
              widget.onChange(_constructJumper());
            },
            formatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            labelText: 'Wiek',
          ),
          gap,
          const Divider(),
          gap,
          _JumpsConsistencyDropdown(
            controller: _jumpsConsistencyController,
            initial: JumpsConsistency.average,
            onChange: (selected) {
              _jumpsConsistency = selected!;
              widget.onChange(_constructJumper());
            },
          ),
          gap,
          _LandingStyleDropdown(
            controller: _landingStyleController,
            initial: LandingStyle.average,
            onChange: (selected) {
              _landingStyle = selected!;
              widget.onChange(_constructJumper());
            },
          ),
          gap,
          _TextField(
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
          ),
          gap,
          _TextField(
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
          ),
          gap,
        ],
      ),
    );
  }

  Jumper _constructJumper() {
    print('construct a Jumper');
    return Jumper(
      name: _nameController.text,
      surname: _surnameController.text,
      country: _country,
      sex: _sex,
      age: int.tryParse(_ageController.text) ?? 0,
      skills: JumperSkills(
        qualityOnSmallerHills:
            double.tryParse(_qualityOnSmallerHillsController.text) ?? 0,
        qualityOnLargerHills: double.tryParse(_qualityOnLargerHillsController.text) ?? 0,
        landingStyle: _landingStyle ?? LandingStyle.average,
        jumpsConsistency: _jumpsConsistency ?? JumpsConsistency.average,
      ),
    );
  }

  void fillFields(Jumper jumper) {
    print('fill');
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
    _jumpsConsistencyController.text = _jumpsConsistency!.name;
    _landingStyleController.text = _landingStyle!.name;
  }
}
