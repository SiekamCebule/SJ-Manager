import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/json/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/wind_averager.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_avaiable_objects_repo.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_checkbox_list_tile_field.dart';
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
  late final TextEditingController _significantJudgesCountController;
  late final ScrollController _scrollController;

  DefaultCompetitionRules? _cachedRules;
  var _competitionType = _CompetitionType.individual;
  var _roundsCount = 0;
  var _selectedRoundIndex = 0;
  EntitiesLimitType? _entitiesLimitType;
  bool bibsAreReassigned = false;
  bool gateCanChange = false;
  bool inrunLightsEnabled = false;
  bool dsqEnabled = false;
  bool ruleOf95HsEnabled = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _entitiesLimitCountController = TextEditingController();
    _entitiesLimitTypeController = TextEditingController();
    _judgesCountController = TextEditingController();
    _significantJudgesCountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entitiesLimitCountController.dispose();
    _entitiesLimitTypeController.dispose();
    _judgesCountController.dispose();
    _significantJudgesCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);
    print('comp type: $_competitionType');

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
              WidgetsBinding.instance.addPostFrameCallback((_) => _onChange);
            },
          ),
        ),
        const Divider(
          height: UiItemEditorsConstants.verticalSpaceBetweenFields * 2.5,
        ),
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
                                            onPressed: () {
                                              _removeRoundAt(index);
                                            },
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
                gap,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
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
                            ),
                          ),
                          const Gap(10),
                          MyDropdownField(
                            controller: _entitiesLimitTypeController,
                            label: const Text('Rodzaj limitu'),
                            entries: [
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
                          const Gap(UiFieldWidgetsConstants.gapBetweenFieldAndHelpButton),
                          HelpIconButton(
                            onPressed: () {},
                          ),
                        ],
                      ),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: MyCheckboxListTileField(
                              title: const Text('Ponowne przypisanie BIBs'),
                              value: bibsAreReassigned,
                              onChange: (value) => setState(
                                () {
                                  bibsAreReassigned = value!;
                                },
                              ),
                            ),
                          ),
                          gap,
                          Flexible(
                            child: MyCheckboxListTileField(
                              title: const Text('Zmiana belki'),
                              value: gateCanChange,
                              onChange: (value) => setState(
                                () {
                                  gateCanChange = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: MyCheckboxListTileField(
                              title: const Text('Światełko startowe'),
                              value: inrunLightsEnabled,
                              onChange: (value) => setState(
                                () {
                                  inrunLightsEnabled = value!;
                                },
                              ),
                            ),
                          ),
                          gap,
                          Flexible(
                            child: MyCheckboxListTileField(
                              title: const Text('Możliwość dyskwalifikacji'),
                              value: dsqEnabled,
                              onChange: (value) => setState(
                                () {
                                  dsqEnabled = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Expanded(
                                  child: MyCheckboxListTileField(
                                    title: const Text('Zasada 95% HS'),
                                    value: ruleOf95HsEnabled,
                                    onChange: (value) => setState(
                                      () {
                                        ruleOf95HsEnabled = value!;
                                      },
                                    ),
                                  ),
                                ),
                                const Gap(
                                    UiFieldWidgetsConstants.gapBetweenFieldAndHelpButton),
                                HelpIconButton(onPressed: () {
                                  throw UnimplementedError();
                                }),
                              ],
                            ),
                          ),
                          gap,
                          Flexible(
                            child: Row(
                              children: [
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) => MyDropdownField(
                                      label: const Text('Uśrednianie wiatru'),
                                      onChange: (windAverager) {},
                                      entries: _constructEntries<WindAverager>(),
                                      width: constraints.maxWidth,
                                    ),
                                  ),
                                ),
                                const Gap(
                                    UiFieldWidgetsConstants.gapBetweenFieldAndHelpButton),
                                HelpIconButton(
                                  onPressed: () {
                                    throw UnimplementedError();
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: MyNumeralTextField(
                              controller: _judgesCountController,
                              onChange: () {
                                _onChange();
                                _ensureCorrectSignificantJudgesCount();
                              },
                              labelText: 'Ilość sędziów',
                              step: 1,
                              min: 1,
                              max: 10,
                              enabled: true, // TODO: LOL
                            ),
                          ),
                          gap,
                          Flexible(
                            child: MyNumeralTextField(
                              // TODO: VALIDATE IT
                              controller: _significantJudgesCountController,
                              onChange: () {
                                _onChange();
                                _ensureCorrectJudgesCount();
                              },
                              labelText: 'Ilość wliczanych not',
                              step: 1,
                              min: 1,
                              max: 10,
                              enabled: true, // TODO: LOL
                            ),
                          ),
                        ],
                      ),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: LayoutBuilder(
                              builder: (context, constraints) => MyDropdownField(
                                label: const Text('Tworzenie not sędziowskich'),
                                onChange: (windAverager) {},
                                entries: _constructEntries<JudgesCreator>(),
                                width: constraints.maxWidth,
                              ),
                            ),
                          ),
                          gap,
                          Flexible(
                            child: LayoutBuilder(
                              builder: (context, constraints) => MyDropdownField(
                                label: const Text('Pozycje w rankingu'),
                                onChange: (windAverager) {},
                                entries: _constructEntries<StandingsPositionsCreator>(),
                                width: constraints.maxWidth,
                              ),
                            ),
                          ),
                        ],
                      ),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: LayoutBuilder(
                              builder: (context, constraints) => MyDropdownField(
                                label: const Text('Tworzenie wyniku za skok'),
                                onChange: (windAverager) {},
                                entries: _constructEntries<JumpScoreCreator>(),
                                width: constraints.maxWidth,
                              ),
                            ),
                          ),
                          gap,
                          Flexible(
                            child: LayoutBuilder(
                              builder: (context, constraints) => MyDropdownField(
                                label: const Text('Tworzenie wyniku konkursowego'),
                                onChange: (windAverager) {},
                                entries: _constructEntries<CompetitionScoreCreator>(),
                                width: constraints.maxWidth,
                              ),
                            ),
                          ),
                        ],
                      ),
                      gap,
                    ],
                  ),
                ),
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

  void _ensureCorrectJudgesCount() {
    final judgesCount = int.parse(_judgesCountController.text);
    final significantJudgesCount = int.parse(_significantJudgesCountController.text);
    if (judgesCount < significantJudgesCount) {
      _judgesCountController.text = significantJudgesCount.toString();
    }
  }

  void _ensureCorrectSignificantJudgesCount() {
    final judgesCount = int.parse(_judgesCountController.text);
    final significantJudgesCount = int.parse(_significantJudgesCountController.text);
    if (significantJudgesCount > judgesCount) {
      _significantJudgesCountController.text = judgesCount.toString();
    }
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

  void _removeRoundAt(int index) {
    if (_roundsCount > 1) {
      setState(() {
        _roundsCount--;
        _cachedRules!.rounds.removeAt(index);
      });
    }
  }

  void _selectRound({required int roundIndex}) {
    setState(() {
      _selectedRoundIndex = roundIndex;
    });
  }

  void _onChange() {
    widget.onChange(_constructAndCache());
  }

  void setUp(DefaultCompetitionRules rules) {
    setState(() {
      _cachedRules = rules;
      _fillFields(rules);
      FocusScope.of(context).unfocus();
    });
    if (rules.roundsCount == 0) {
      throw StateError(
          'Edited DefaultCompetitionRules shouldn\'t have an empty \'rounds\' object. Please report this error');
    }
    _selectRound(roundIndex: 0);
  }

  void _fillFields(DefaultCompetitionRules rules) {
    _competitionType = rules.competitionRules is DefaultCompetitionRules<Jumper>
        ? _CompetitionType.individual
        : _CompetitionType.team;
    _roundsCount = rules.roundsCount;
    final roundRules = rules.rounds[_selectedRoundIndex];
    bibsAreReassigned = roundRules.bibsAreReassigned;
    gateCanChange = roundRules.gateCanChange;
  }

  DefaultCompetitionRules _constructAndCache() {
    final rounds = List.of(_cachedRules!.rounds);
    //rounds[_selectedRoundIndex!] = _constructCurrentRound(); TODO
    print('competition type: $_competitionType');
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

  List<DropdownMenuEntry> _constructEntries<T extends Object>() {
    final objects = context.read<DbEditingAvailableObjectsRepo<T>>().objects;
    final entries = objects.map((windAveragerObject) {
      return DropdownMenuEntry(
        value: windAveragerObject.object,
        label: windAveragerObject.displayName,
      );
    });
    return entries.toList();
  }
}

enum _CompetitionType {
  individual,
  team,
}
