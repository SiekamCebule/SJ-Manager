import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_numeral_text_field.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/utils/colors.dart';
import 'package:sj_manager/utils/platform.dart';

class DefaultCompetitionRulesEditor extends StatefulWidget {
  const DefaultCompetitionRulesEditor({
    super.key,
    this.scrollable = false,
    required this.onChange,
    required this.onAdvancedEditorChosen,
    this.addGapsOnFarSides = true,
  });

  final bool scrollable;
  final Function(DefaultCompetitionRules current) onChange;
  final VoidCallback onAdvancedEditorChosen;
  final bool addGapsOnFarSides;

  @override
  State<DefaultCompetitionRulesEditor> createState() =>
      DefaultCompetitionRulesEditorState();
}

class DefaultCompetitionRulesEditorState extends State<DefaultCompetitionRulesEditor> {
  late final TextEditingController _entitiesLimitCountController;
  late final TextEditingController _entitiesLimitTypeController;
  late final TextEditingController _judgesCountController;
  late final ScrollController _scrollController;

  DefaultCompetitionRules? _cachedRules;
  var _competitionType = _CompetitionType.individual;
  int _roundsCount = 0;
  int? _selectedRoundIndex;
  EntitiesLimitType? _entitiesLimitType;

  @override
  void initState() {
    _scrollController = ScrollController();
    _entitiesLimitCountController = TextEditingController();
    _entitiesLimitTypeController = TextEditingController();
    _judgesCountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entitiesLimitCountController.dispose();
    _entitiesLimitTypeController.dispose();
    _judgesCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);

    final mainBody = Column(
      children: [
        if (widget.addGapsOnFarSides) gap,
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
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
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
                                  final selected = index == _selectedRoundIndex;
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                    selectedColor:
                                        Theme.of(context).colorScheme.onSurfaceVariant,
                                    selected: selected,
                                    title: Text('Runda ${index + 1}'),
                                    onTap: () {
                                      _selectRound(roundIndex: index);
                                    },
                                    trailing: selected
                                        ? IconButton(
                                            icon: const Icon(Symbols.delete),
                                            onPressed: () {},
                                          )
                                        : null,
                                  );
                                },
                              ),
                            ),
                            const Gap(5),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () => _addRoundAt(_selectedRoundIndex!),
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
                gap,
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: MyNumeralTextField(
                          controller: _entitiesLimitCountController,
                          onChange: _onChange,
                          labelText: _competitionType == _CompetitionType.individual
                              ? 'Limit zawodników'
                              : 'Limit drużyn',
                          step: 1,
                          min: 1,
                          max: 100000,
                          skipPlusMinusButtons: true,
                        ),
                      ),
                      const Gap(10),
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
        ),
      ],
    );

    return widget.scrollable
        ? LayoutBuilder(builder: (context, constraints) {
            return Scrollbar(
              thumbVisibility: platformIsDesktop,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: mainBody,
                ),
              ),
            );
          })
        : mainBody;
  }

  void _addRoundAt(int index) {
    final DefaultCompetitionRoundRules defaultItem = _competitionType ==
            _CompetitionType.individual
        ? context.read<DefaultItemsRepo>().get<DefaultIndividualCompetitionRoundRules>()
        : context.read<DefaultItemsRepo>().get<DefaultTeamCompetitionRoundRules>();
    setState(() {
      _roundsCount++;
      _cachedRules!.rounds.insert(index, defaultItem);
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

  DefaultCompetitionRules _constructAndCache() {
    final rounds = List.of(_cachedRules!.rounds);
    //rounds[_selectedRoundIndex!] = _constructCurrentRound(); TODO
    final rules = _competitionType == _CompetitionType.individual
        ? DefaultCompetitionRules<Jumper>(
            rounds: rounds.cast(),
          )
        : DefaultCompetitionRules<CompetitionTeam>(
            rounds: rounds.cast(),
          );
    _cachedRules = rules;
    return rules;
  }

  DefaultCompetitionRoundRules _constructCurrentRound() {
    final limit = EntitiesLimit(
      count: int.parse(_entitiesLimitCountController.text),
      type: _entitiesLimitType!,
    );
    throw UnimplementedError();
    /*return switch (_competitionType) {
      _CompetitionType.individual => DefaultIndividualCompetitionRoundRules(
          limit: limit,
          bibsAreReassigned: bibsAreReassigned,
          gateCanChange: gateCanChange,
          windAverager: windAverager,
          inrunLightsEnabled: inrunLightsEnabled,
          dsqEnabled: dsqEnabled,
          positionsCreator: positionsCreator,
          canBeCancelledByWind: canBeCancelledByWind,
          ruleOf95HsFallEnabled: ruleOf95HsFallEnabled,
          judgesCount: judgesCount,
          competitionScoreCreator: competitionScoreCreator,
          jumpScoreCreator: jumpScoreCreator,
          significantJudgesChooser: significantJudgesChooser,
        ),
    };*/
  }

  void setUp(DefaultCompetitionRules rules) {
    setState(() {
      _cachedRules = rules;
      _fillFields(rules);
      FocusScope.of(context).unfocus();
    });
  }

  void _fillFields(DefaultCompetitionRules rules) {
    _competitionType = rules.competitionRules is DefaultCompetitionRules<Jumper>
        ? _CompetitionType.individual
        : _CompetitionType.team;
  }
}

enum _CompetitionType {
  individual,
  team,
}
