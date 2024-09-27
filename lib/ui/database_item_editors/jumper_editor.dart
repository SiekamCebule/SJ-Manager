import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/l10n/jumper_skills_translations.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/models/user_db/jumper/jumps_consistency.dart';
import 'package:sj_manager/models/user_db/jumper/landing_style.dart';
import 'package:sj_manager/models/user_db/psyche/personalities.dart';
import 'package:sj_manager/models/user_db/psyche/translations.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_date_form_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_numeral_text_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_field.dart';
import 'package:sj_manager/ui/dialogs/simple_help_dialog.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/countries_dropdown.dart';
import 'package:sj_manager/ui/reusable/text_formatters.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/item_image_not_found_placeholder.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/item_image_help_dialog.dart';
import 'package:sj_manager/utils/context_maybe_read.dart';
import 'package:sj_manager/utils/platform.dart';

class JumperEditor extends StatefulWidget {
  const JumperEditor({
    super.key,
    required this.onChange,
    this.forceUpperCaseOnSurname = false,
    this.enableEditingCountry = true,
    this.enableEditingName = true,
    this.enableEditingSurname = true,
    required this.countriesRepo,
  });

  final bool forceUpperCaseOnSurname;
  final bool enableEditingCountry;
  final bool enableEditingSurname;
  final bool enableEditingName;
  final CountriesRepo countriesRepo;

  final Function(Jumper current) onChange;

  @override
  State<JumperEditor> createState() => JumperEditorState();
}

class JumperEditorState extends State<JumperEditor> {
  final _countriesDropdownKey = GlobalKey<CountriesDropdownState>();

  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _dateOfBirthController;
  late final TextEditingController _personalityController;
  late final TextEditingController _qualityOnSmallerHillsController;
  late final TextEditingController _qualityOnLargerHillsController;
  late final TextEditingController _jumpsConsistencyController;
  late final TextEditingController _landingStyleController;

  static final _dateFormat = DateFormat('d MMM yyyy');

  var _sex = Sex.male;
  var _personality = Personalities.resourceful;
  var _jumpsConsistency = JumpsConsistency.average;
  var _landingStyle = LandingStyle.average;
  Country? _country;

