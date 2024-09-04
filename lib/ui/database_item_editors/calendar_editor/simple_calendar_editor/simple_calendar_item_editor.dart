import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
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

class SimpleCalendarItemEditor extends StatefulWidget {
  const SimpleCalendarItemEditor({
    super.key,
  });

  @override
  State<SimpleCalendarItemEditor> createState() => _SimpleCalendarItemEditorState();
}

class _SimpleCalendarItemEditorState extends State<SimpleCalendarItemEditor> {
  late final ScrollController _scrollController;

  Hill? _hill;
  DateTime? _date;
  var _competitionType = CompetitionTypeByEntity.individual;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
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
                    setState(() {
                      _competitionType = selected.single;
                    });
                  },
                ),
                gap,
                Row(
                  children: [
                    MyNumeralTextField(
                        controller: controller,
                        onChange: onChange,
                        labelText: 'Ilość treningów',
                        step: 1,
                        min: 0,
                        max: 10),
                    gap,
                    MyDropdownField(
                        label: Text('Treningi'), onChange: onChange, entries: entries)
                  ],
                ),
                gap,
                MyDropdownField(
                  label: const Text('Seria próbna'),
                  leadingIcon: _iconForCompetitionType(_competitionType.toEntityType()),
                  width: constraints.maxWidth,
                  onChange: (value) {},
                  entries: _constructRulesPresetEntries(type: null),
                ),
                gap,
                MyDropdownField(
                  label: const Text('Kwalifikacje'),
                  leadingIcon: _iconForCompetitionType(_competitionType.toEntityType()),
                  width: constraints.maxWidth,
                  onChange: (value) {},
                  entries:
                      _constructRulesPresetEntries(type: _competitionType.toEntityType()),
                ),
                gap,
                MyDropdownField(
                  label: const Text('Konkurs główny'),
                  leadingIcon: _iconForCompetitionType(_competitionType.toEntityType()),
                  width: constraints.maxWidth,
                  onChange: (value) {},
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

  Widget _iconForCompetitionType(Type type) {
    return Icon(type == Jumper ? Symbols.person : Symbols.group);
  }
}
