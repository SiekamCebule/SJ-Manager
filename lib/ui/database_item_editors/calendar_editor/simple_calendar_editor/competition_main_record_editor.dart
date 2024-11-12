import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/simulation/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/models/database/hill/hill.dart';
import 'package:sj_manager/models/database/items_repos_registry.dart';
import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/ui/database_item_editors/default_competition_rules_preset_editor/default_competition_rules_editor.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_form_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_numeral_text_field.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/ui/reusable_widgets/none_dropdown_entry.dart';
import 'package:sj_manager/utils/platform.dart';
import 'package:provider/provider.dart';

class CompetitionMainRecordEditor extends StatefulWidget {
  const CompetitionMainRecordEditor({
    super.key,
    required this.onChange,
  });

  final void Function(CalendarMainCompetitionRecord record) onChange;

  @override
  State<CompetitionMainRecordEditor> createState() => CompetitionMainRecordEditorState();
}

class CompetitionMainRecordEditorState extends State<CompetitionMainRecordEditor> {
  final _mainCompetitionRulesProviderFieldKey = GlobalKey<FormFieldState>();
  final _hillFieldKey = GlobalKey<FormFieldState>();

  late final ScrollController _scrollController;
  late TextEditingController _hillController;
  late TextEditingController _trainingsCountController;
  late TextEditingController _trainingsRulesProviderController;
  late TextEditingController _trialRoundRulesProviderController;

  late TextEditingController _qualsRulesProviderController;
  late TextEditingController _mainCompetitionRulesProviderController;

  CalendarMainCompetitionRecord? _cached;
  Hill? _hill;
  var _competitionType = CompetitionTypeByEntity.individual;
  int get _trainingsCount => int.parse(_trainingsCountController.text);
  DefaultCompetitionRulesProvider? _mainCompetitionRulesProvider;
  DefaultCompetitionRulesProvider? _qualsRulesProvider;
  DefaultCompetitionRulesProvider? _trialRoundRulesProvider;
  DefaultCompetitionRulesProvider? _trainingsRulesProvider;