  Jumper? _cachedJumper;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _personalityController = TextEditingController();
    _qualityOnSmallerHillsController = TextEditingController();
    _qualityOnLargerHillsController = TextEditingController();
    _jumpsConsistencyController = TextEditingController();
    _landingStyleController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _dateOfBirthController.dispose();
    _personalityController.dispose();
    _qualityOnSmallerHillsController.dispose();
    _qualityOnLargerHillsController.dispose();
    _jumpsConsistencyController.dispose();
    _landingStyleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldShowImage = _cachedJumper != null &&
            context.maybeRead<DbItemImageGeneratingSetup<Jumper>>() != null;
        return Scrollbar(
          thumbVisibility: platformIsDesktop,
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                gap,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextField(
                            enabled: widget.enableEditingName,
                            controller: _nameController,
                            onChange: _onChange,
                            formatters: const [
                              CapitalizeTextFormatter(),
                            ],
                            labelText: translate(context).personalName,
                          ),
                          gap,
                          MyTextField(
                            enabled: widget.enableEditingSurname,
                            controller: _surnameController,
                            onChange: _onChange,
                            formatters: [
                              if (widget.forceUpperCaseOnSurname)
                                const UpperCaseTextFormatter(),
                              if (!widget.forceUpperCaseOnSurname)
                                const CapitalizeTextFormatter(),
                            ],
                            labelText: translate(context).surname,
                          ),
                          gap,
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return CountriesDropdown(
                                label: const Text('Narodowość'),
                                enabled: widget.enableEditingCountry,
                                width: constraints.maxWidth,
                                key: _countriesDropdownKey,
                                countriesRepo: widget.countriesRepo,
                                onSelected: (maybeCountry) {
                                  _country = maybeCountry;
                                  _onChange();
                                },
                              );
                            },
                          ),
                          gap,
                        ],
                      ),
                    ),
                    const Gap(UiItemEditorsConstants.itemImageHorizontalMargin),
                    if (shouldShowImage)
                      Expanded(
                        flex: 4,
                        child: DbItemImage<Jumper>(
                          item: _cachedJumper!,
                          setup: context.read(),
                          height: UiItemEditorsConstants.jumperImageHeight,
                          fit: BoxFit.fitHeight,
                          errorBuilder: (_, __, ___) => ItemImageNotFoundPlaceholder(
                            width: UiItemEditorsConstants.jumperImagePlaceholderWidth,
                            height: UiItemEditorsConstants.jumperImageHeight,
                            helpDialog: ItemImageHelpDialog(
                              content: translate(context).jumperImageHelpContent,
                            ),
                          ),
                        ),
                      ),
                    if (shouldShowImage)
                      const Gap(UiItemEditorsConstants.itemImageHorizontalMargin),
                  ],
                ),
                MyDateFormField(
                  controller: _dateOfBirthController,
                  onChange: (date) {
                    _dateOfBirthController.text = _dateFormat.format(date!);
                    _onChange();
                  },
                  dateFormat: _dateFormat,
                  labelText: 'Data urodzenia',
                  initialDate: DateTime.now().subtract(
                    Duration(
                      days: (daysInYear * 24).toInt(),
                    ),
                  ),
                  firstDate: DateTime.now().subtract(
                    Duration(
                      days: (daysInYear * 100).toInt(),
                    ),
                  ),
                  lastDate: DateTime.now().add(Duration(
                    days: (daysInYear * 100).toInt(),
                  )),
                ),
                gap,
                MyDropdownField(
                  controller: _personalityController,
                  onChange: (personality) {
                    _personality = personality!;
                    _onChange();
                  },
                  entries: sjmPersonalities.map((personality) {
                    return DropdownMenuEntry(
                      value: personality,
                      label: personalityName(
                        context: context,
                        personality: personality,
                      ),
                    );
                  }).toList(),
                  width: constraints.maxWidth,
                  initial: Personalities.resourceful,
                  label: const Text('Charakter'),
                  onHelpButtonTap: () {
                    showSimpleHelpDialog(
                      context: context,
                      title: 'Charakter',
                      content:
                          'Skoczkowie i skoczkinie mają swój indywidualny charakter, który wpływa na podejście do skakania, ale też na podejmowane przez nich decyzje życiowe. Każdy charakter odpowiada jakiemuś poziomowi świadomości z Mapy Poziomów Świadomości amerykańskiego psychiatry Davida Hawkinsa.',
                    );
                  },
                ),
                gap,
                const Divider(),
                gap,
                MyDropdownField(
                  controller: _jumpsConsistencyController,
                  onChange: (selected) {
                    _jumpsConsistency = selected!;
                    _onChange();
                  },
                  entries: JumpsConsistency.values.map((consistency) {
                    return DropdownMenuEntry(
                        value: consistency,
                        label:
                            translatedJumpsConsistencyDescription(context, consistency));
                  }).toList(),
                  width: constraints.maxWidth,
                  initial: JumpsConsistency.average,
                  label: Text(translate(context).jumps),
                  onHelpButtonTap: () {
                    showSimpleHelpDialog(
                        context: context,
                        title: 'Równość skoków',
                        content:
                            'Szansa zawodnika na oddanie kilku równych skoków. Nie mylić z długoterminową równością formy.');
                  },
                ),
                gap,
                MyDropdownField(
                  controller: _landingStyleController,
                  onChange: (selected) {
                    _landingStyle = selected!;
                    _onChange();
                  },
                  entries: LandingStyle.values.map((style) {
                    return DropdownMenuEntry(
                        value: style,
                        label: translatedLandingStyleDescription(context, style));
                  }).toList(),
                  width: constraints.maxWidth,
                  initial: LandingStyle.average,
                  label: Text(translate(context).landing),
                  onHelpButtonTap: () {
                    showSimpleHelpDialog(
                        context: context,
                        title: 'Styl lądowania',
                        content:
                            'Przekłada się to na wysokość not sędziowskich. Ma też pewien wpływ na odporność przed upadkami.'); // TODO: Verify that info
                  },
                ),
                gap,
                MyNumeralTextField(
                  controller: _qualityOnSmallerHillsController,
                  onChange: _onChange,
                  formatters: doubleTextInputFormatters,
                  labelText: translate(context).onSmallerHills,
                  step: 1.0,
                  min: 0.0,
                  max: context.read<DbEditingDefaultsRepo>().maxJumperQualitySkill,
                  maxDecimalPlaces: 2,
                  onHelpButtonTap: () {
                    showSimpleHelpDialog(
                        context: context,
                        title: 'Jakość na mniejszych skoczniach',
                        content:
                            'Decyduje o odległościach na mniejszych skoczniach, choć ma znaczenie również na skoczniach większych');
                  },
                ),
                gap,
                MyNumeralTextField(
                  controller: _qualityOnLargerHillsController,
                  onChange: _onChange,
                  formatters: doubleTextInputFormatters,
                  labelText: translate(context).onLargerHills,
                  step: 1.0,
                  min: 0.0,
                  max: context.read<DbEditingDefaultsRepo>().maxJumperQualitySkill,
                  maxDecimalPlaces: 2,
                  onHelpButtonTap: () {
                    showSimpleHelpDialog(
                        context: context,
                        title: 'Jakość na większych skoczniach',
                        content:
                            'Decyduje o odległościach na większych skoczniach, choć ma znaczenie również na skoczniach mniejszych. Wysoką wartością odznaczają się tak zwani "lotnicy" i "lotniczki"');
                  },
                ),
                gap,
              ],
            ),
          ),
        );
      },
    );
  }

  void _onChange() {
    widget.onChange(_constructAndCacheJumper());
  }

  Jumper _constructAndCacheJumper() {
    final name = _nameController.text;
    final surname = _surnameController.text;
    final country = _country!;

    final dateOfBirth = _dateFormat.parse(_dateOfBirthController.text);
    print('pers2: $_personality');

    final skills = JumperSkills(
      qualityOnSmallerHills: double.parse(_qualityOnSmallerHillsController.text),
      qualityOnLargerHills: double.parse(_qualityOnLargerHillsController.text),
      landingStyle: _landingStyle,
      jumpsConsistency: _jumpsConsistency,
    );
    final jumper = _sex == Sex.male
        ? MaleJumper(
            name: name,
            surname: surname,
            country: country,
            dateOfBirth: dateOfBirth,
            personality: _personality,
            skills: skills,
          )
        : FemaleJumper(
            name: name,
            surname: surname,
            country: country,
            dateOfBirth: dateOfBirth,
            personality: _personality,
            skills: skills,
          );
    _cachedJumper = jumper;
    return jumper;
  }

  void setUp(Jumper jumper) {
    setState(() {
      _cachedJumper = jumper;
    });
    _fillFields(jumper);
    FocusScope.of(context).unfocus();
  }

  void _fillFields(Jumper jumper) {
    _nameController.text = jumper.name;
    _surnameController.text = jumper.surname;
    _dateOfBirthController.text = _dateFormat.format(jumper.dateOfBirth);
    _qualityOnSmallerHillsController.text =
        jumper.skills.qualityOnSmallerHills.toString();
    _qualityOnLargerHillsController.text = jumper.skills.qualityOnLargerHills.toString();
    setState(() {
      _sex = jumper.sex;
    });

    print('pers: ${jumper.personality}');
    _personality = jumper.personality;
    _jumpsConsistency = jumper.skills.jumpsConsistency;
    _landingStyle = jumper.skills.landingStyle;
    _personalityController.text =
        personalityName(context: context, personality: _personality);
    _jumpsConsistencyController.text =
        translatedJumpsConsistencyDescription(context, _jumpsConsistency);
    _landingStyleController.text =
        translatedLandingStyleDescription(context, _landingStyle);

    _country = jumper.country;
    _countriesDropdownKey.currentState?.setManually(jumper.country);
  }
}
