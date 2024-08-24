import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/competition_rules_translations.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/judges_creator/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/concrete/default_linear.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/wind_averager.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
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
    this.initial,
    this.scrollable = false,
    required this.onChange,
    required this.onAdvancedEditorChosen,
    this.addGapsOnFarSides = true,
  });

  final DefaultCompetitionRules? initial;
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
  late final TextEditingController _numberInGroupController;
  late final TextEditingController _advancesNFromGroupController;
  late final TextEditingController _koGroupsCreatorController;
  late final TextEditingController _koAdvancementDeterminatorController;
  late final TextEditingController _teamSizeController;
  late final TextEditingController _windAveragerController;
  late final TextEditingController _judgesCreatorController;
  late final TextEditingController _positionsCreatorController;
  late final TextEditingController _jumpScoreCreatorController;
  late final TextEditingController _competitionScoreCreatorController;
  late final ScrollController _scrollController;

  DefaultCompetitionRules? _cachedRules;
  DefaultCompetitionRules? get currentCached => _cachedRules;

  var _competitionType = _CompetitionType.individual;
  var _roundsCount = 0;

  var _selectedRoundIndex = 0;

  EntitiesLimitType? _entitiesLimitType;
  var _bibsAreReassigned = false;
  var _gateCanChange = false;
  var _inrunLightsEnabled = false;
  var _dsqEnabled = false;
  var _ruleOf95HsEnabled = false;
  var _koEnabled = false;
  WindAverager _windAverager = DefaultLinearWindAverager(
      skipNonAchievedSensors: true, computePreciselyPartialMeasurement: true);
  JudgesCreator _judgesCreator = DefaultJudgesCreator();
  StandingsPositionsCreator _positionsCreator = StandingsPositionsWithExAequosCreator();
  JumpScoreCreator _jumpScoreCreator = DefaultClassicJumpScoreCreator();
  CompetitionScoreCreator _competitionScoreCreator =
      DefaultLinearIndividualCompetitionScoreCreator();
  KoGroupsCreator _koGroupsCreator = DefaultClassicKoGroupsCreator();
  KoRoundAdvancementDeterminator _koAdvancementDeterminator =
      const NBestKoRoundAdvancementDeterminator();

  @override
  void initState() {
    _scrollController = ScrollController();
    _entitiesLimitCountController = TextEditingController();
    _entitiesLimitTypeController = TextEditingController();
    _judgesCountController = TextEditingController();
    _significantJudgesCountController = TextEditingController();
    _numberInGroupController = TextEditingController();
    _advancesNFromGroupController = TextEditingController();
    _koGroupsCreatorController = TextEditingController();
    _koAdvancementDeterminatorController = TextEditingController();
    _teamSizeController = TextEditingController();
    _windAveragerController = TextEditingController();
    _judgesCreatorController = TextEditingController();
    _positionsCreatorController = TextEditingController();
    _jumpScoreCreatorController = TextEditingController();
    _competitionScoreCreatorController = TextEditingController();

    if (widget.initial != null) {
      scheduleMicrotask(() {
        _fillFields(widget.initial!);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entitiesLimitCountController.dispose();
    _entitiesLimitTypeController.dispose();
    _judgesCountController.dispose();
    _significantJudgesCountController.dispose();
    _numberInGroupController.dispose();
    _advancesNFromGroupController.dispose();
    _koGroupsCreatorController.dispose();
    _koAdvancementDeterminatorController.dispose();
    _teamSizeController.dispose();
    _windAveragerController.dispose();
    _judgesCreatorController.dispose();
    _positionsCreatorController.dispose();
    _jumpScoreCreatorController.dispose();
    _competitionScoreCreatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);
    final mainBody = Column(
      children: [
        if (widget.addGapsOnFarSides) gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
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
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final entries = _constructEntries<CompetitionScoreCreator>();
                  return MyDropdownField(
                    controller: _competitionScoreCreatorController,
                    label: const Text('Tworzenie wyniku konkursowego'),
                    onChange: (key) {
                      setState(() {
                        _competitionScoreCreator = context
                            .read<
                                DbEditingAvailableObjectsRepo<CompetitionScoreCreator>>()
                            .getObject(key!);
                      });
                    },
                    entries: entries,
                    initial: entries.first.value,
                    width: constraints.maxWidth,
                  );
                },
              ),
            ),
          ],
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
                                  final showDeleteButton = selected && _roundsCount != 1;
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
                                      setState(() {
                                        _selectRound(roundIndex: index);
                                        _fillRoundFields(_cachedRules!);
                                      });
                                    },
                                    trailing: showDeleteButton
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
                                onPressed: () {
                                  setState(() {
                                    _addRoundAt(_selectedRoundIndex);
                                    _selectRound(roundIndex: _selectedRoundIndex + 1);
                                  });
                                },
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
                              enabled: _entitiesLimitType != null,
                            ),
                          ),
                          gap,
                          Flexible(
                            child: Row(
                              children: [
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) => MyDropdownField(
                                      controller: _entitiesLimitTypeController,
                                      label: const Text('Rodzaj limitu'),
                                      width: constraints.maxWidth,
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
                                  ),
                                ),
                                const Gap(
                                    UiFieldWidgetsConstants.gapBetweenFieldAndHelpButton),
                                HelpIconButton(
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: MyCheckboxListTileField(
                                title: const Text('Ponowne przypisanie BIBs'),
                                value: _bibsAreReassigned,
                                onChange: (value) {
                                  setState(() {
                                    _bibsAreReassigned = value!;
                                    _onChange();
                                  });
                                }),
                          ),
                          gap,
                          Flexible(
                            child: MyCheckboxListTileField(
                                title: const Text('Zmiana belki'),
                                value: _gateCanChange,
                                onChange: (value) {
                                  setState(() {
                                    _gateCanChange = value!;
                                    _onChange();
                                  });
                                }),
                          ),
                        ],
                      ),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: MyCheckboxListTileField(
                                title: const Text('Światełko startowe'),
                                value: _inrunLightsEnabled,
                                onChange: (value) {
                                  setState(() {
                                    _inrunLightsEnabled = value!;
                                    _onChange();
                                  });
                                }),
                          ),
                          gap,
                          Flexible(
                            child: MyCheckboxListTileField(
                                title: const Text('Możliwość dyskwalifikacji'),
                                value: _dsqEnabled,
                                onChange: (value) {
                                  setState(() {
                                    _dsqEnabled = value!;
                                    _onChange();
                                  });
                                }),
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
                                      value: _ruleOf95HsEnabled,
                                      onChange: (value) {
                                        setState(() {
                                          _ruleOf95HsEnabled = value!;
                                          _onChange();
                                        });
                                      }),
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
                                    builder: (context, constraints) {
                                      final entries = _constructEntries<WindAverager>();
                                      return MyDropdownField(
                                        controller: _windAveragerController,
                                        label: const Text('Uśrednianie wiatru'),
                                        onChange: (key) {
                                          setState(() {
                                            _windAverager = context
                                                .read<
                                                    DbEditingAvailableObjectsRepo<
                                                        WindAverager>>()
                                                .getObject(key!);
                                          });
                                        },
                                        entries: entries,
                                        initial: entries.first.value,
                                        width: constraints.maxWidth,
                                      );
                                    },
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
                              builder: (context, constraints) {
                                final entries = _constructEntries<JudgesCreator>();
                                return MyDropdownField(
                                  controller: _judgesCreatorController,
                                  label: const Text('Tworzenie not sędziowskich'),
                                  onChange: (key) {
                                    setState(() {
                                      _judgesCreator = context
                                          .read<
                                              DbEditingAvailableObjectsRepo<
                                                  JudgesCreator>>()
                                          .getObject(key!);
                                    });
                                  },
                                  entries: entries,
                                  initial: entries.first.value,
                                  width: constraints.maxWidth,
                                );
                              },
                            ),
                          ),
                          gap,
                          Flexible(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final entries =
                                    _constructEntries<StandingsPositionsCreator>();
                                return MyDropdownField(
                                  controller: _positionsCreatorController,
                                  label: const Text('Pozycje w rankingu'),
                                  onChange: (key) {
                                    setState(() {
                                      _positionsCreator = context
                                          .read<
                                              DbEditingAvailableObjectsRepo<
                                                  StandingsPositionsCreator>>()
                                          .getObject(key!);
                                    });
                                  },
                                  entries: entries,
                                  initial: entries.first.value,
                                  width: constraints.maxWidth,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final entries = _constructEntries<JumpScoreCreator>();
                                return MyDropdownField(
                                  controller: _jumpScoreCreatorController,
                                  label: const Text('Tworzenie wyniku za skok'),
                                  onChange: (key) {
                                    setState(() {
                                      _jumpScoreCreator = context
                                          .read<
                                              DbEditingAvailableObjectsRepo<
                                                  JumpScoreCreator>>()
                                          .getObject(key!);
                                    });
                                  },
                                  entries: entries,
                                  initial: entries.first.value,
                                  width: constraints.maxWidth,
                                );
                              },
                            ),
                          ),
                          gap,
                        ],
                      ),
                      gap,
                      const Divider(),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Expanded(
                                  child: MyCheckboxListTileField(
                                    title: const Text('Runda KO'),
                                    value: _koEnabled,
                                    onChange: (value) => setState(
                                      () {
                                        _koEnabled = value!;
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
                                    builder: (context, constraints) {
                                      final entries =
                                          _constructEntries<KoGroupsCreator>();
                                      return MyDropdownField(
                                        controller: _koGroupsCreatorController,
                                        label: const Text('Dobieranie Grup KO'),
                                        onChange: (key) {
                                          setState(() {
                                            _koGroupsCreator = context
                                                .read<
                                                    DbEditingAvailableObjectsRepo<
                                                        KoGroupsCreator>>()
                                                .getObject(key!);
                                            if (_koGroupsCreator
                                                is DefaultClassicKoGroupsCreator) {
                                              _numberInGroupController.text =
                                                  1.toString();
                                              _koAdvancementDeterminator =
                                                  const NBestKoRoundAdvancementDeterminator();
                                              _advancesNFromGroupController.text =
                                                  1.toString();
                                            }
                                          });
                                        },
                                        entries: entries,
                                        initial: entries.first.value,
                                        width: constraints.maxWidth,
                                        enabled: _koEnabled,
                                      );
                                    },
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
                                  child: Builder(builder: (context) {
                                    final min =
                                        _koGroupsCreator is DefaultClassicKoGroupsCreator
                                            ? 2
                                            : 1;
                                    final max =
                                        _koGroupsCreator is DefaultClassicKoGroupsCreator
                                            ? 2
                                            : 100;
                                    final enabled = _koGroupsCreator
                                            is DefaultClassicKoGroupsCreator ==
                                        false;
                                    return MyNumeralTextField(
                                      controller: _numberInGroupController,
                                      onChange: () {
                                        _onChange();
                                      },
                                      labelText: 'Liczebność grupy',
                                      step: 1,
                                      min: min,
                                      max: max,
                                      enabled: enabled, // TODO: LOL
                                    );
                                  }),
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
                        ],
                      ),
                      gap,
                      Row(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final entries = _constructEntries<
                                          KoRoundAdvancementDeterminator>();
                                      return MyDropdownField(
                                        controller: _koAdvancementDeterminatorController,
                                        label: const Text('Awans z Grupy KO'),
                                        onChange: (key) {
                                          setState(() {
                                            _koAdvancementDeterminator = context
                                                .read<
                                                    DbEditingAvailableObjectsRepo<
                                                        KoRoundAdvancementDeterminator>>()
                                                .getObject(key!);
                                            ;
                                          });
                                        },
                                        entries: entries,
                                        initial: entries.first.value,
                                        width: constraints.maxWidth,
                                        enabled: _koEnabled,
                                      );
                                    },
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
                                  child: Builder(
                                    builder: (context) {
                                      final enabled = _koEnabled &&
                                          _koGroupsCreator
                                                  is DefaultClassicKoGroupsCreator ==
                                              false;
                                      var min = 1;
                                      var max = 100;
                                      if (_koGroupsCreator
                                          is DefaultClassicKoGroupsCreator) {
                                        min = 1;
                                        max = 1;
                                      }
                                      return MyNumeralTextField(
                                        controller: _advancesNFromGroupController,
                                        onChange: () {
                                          _onChange();
                                        },
                                        labelText: 'Ilość awansujących z grupy',
                                        step: 1,
                                        min: min,
                                        max: max,
                                        enabled: enabled,
                                      );
                                    },
                                  ),
                                ),
                                /*const Gap(
                                    UiFieldWidgetsConstants.gapBetweenFieldAndHelpButton),
                                HelpIconButton(onPressed: () {
                                  throw UnimplementedError();
                                }),*/ // TODO: ???
                              ],
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
    _roundsCount++;
    _cachedRules!.rounds.insert(index, defaultItem);
  }

  void _removeRoundAt(int index) {
    if (_roundsCount > 1) {
      setState(() {
        if (_selectedRoundIndex + 1 == _roundsCount) {
          _selectedRoundIndex--;
        }
        _roundsCount--;
        _cachedRules!.rounds.removeAt(index);
      });
    }
  }

  void _selectRound({required int roundIndex}) {
    _selectedRoundIndex = roundIndex;
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
    _fillRoundFields(rules);
  }

  void _fillRoundFields(DefaultCompetitionRules competitionRules) {
    final rules = competitionRules.rounds[_selectedRoundIndex];
    _entitiesLimitCountController.text = rules.limit?.count.toString() ?? '';
    _entitiesLimitTypeController.text = translatedEntitiesLimitType(context, rules.limit);
    _entitiesLimitType = rules.limit?.type;
    _judgesCountController.text = rules.judgesCount.toString();
    _significantJudgesCountController.text = rules.significantJudgesCount.toString();
    _numberInGroupController.text = rules.significantJudgesCount.toString();
    _advancesNFromGroupController.text = rules.significantJudgesCount.toString();

    DbEditingAvailableObjectsRepo repo =
        context.read<DbEditingAvailableObjectsRepo<KoGroupsCreator>>();
    _koGroupsCreatorController.text = rules.koRules != null
        ? repo.getDisplayName(repo.getKeyByObject(rules.koRules!.koGroupsCreator))
        : '';
    _koGroupsCreator = rules.koRules?.koGroupsCreator ?? DefaultClassicKoGroupsCreator();

    repo = context.read<DbEditingAvailableObjectsRepo<KoRoundAdvancementDeterminator>>();
    _koAdvancementDeterminatorController.text = rules.koRules != null
        ? repo.getDisplayName(repo.getKeyByObject(rules.koRules!.koGroupsCreator))
        : '';
    _koAdvancementDeterminator = rules.koRules?.advancementDeterminator ??
        const NBestKoRoundAdvancementDeterminator();

    repo = context.read<DbEditingAvailableObjectsRepo<WindAverager>>();
    _windAveragerController.text =
        repo.getDisplayName(repo.getKeyByObject(rules.windAverager));
    _windAverager = rules.windAverager ??
        DefaultLinearWindAverager(
            skipNonAchievedSensors: false, computePreciselyPartialMeasurement: false);

    repo = context.read<DbEditingAvailableObjectsRepo<StandingsPositionsCreator>>();
    _positionsCreatorController.text =
        repo.getDisplayName(repo.getKeyByObject(rules.positionsCreator));
    _positionsCreator = rules.positionsCreator;

    repo = context.read<DbEditingAvailableObjectsRepo<JudgesCreator>>();
    _judgesCreatorController.text =
        repo.getDisplayName(repo.getKeyByObject(rules.judgesCreator));
    _judgesCreator = rules.judgesCreator;

    repo = context.read<DbEditingAvailableObjectsRepo<JumpScoreCreator>>();
    _jumpScoreCreatorController.text =
        repo.getDisplayName(repo.getKeyByObject(rules.jumpScoreCreator));
    _jumpScoreCreator = rules.jumpScoreCreator;

    repo = context.read<DbEditingAvailableObjectsRepo<CompetitionScoreCreator>>();
    _competitionScoreCreatorController.text =
        repo.getDisplayName(repo.getKeyByObject(rules.competitionScoreCreator));
    _competitionScoreCreator = rules.competitionScoreCreator as CompetitionScoreCreator;

    if (rules is DefaultTeamCompetitionRoundRules) {
      _teamSizeController.text = rules.teamSize.toString();
    }
    _bibsAreReassigned = rules.bibsAreReassigned;
    _gateCanChange = rules.gateCanChange;
    _inrunLightsEnabled = rules.inrunLightsEnabled;
    _dsqEnabled = rules.dsqEnabled;
    _ruleOf95HsEnabled = rules.ruleOf95HsFallEnabled;
    _koEnabled = rules.koRules != null;
  }

  DefaultCompetitionRules _constructAndCache() {
    final rounds = List.of(_cachedRules!.rounds);
    rounds[_selectedRoundIndex] = _constructCurrentRound();
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
    final limit = _entitiesLimitType != null
        ? EntitiesLimit(
            count: int.parse(_entitiesLimitCountController.text),
            type: _entitiesLimitType!,
          )
        : null;
    return switch (_competitionType) {
      _CompetitionType.individual => DefaultIndividualCompetitionRoundRules(
          limit: limit,
          bibsAreReassigned: _bibsAreReassigned,
          gateCanChange: _gateCanChange,
          windAverager: _windAverager,
          inrunLightsEnabled: _inrunLightsEnabled,
          dsqEnabled: _dsqEnabled,
          positionsCreator: _positionsCreator,
          ruleOf95HsFallEnabled: _ruleOf95HsEnabled,
          judgesCount: int.parse(_judgesCountController.text),
          significantJudgesCount: int.parse(_significantJudgesCountController.text),
          competitionScoreCreator: _competitionScoreCreator
              as CompetitionScoreCreator<CompetitionScore<Jumper, dynamic>>,
          jumpScoreCreator: _jumpScoreCreator,
          judgesCreator: _judgesCreator,
          koRules: _koEnabled ? _constructKoRulesForCurrentRound() : null,
        ),
      _CompetitionType.team => DefaultTeamCompetitionRoundRules(
          limit: limit,
          bibsAreReassigned: _bibsAreReassigned,
          gateCanChange: _gateCanChange,
          windAverager: _windAverager,
          inrunLightsEnabled: _inrunLightsEnabled,
          dsqEnabled: _dsqEnabled,
          positionsCreator: _positionsCreator,
          ruleOf95HsFallEnabled: _ruleOf95HsEnabled,
          judgesCount: int.parse(_judgesCountController.text),
          significantJudgesCount: int.parse(_significantJudgesCountController.text),
          competitionScoreCreator: _competitionScoreCreator
              as CompetitionScoreCreator<CompetitionScore<CompetitionTeam, dynamic>>,
          jumpScoreCreator: _jumpScoreCreator,
          judgesCreator: _judgesCreator,
          koRules: _koEnabled ? _constructKoRulesForCurrentRound() : null,
          groups: _constructGroupsRules(),
          teamSize: int.parse(_teamSizeController.text),
        ),
    };
  }

  KoRoundRules _constructKoRulesForCurrentRound() {
    return KoRoundRules(
      advancementDeterminator: _koAdvancementDeterminator,
      koGroupsCreator: _koGroupsCreator,
    );
  }

  List<TeamCompetitionGroupRules> _constructGroupsRules() {
    throw UnimplementedError();
  }

  List<DropdownMenuEntry<String>> _constructEntries<T extends Object>() {
    final objects = context.read<DbEditingAvailableObjectsRepo<T>>().objects;
    final entries = objects.map((windAveragerObject) {
      return DropdownMenuEntry<String>(
        value: windAveragerObject.key,
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
