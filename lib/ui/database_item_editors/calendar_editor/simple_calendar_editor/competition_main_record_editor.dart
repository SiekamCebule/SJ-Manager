import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/ui/database_item_editors/default_competition_rules_preset_editor/default_competition_rules_editor.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_numeral_text_field.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/utils/platform.dart';
import 'package:provider/provider.dart';

class CompetitionMainRecordEditor extends StatefulWidget {
  const CompetitionMainRecordEditor({
    super.key,
    required this.onChange,
  });

  final void Function(CalendarMainCompetitionRecord record) onChange;

  @override
  State<CompetitionMainRecordEditor> createState() => _CompetitionMainRecordEditorState();
}

class _CompetitionMainRecordEditorState extends State<CompetitionMainRecordEditor> {
  late final ScrollController _scrollController;
  late TextEditingController _hillController;
  late TextEditingController _dateController;
  late TextEditingController _trainingsCountController;
  late TextEditingController _trainingsRulesProviderController;
  late TextEditingController _trialRoundRulesProviderController;

  late TextEditingController _qualsRulesProviderController;
  late TextEditingController _mainCompetitionRulesProviderController;

  CalendarMainCompetitionRecord? _cached;
  Hill? _hill;
  DateTime? _date;
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
    _dateController = TextEditingController();
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
    _dateController.dispose();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                gap,
                MyDropdownField(
                  onChange: (value) {
                    _hill = value!;
                    _onChange();
                  },
                  entries: _constructHillEntries(),
                  label: const Text('Skocznia'),
                  requestFocusOnTap: true,
                  enableSearch: true,
                ),
                gap,
                InputDatePickerFormField(
                  initialDate: DateTime.now(),
                  firstDate: context.read<DbEditingDefaultsRepo>().firstDate,
                  lastDate: context.read<DbEditingDefaultsRepo>().lastDate,
                  onDateSaved: (value) {
                    _date = value;
                    _onChange();
                  },
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
                    _competitionType = selected.single;
                    _onChange();
                  },
                ),
                gap,
                Row(
                  children: [
                    MyNumeralTextField(
                        controller: _trainingsCountController,
                        onChange: () {
                          _onChange();
                        },
                        labelText: 'Ilość treningów',
                        step: 1,
                        min: 0,
                        max: 10),
                    gap,
                    MyDropdownField(
                      label: const Text('Treningi'),
                      onChange: (value) {
                        _trainingsRulesProvider = value;
                        _onChange();
                      },
                      entries: _constructRulesPresetEntries(type: null),
                    ),
                  ],
                ),
                gap,
                MyDropdownField(
                  label: const Text('Seria próbna'),
                  leadingIcon: _iconForCompetitionType(_competitionType.toEntityType()),
                  width: constraints.maxWidth,
                  onChange: (value) {
                    _trialRoundRulesProvider = value;
                    _onChange();
                  },
                  entries: _constructRulesPresetEntries(type: null),
                ),
                gap,
                MyDropdownField(
                  label: const Text('Kwalifikacje'),
                  leadingIcon: _iconForCompetitionType(_competitionType.toEntityType()),
                  width: constraints.maxWidth,
                  onChange: (value) {
                    _qualsRulesProvider = value;
                    _onChange();
                  },
                  entries:
                      _constructRulesPresetEntries(type: _competitionType.toEntityType()),
                ),
                gap,
                MyDropdownField(
                  label: const Text('Konkurs główny'),
                  leadingIcon: _iconForCompetitionType(_competitionType.toEntityType()),
                  width: constraints.maxWidth,
                  onChange: (value) {
                    _mainCompetitionRulesProvider = value;
                    _onChange();
                  },
                  entries:
                      _constructRulesPresetEntries(type: _competitionType.toEntityType()),
                ),
                gap,
              ],
            ),
          ),
        );
      },
    );
  }

  List<DropdownMenuEntry<Hill>> _constructHillEntries() {
    final localDb = context.watch<ItemsReposRegistry>();
    final hills = localDb.get<Hill>().last;
    return hills.map((hill) {
      return DropdownMenuEntry(
        value: hill,
        label: hill.toString(),
        leadingIcon: CountryFlag(country: hill.country),
      );
    }).toList();
  }

  List<DropdownMenuEntry<DefaultCompetitionRulesPreset>> _constructRulesPresetEntries({
    required Type? type,
  }) {
    final localDb = context.watch<ItemsReposRegistry>();
    final rulesPresets = localDb.get<DefaultCompetitionRulesPreset>().last.where(
          (preset) => (preset.runtimeType == type) || type == null,
        );
    return rulesPresets.map((preset) {
      final presetType = preset is DefaultCompetitionRulesPreset<Jumper> ? Jumper : Team;
      return DropdownMenuEntry(
        value: preset,
        label: preset.name,
        leadingIcon: _iconForCompetitionType(presetType),
      );
    }).toList();
  }

  void _onChange() {
    // TODO: validate fields
    widget.onChange(_constructAndCache());
  }

  CalendarMainCompetitionRecord _constructAndCache() {
    final record = CalendarMainCompetitionRecord(
      hill: _hill!,
      date: _date!,
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
    });
    _fillFields(record);
    FocusScope.of(context).unfocus();
  }

  void _fillFields(CalendarMainCompetitionRecord record) {
    _hillController.text = record.hill.toString();
    _dateController.text = record.date.toString();
    _trainingsCountController.text = record.setup.trainingsCount.toString();
    _trainingsRulesProviderController.text =
        (record.setup.trainingsRules as DefaultCompetitionRulesPreset).name;
    _trialRoundRulesProviderController.text =
        (record.setup.trialRoundRules as DefaultCompetitionRulesPreset).name;
    _qualsRulesProviderController.text =
        (record.setup.qualificationsRules as DefaultCompetitionRulesPreset).name;
    _mainCompetitionRulesProviderController.text =
        (record.setup.mainCompRules as DefaultCompetitionRulesPreset).name;
  }

  Widget _iconForCompetitionType(Type type) {
    return Icon(type == Jumper ? Symbols.person : Symbols.group);
  }
}