  @override
  void initState() {
    _scrollController = ScrollController();
    _hillController = TextEditingController();
    _trainingsCountController = TextEditingController();
    _trainingsRulesProviderController = TextEditingController();
    _trialRoundRulesProviderController = TextEditingController();
    _qualsRulesProviderController = TextEditingController();
    _mainCompetitionRulesProviderController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hillController.dispose();
    _trainingsCountController.dispose();
    _trainingsRulesProviderController.dispose();
    _trialRoundRulesProviderController.dispose();
    _qualsRulesProviderController.dispose();

    _mainCompetitionRulesProviderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          thumbVisibility: platformIsDesktop,
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                gap,
                MyDropdownFormField(
                  formKey: _hillFieldKey,
                  controller: _hillController,
                  initial: _hill,
                  onChange: (value) {
                    _hill = value!;
                    _onChange();
                  },
                  validator: (value) {
                    if (value == null) {
                      _hill = _cached?.hill;
                      return null;
                    }
                    return null;
                  },
                  width: constraints.maxWidth,
                  entries: _constructHillEntries(required: true),
                  label: const Text('Skocznia'),
                  requestFocusOnTap: true,
                  enableSearch: true,
                ),
                gap,
                SegmentedButton(
                  segments: const [
                    ButtonSegment(
                      value: CompetitionTypeByEntity.individual,
                      icon: Icon(Symbols.person),
                      label: Text('Indywidualny'),
                    ),
                    ButtonSegment(
                      value: CompetitionTypeByEntity.team,
                      icon: Icon(Symbols.group),
                      label: Text('Drużynowy'),
                    ),
                  ],
                  selected: {_competitionType},
                  onSelectionChanged: (selected) {
                    setState(() {
                      _competitionType = selected.single;
                      _onChange();
                    });
                  },
                ),
                gap,
                Row(
                  children: [
                    Expanded(
                      child: MyNumeralTextField(
                          controller: _trainingsCountController,
                          onChange: () {
                            _onChange();
                          },
                          labelText: 'Ilość treningów',
                          step: 1,
                          min: 0,
                          max: 10),
                    ),
                    gap,
                    Expanded(
                      child: MyDropdownField(
                        label: const Text('Treningi'),
                        controller: _trainingsRulesProviderController,
                        onChange: (value) {
                          _trainingsRulesProvider = value;
                          _onChange();
                        },
                        entries:
                            _constructRulesPresetEntries(type: null, required: false),
                      ),
                    ),
                  ],
                ),
                gap,
                MyDropdownField(
                  label: const Text('Seria próbna'),
                  controller: _trialRoundRulesProviderController,
                  leadingIcon: _iconForCompetitionType(_competitionType.toEntityType()),
                  width: constraints.maxWidth,
                  onChange: (value) {
                    _trialRoundRulesProvider = value;
                    _onChange();
                  },
                  entries: _constructRulesPresetEntries(type: null, required: false),
                ),
                gap,
                MyDropdownField(
                  label: const Text('Kwalifikacje'),
                  controller: _qualsRulesProviderController,
                  leadingIcon: _iconForCompetitionType(_competitionType.toEntityType()),
                  width: constraints.maxWidth,
                  onChange: (value) {
                    _qualsRulesProvider = value;
                    _onChange();
                  },
                  entries: _constructRulesPresetEntries(
                    type: _competitionType.toEntityType(),
                    required: false,
                  ),
                ),
                gap,
                MyDropdownFormField(
                  formKey: _mainCompetitionRulesProviderFieldKey,
                  controller: _mainCompetitionRulesProviderController,
                  label: const Text('Konkurs główny'),
                  leadingIcon: _iconForCompetitionType(_competitionType.toEntityType()),
                  width: constraints.maxWidth,
                  onChange: (value) {
                    _mainCompetitionRulesProvider = value;
                    _onChange();
                  },
                  initial: _mainCompetitionRulesProvider,
                  validator: (value) {
                    if (value == null) {
                      _mainCompetitionRulesProvider = _cached?.setup.mainCompRules;
                      return null;
                    }
                    return null;
                  },
                  entries: _constructRulesPresetEntries(
                    type: _competitionType.toEntityType(),
                    required: true,
                  ),
                ),
                gap,
              ],
            ),
          ),
        );
      },
    );
  }

  List<DropdownMenuEntry<Hill?>> _constructHillEntries({
    required bool required,
  }) {
    final localDb = context.watch<ItemsReposRegistry>();
    final hills = localDb.get<Hill>().last;
    return [
      if (!required) noneDropdownEntry(context),
      ...hills.map((hill) {
        return DropdownMenuEntry(
          value: hill,
          label: hill.toString(),
          leadingIcon: CountryFlag(
            country: hill.country,
            width: 24,
          ),
        );
      }),
    ];
  }

  List<DropdownMenuEntry<DefaultCompetitionRulesPreset?>> _constructRulesPresetEntries({
    required Type? type,
    required bool required,
  }) {
    final localDb = context.watch<ItemsReposRegistry>();
    final rulesPresets = localDb.get<DefaultCompetitionRulesPreset>().last.where(
          (preset) => (preset.entityType == type) || type == null,
        );
    return [
      if (!required) noneDropdownEntry(context),
      ...rulesPresets.map((preset) {
        return DropdownMenuEntry(
          value: preset,
          label: preset.name,
          leadingIcon: _iconForCompetitionType(preset.entityType),
        );
      }),
    ];
  }

  void _onChange() {
    if (_validateFields()) {
      widget.onChange(_constructAndCache());
    }
  }

  bool _validateFields() {
    final conditions = [
      _mainCompetitionRulesProviderFieldKey.currentState!.validate(),
      _hillFieldKey.currentState!.validate(),
    ];
    return conditions.every((condition) => condition == true);
  }

  CalendarMainCompetitionRecord _constructAndCache() {
    final record = CalendarMainCompetitionRecord(
      hill: _hill!,
      date: null,
      setup: CalendarMainCompetitionRecordSetup(
        mainCompRules: _mainCompetitionRulesProvider!,
        qualificationsRules: _qualsRulesProvider,
        trialRoundRules: _trialRoundRulesProvider,
        trainingsCount: _trainingsCount,
        trainingsRules: _trainingsRulesProvider,
      ),
    );
    _cached = record;
    return record;
  }

  void setUp(CalendarMainCompetitionRecord record) {
    setState(() {
      _cached = record;
      _competitionType = _cached!.setup.typeByEntity;
    });
    _fillFields(record);
    FocusScope.of(context).unfocus();
  }

  void _fillFields(CalendarMainCompetitionRecord record) {
    final noneText = noneDropdownEntry(context).label;
    _hillController.text = record.hill.toString();
    _trainingsCountController.text = record.setup.trainingsCount.toString();
    _trainingsRulesProviderController.text =
        (record.setup.trainingsRules as DefaultCompetitionRulesPreset?)?.name ?? noneText;
    _trialRoundRulesProviderController.text =
        (record.setup.trialRoundRules as DefaultCompetitionRulesPreset?)?.name ??
            noneText;
    _qualsRulesProviderController.text =
        (record.setup.qualificationsRules as DefaultCompetitionRulesPreset?)?.name ??
            noneText;
    _mainCompetitionRulesProviderController.text =
        (record.setup.mainCompRules as DefaultCompetitionRulesPreset).name;
  }

  Widget _iconForCompetitionType(Type type) {
    return Icon(type == JumperDbRecord ? Symbols.person : Symbols.group);
  }
}
