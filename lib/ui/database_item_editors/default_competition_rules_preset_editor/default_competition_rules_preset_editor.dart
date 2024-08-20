import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_numeral_text_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_field.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/utils/colors.dart';
import 'package:sj_manager/utils/platform.dart';

class DefaultCompetitionRulesPresetEditor extends StatefulWidget {
  const DefaultCompetitionRulesPresetEditor({
    super.key,
    required this.onChange,
    required this.onAdvancedEditorChosen,
  });

  final Function(DefaultCompetitionRulesPreset current) onChange;
  final VoidCallback onAdvancedEditorChosen;

  @override
  State<DefaultCompetitionRulesPresetEditor> createState() =>
      _DefaultCompetitionRulesPresetEditorState();
}

class _DefaultCompetitionRulesPresetEditorState
    extends State<DefaultCompetitionRulesPresetEditor> {
  late final TextEditingController _nameController;
  late final TextEditingController _entitiesLimitCountController;
  late final TextEditingController _entitiesLimitTypeController;
  late final TextEditingController _judgesCountController;

  DefaultCompetitionRulesPreset? _cachedPreset;

  var _competitionType = _CompetitionType.individual;
  int _roundsCount = 0;
  int? _selectedRoundIndex;
  EntitiesLimitType? _entitiesLimitType;

  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _nameController = TextEditingController();
    _entitiesLimitCountController = TextEditingController();
    _entitiesLimitTypeController = TextEditingController();
    _judgesCountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _entitiesLimitCountController.dispose();
    _entitiesLimitTypeController.dispose();
    _judgesCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);
    final shouldShowBodyForRounds = _roundsCount > 0;
    return LayoutBuilder(
      builder: (context, constraints) => Scrollbar(
        thumbVisibility: platformIsDesktop,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            height: constraints.maxHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gap,
                MyTextField(
                  controller: _nameController,
                  onChange: _onChange,
                  labelText: translate(context).name,
                ),
                gap,
                Center(
                  child: SegmentedButton(
                    segments: const [
                      ButtonSegment(
                        value: _CompetitionType.individual,
                        icon: Icon(Symbols.person),
                        label: Text('Indywidualny'),
                      ),
                      ButtonSegment(
                        value: _CompetitionType.team,
                        icon: Icon(Symbols.group),
                        label: Text('Drużynowy'),
                      ),
                    ],
                    selected: {_competitionType},
                    onSelectionChanged: (selected) {
                      setState(() {
                        _competitionType = selected.single;
                      });
                      _onChange();
                    },
                  ),
                ),
                gap,
                Expanded(
                  child: shouldShowBodyForRounds
                      ? Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Flexible(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: _roundsCount,
                                                  itemBuilder: (context, index) {
                                                    final selected =
                                                        index == _selectedRoundIndex;
                                                    return ListTile(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(10),
                                                      ),
                                                      splashColor: Theme.of(context)
                                                          .colorScheme
                                                          .surfaceContainerHigh,
                                                      selectedTileColor: Theme.of(context)
                                                          .colorScheme
                                                          .tertiaryContainer
                                                          .blendWithBg(
                                                            Theme.of(context).brightness,
                                                            0.2,
                                                          ),
                                                      selectedColor: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                      selected: selected,
                                                      title: Text('Runda ${index + 1}'),
                                                      onTap: () {
                                                        _selectRound(roundIndex: index);
                                                      },
                                                      trailing: selected
                                                          ? const Icon(Symbols.delete)
                                                          : null,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: TextButton.icon(
                                                  onPressed: _addRound,
                                                  label: const Text('Dodaj rundę'),
                                                  icon: const Icon(Symbols.add),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: MyNumeralTextField(
                                            controller: _entitiesLimitCountController,
                                            onChange: _onChange,
                                            labelText: _competitionType ==
                                                    _CompetitionType.individual
                                                ? 'Limit zawodników'
                                                : 'Limit drużyn',
                                            step: 1,
                                            min: 1,
                                            max: 100000,
                                          ),
                                        ),
                                        MyDropdownField(
                                          controller: _entitiesLimitTypeController,
                                          entries: const [
                                            DropdownMenuEntry(
                                              value: null,
                                              label: 'Brak limitu',
                                            ),
                                            DropdownMenuEntry(
                                              value: EntitiesLimitType.soft,
                                              label: 'Miękki',
                                            ),
                                            DropdownMenuEntry(
                                              value: EntitiesLimitType.exact,
                                              label: 'Dosłowny',
                                            ),
                                          ],
                                          onChange: (value) {
                                            setState(() {
                                              _entitiesLimitType = value;
                                            });
                                          },
                                        ),
                                        HelpIconButton(
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                  // TODO: Round editor
                                ],
                              ),
                            ),
                            const Gap(20),
                          ],
                        )
                      : Center(
                          child: SizedBox(
                            width: 300,
                            height: 200,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton.icon(
                                  onPressed: _addRound,
                                  label: Text(
                                    'Dodaj pierwszą rundę',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  icon: Icon(
                                    Symbols.add,
                                    size: 50,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addRound() {
    setState(() {
      _roundsCount++;
    });
  }

  void _selectRound({required int roundIndex}) {
    setState(() {
      _selectedRoundIndex = roundIndex;
    });
  }

  void _onChange() {
    widget.onChange(_constructAndCache());
  }

  DefaultCompetitionRulesPreset _constructAndCache() {
    final rules = _competitionType == _CompetitionType.individual
        ? DefaultCompetitionRules<Jumper>(
            rounds: _constructRounds().cast(),
          )
        : DefaultCompetitionRules<Team>(
            rounds: _constructRounds().cast(),
          );
    final preset =
        DefaultCompetitionRulesPreset(name: _nameController.text, rules: rules);
    return preset;
  }

  List<DefaultCompetitionRoundRules> _constructRounds() {
    final rounds = <DefaultCompetitionRoundRules>[];
    for (var roundIndex = 0; roundIndex < _roundsCount; roundIndex++) {}
    return rounds;
  }

  void setUp(DefaultCompetitionRulesPreset preset) {
    setState(() {
      _cachedPreset = preset;
      _fillFields(preset);
      FocusScope.of(context).unfocus();
    });
  }

  void _fillFields(DefaultCompetitionRulesPreset preset) {
    _nameController.text = preset.name;
    _competitionType = preset.competitionRules is DefaultCompetitionRules<Jumper>
        ? _CompetitionType.individual
        : _CompetitionType.team;
  }
}

enum _CompetitionType {
  individual,
  team,
}
