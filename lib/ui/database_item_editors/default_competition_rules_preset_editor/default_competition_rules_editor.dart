import 'dart:async';

import 'package:collection/collection.dart';
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
import 'package:sj_manager/models/simulation_db/standings/score/typedefs.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_avaiable_objects_repo.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/ui/database_item_editors/fields/dropdown_menu_form_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_checkbox_list_tile_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_form_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_numeral_text_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_numeral_text_form_field.dart';
import 'package:sj_manager/ui/dialogs/simple_help_dialog.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/utils/colors.dart';
import 'package:sj_manager/utils/platform.dart';

class DefaultCompetitionRulesEditor extends StatefulWidget {
  const DefaultCompetitionRulesEditor({
    super.key,
    required this.initial,
    this.scrollable = false,
    required this.onChange,
    required this.onAdvancedEditorChosen,
    this.addGapsOnFarSides = true,
  });

  final DefaultCompetitionRules initial;
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
  late final TextEditingController _groupSizeController;
  late final TextEditingController _groupAdvancementCountController;
  late final TextEditingController _koGroupsCreatorController;
  late final TextEditingController _koAdvancementDeterminatorController;
  late final TextEditingController _windAveragerController;
  late final TextEditingController _judgesCreatorController;
  late final TextEditingController _positionsCreatorController;
  late final TextEditingController _jumpScoreCreatorController;
  late final TextEditingController _competitionScoreCreatorController;
  late final ScrollController _scrollController;

  final _koGroupsCreatorFormFieldKey = GlobalKey<DropdownMenuFormFieldState>();
  final _koRoundAdvancementDeterminatorFormFieldKey =
      GlobalKey<DropdownMenuFormFieldState>();
  final _entitiesLimitCountFormFieldKey = GlobalKey<FormFieldState>();

  DefaultCompetitionRules? _cachedRules;
  DefaultCompetitionRules? get currentCached => _cachedRules;

  var _competitionType = CompetitionTypeByEntity.individual;

  var _roundsCount = 0;
  var _selectedRoundIndex = 0;

  EntitiesLimitType? _entitiesLimitType;
  var _bibsAreReassigned = false;
  var _startlistIsSorted = false;
  var _gateCanChange = false;
  var _gateCompensationsEnabled = false;
  var _windCompensationsEnabled = false;
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

  var _groupsCount = 0;
  var _selectedGroupIndex = 0;
  var _sortStartlistBeforeGroup = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _entitiesLimitCountController = TextEditingController();
    _entitiesLimitTypeController = TextEditingController();
    _judgesCountController = TextEditingController();
    _significantJudgesCountController = TextEditingController();
    _groupSizeController = TextEditingController();
    _groupAdvancementCountController = TextEditingController();
    _koGroupsCreatorController = TextEditingController();
    _koAdvancementDeterminatorController = TextEditingController();
    _windAveragerController = TextEditingController();
    _judgesCreatorController = TextEditingController();
    _positionsCreatorController = TextEditingController();
    _jumpScoreCreatorController = TextEditingController();
    _competitionScoreCreatorController = TextEditingController();

    scheduleMicrotask(() {
      _fillFields(widget.initial);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entitiesLimitCountController.dispose();
    _entitiesLimitTypeController.dispose();
    _judgesCountController.dispose();
    _significantJudgesCountController.dispose();
    _groupSizeController.dispose();
    _groupAdvancementCountController.dispose();
    _koGroupsCreatorController.dispose();
    _koAdvancementDeterminatorController.dispose();
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
                    _ensureCorrectCompetitionScoreCreator();
                    _onChange();
                  });
                },
              ),
            ),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final entries = _constructEntries<CompetitionScoreCreator>(
                    condition: (config) {
                      if (_competitionType == CompetitionTypeByEntity.individual) {
                        return config.object
                            is CompetitionScoreCreator<CompetitionScore<Jumper>>;
                      } else {
                        return config.object
                            is CompetitionScoreCreator<CompetitionScore<CompetitionTeam>>;
                      }
                    },
                  );
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
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _roundsCount,
                          itemBuilder: (context, index) {
                            final selected = index == _selectedRoundIndex;
                            final showDeleteButton = selected && _roundsCount > 1;
                            return ListTile(
                              key: ValueKey(index),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              splashColor:
                                  Theme.of(context).colorScheme.surfaceContainerHigh,
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
                                  _onChange();
                                });
                              },
                              trailing: showDeleteButton
                                  ? IconButton(
                                      icon: const Icon(Symbols.delete),
                                      onPressed: () {
                                        _removeRoundAt(index);
                                        _onChange();
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
                              _addRoundAt(_selectedRoundIndex + 1);
                              _selectRound(roundIndex: _selectedRoundIndex + 1);
                              _onChange();
                            });
                          },
                          label: const Text('Dodaj rundę'),
                          icon: const Icon(Symbols.add),
                        ),
                      ),
                    ],
                  ),
                ),
                gap,
                gap,
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          gap,
                          Row(
                            children: [
                              Flexible(
                                child: MyNumeralTextFormField(
                                  formKey: _entitiesLimitCountFormFieldKey,
                                  controller: _entitiesLimitCountController,
                                  onChange: _onChange,
                                  labelText: _competitionType ==
                                          CompetitionTypeByEntity.individual
                                      ? 'Limit zawodników'
                                      : 'Limit drużyn',
                                  step: 1,
                                  min: 1,
                                  max: 100000,
                                  enabled: _entitiesLimitType != null,
                                  validator: (value) {
                                    if (_koGroupsCreator
                                            is DefaultClassicKoGroupsCreator &&
                                        _koEnabled &&
                                        int.parse(value!).isOdd) {
                                      return 'Dla klasycznego KO limit musi być parzysty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              gap,
                              Flexible(
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
                                        _onChange();
                                      });
                                    },
                                    enabled: !_koEnabled ||
                                        (_koEnabled &&
                                            _koGroupsCreator
                                                    is DefaultClassicKoGroupsCreator ==
                                                false),
                                    onHelpButtonTap: () {
                                      showSimpleHelpDialog(
                                          context: context,
                                          title: 'Rodzaj limitu',
                                          content:
                                              'Limit miękki pozwala na przejście większej ilości zawodników w przypadku ex aequo. Nie pozwala na to limit dosłowny');
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
                                    title: const Text('Możliwość zmiany belki'),
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
                                  title: const Text('Rekompensaty za belkę'),
                                  value: _gateCompensationsEnabled,
                                  onChange: (value) {
                                    setState(() {
                                      _gateCompensationsEnabled = value!;
                                      _onChange();
                                    });
                                  },
                                  enabled: _gateCanChange,
                                ),
                              ),
                              gap,
                              Flexible(
                                child: MyCheckboxListTileField(
                                    title: const Text('Rekompensaty za wiatr'),
                                    value: _windCompensationsEnabled,
                                    onChange: (value) {
                                      setState(() {
                                        _windCompensationsEnabled = value!;
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
                                child: MyCheckboxListTileField(
                                  title: const Text('Zasada 95% HS'),
                                  value: _ruleOf95HsEnabled,
                                  onChange: (value) {
                                    setState(() {
                                      _ruleOf95HsEnabled = value!;
                                      _onChange();
                                    });
                                  },
                                  onHelpButtonTap: () {
                                    showSimpleHelpDialog(
                                        context: context,
                                        title: 'Zasada 95%',
                                        content:
                                            'Jeśli zawodnik upadnie osiągając 95% punktu HS, ma zapewniony awans do kolejnej serii');
                                  },
                                ),
                              ),
                              gap,
                              Flexible(
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
                                          _onChange();
                                        });
                                      },
                                      entries: entries,
                                      initial: entries.first.value,
                                      width: constraints.maxWidth,
                                      onHelpButtonTap: () {
                                        showSimpleHelpDialog(
                                            context: context,
                                            title: 'Uśrednianie wiatru',
                                            content:
                                                'Wagowe uśredniacze przypisują różną wagę czujnikom wiatru, podczas gdy liniowe traktują wszystkie tak samo. Im bardziej zaawansowany uśredniacz, tym bardziej sprawiedliwe pomiary. Zaawansowany uśredniacz nie bierze pod uwagę wiatru, do którego nie doskoczył zawodnik.');
                                      },
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
                                child: MyNumeralTextField(
                                  controller: _judgesCountController,
                                  onChange: () {
                                    _ensureCorrectSignificantJudgesCount();
                                    _onChange();
                                  },
                                  labelText: 'Ilość sędziów',
                                  step: 1,
                                  min: 0,
                                  max: 10,
                                ),
                              ),
                              gap,
                              Flexible(
                                child: MyNumeralTextField(
                                  controller: _significantJudgesCountController,
                                  onChange: () {
                                    _ensureCorrectJudgesCount();
                                    _onChange();
                                  },
                                  labelText: 'Ilość wliczanych not',
                                  step: 1,
                                  min: 1,
                                  max: 10,
                                  enabled: judgesEnabled,
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
                                          _onChange();
                                        });
                                      },
                                      entries: entries,
                                      initial: entries.first.value,
                                      width: constraints.maxWidth,
                                      enabled: judgesEnabled,
                                      onHelpButtonTap: () {
                                        showSimpleHelpDialog(
                                            context: context,
                                            title: 'Tworzenie not sędziowskich',
                                            content:
                                                'Pracujemy nad dodaniem kolejnych opcji :)');
                                      },
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
                                          _onChange();
                                        });
                                      },
                                      entries: entries,
                                      initial: entries.first.value,
                                      width: constraints.maxWidth,
                                      onHelpButtonTap: () {
                                        showSimpleHelpDialog(
                                            context: context,
                                            title: 'Pozycje w rankingu',
                                            content:
                                                'Czy w konkursie ma występować ex aequo? Ex aequo to sytuacja, w której dwóch skoczków/dwie skoczkinie są na tym samym miejscu');
                                      },
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
                                          _onChange();
                                        });
                                      },
                                      entries: entries,
                                      initial: entries.first.value,
                                      width: constraints.maxWidth,
                                      onHelpButtonTap: () {
                                        showSimpleHelpDialog(
                                            context: context,
                                            title: 'Tworzenie wyniku w konkursie',
                                            content:
                                                'Pracujemy nad dodaniem kolejnych opcji :)');
                                      },
                                    );
                                  },
                                ),
                              ),
                              gap,
                              Flexible(
                                child: MyCheckboxListTileField(
                                  title: const Text('Sortowanie listy startowej'),
                                  value: _startlistIsSorted,
                                  onChange: (value) {
                                    setState(() {
                                      _startlistIsSorted = value!;
                                      _onChange();
                                    });
                                  },
                                  onHelpButtonTap: () {
                                    showSimpleHelpDialog(
                                        context: context,
                                        title: 'Tworzenie wyniku w konkursie',
                                        content:
                                            'Czy sortować listę startową, od najniższej do najwyższej pozycji, przed rozpoczęciem rundy');
                                  },
                                ),
                              ),
                            ],
                          ),
                          gap,
                          const Divider(),
                          gap,
                          Row(
                            children: [
                              Flexible(
                                child: MyCheckboxListTileField(
                                  title: const Text('Runda KO'),
                                  value: _koEnabled,
                                  onChange: (value) {
                                    setState(() {
                                      _koEnabled = value!;
                                      _onChange();
                                    });
                                  },
                                  onHelpButtonTap: () {
                                    showSimpleHelpDialog(
                                        context: context,
                                        title: 'Runda KO',
                                        content:
                                            'W rundzie KO osoby rywalizujące są dobierane w grupy, z których awansuje tylko część');
                                  },
                                ),
                              ),
                              gap,
                              Flexible(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final entries = _constructEntries<KoGroupsCreator>();
                                    return MyDropdownFormField(
                                      formKey: _koGroupsCreatorFormFieldKey,
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
                                            _groupSizeController.text = 2.toString();
                                            _koAdvancementDeterminator =
                                                const NBestKoRoundAdvancementDeterminator();
                                            final determinatorsRepo = context.read<
                                                DbEditingAvailableObjectsRepo<
                                                    KoRoundAdvancementDeterminator>>();
                                            _koAdvancementDeterminatorController.text =
                                                determinatorsRepo.getDisplayName(
                                                    determinatorsRepo.getKeyByObject(
                                                        const NBestKoRoundAdvancementDeterminator()));
                                            _groupAdvancementCountController.text =
                                                1.toString();
                                            _entitiesLimitType = EntitiesLimitType.exact;
                                            _entitiesLimitTypeController.text =
                                                translatedEntitiesLimitType(
                                                    context,
                                                    EntitiesLimit(
                                                        type: _entitiesLimitType!,
                                                        count: 0));
                                          }
                                          _onChange();
                                        });
                                      },
                                      entries: entries,
                                      initial: entries.first.value,
                                      width: constraints.maxWidth,
                                      enabled: _koEnabled,
                                      validator: _koEnabled
                                          ? (value) {
                                              final text =
                                                  _koGroupsCreatorController.text;
                                              if (text.isEmpty) {
                                                return 'Potrzebujemy tego';
                                              }
                                              return null;
                                            }
                                          : null,
                                    );
                                  },
                                ),
                              ),
                              gap,
                              Flexible(
                                child: Builder(builder: (context) {
                                  final min =
                                      _koGroupsCreator is DefaultClassicKoGroupsCreator
                                          ? 2
                                          : 2;
                                  final max =
                                      _koGroupsCreator is DefaultClassicKoGroupsCreator
                                          ? 2
                                          : 100;
                                  final enabled =
                                      _koGroupsCreator is DefaultClassicKoGroupsCreator ==
                                          false;
                                  return MyNumeralTextField(
                                    controller: _groupSizeController,
                                    onChange: () {
                                      _ensureCorrectGroupAdvancementCount();
                                      _onChange();
                                    },
                                    labelText: 'Liczebność grupy',
                                    step: 1,
                                    min: min,
                                    max: max,
                                    enabled: enabled,
                                  );
                                }),
                              ),
                              gap,
                            ],
                          ),
                          gap,
                          Row(
                            children: [
                              Flexible(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final entries = _constructEntries<
                                        KoRoundAdvancementDeterminator>();
                                    return MyDropdownFormField(
                                      formKey:
                                          _koRoundAdvancementDeterminatorFormFieldKey,
                                      controller: _koAdvancementDeterminatorController,
                                      label: const Text('Awans z Grupy KO'),
                                      onChange: (key) {
                                        setState(() {
                                          _koAdvancementDeterminator = switch (key) {
                                            'n_best' =>
                                              const NBestKoRoundAdvancementDeterminator(),
                                            _ => throw ArgumentError(
                                                'Invalid KoRoundAdvancementDeterminator key ($key)'),
                                          };
                                          _onChange();
                                        });
                                      },
                                      entries: entries,
                                      initial: entries.first.value,
                                      width: constraints.maxWidth,
                                      enabled: _koEnabled,
                                      validator: _koEnabled
                                          ? (value) {
                                              final text =
                                                  _koAdvancementDeterminatorController
                                                      .text;
                                              if (text.isEmpty) {
                                                return 'Potrzebujemy tego';
                                              }
                                              return null;
                                            }
                                          : null,
                                    );
                                  },
                                ),
                              ),
                              const Gap(
                                  UiFieldWidgetsConstants.gapBetweenFieldAndHelpButton),
                              HelpIconButton(onPressed: () {
                                throw UnimplementedError();
                              }),
                              gap,
                              Flexible(
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
                                      controller: _groupAdvancementCountController,
                                      onChange: () {
                                        _ensureCorrectNumberInGroup();
                                        _onChange();
                                      },
                                      labelText: 'Ilość awansujących z grupy',
                                      step: 1,
                                      min: min,
                                      max: max,
                                      enabled: enabled &&
                                          _koAdvancementDeterminator
                                              is NBestKoRoundAdvancementDeterminator,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (_competitionType == CompetitionTypeByEntity.team) ...[
                            const Divider(
                              height:
                                  UiItemEditorsConstants.verticalSpaceBetweenFields * 2.5,
                            ),
                            SizedBox(
                              height: 400,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: _groupsCount,
                                            itemBuilder: (context, index) {
                                              final selected =
                                                  index == _selectedGroupIndex;
                                              final showDeleteButton =
                                                  selected && _groupsCount > 1;
                                              return ListTile(
                                                selected: selected,
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
                                                selectedColor: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                title: Text('Grupa ${index + 1}'),
                                                onTap: () {
                                                  setState(() {
                                                    _selectGroup(groupIndex: index);
                                                    _fillGroupFields(_selectedGroupIndex);
                                                    _onChange();
                                                  });
                                                },
                                                trailing: showDeleteButton
                                                    ? IconButton(
                                                        onPressed: () {
                                                          _removeGroupAt(index);
                                                          _onChange();
                                                        },
                                                        icon: const Icon(Symbols.delete),
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
                                                _addGroupAt(
                                                  _selectedGroupIndex + 1,
                                                );
                                                _selectGroup(
                                                  groupIndex: _selectedRoundIndex + 1,
                                                );
                                                _onChange();
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Theme.of(context).colorScheme.secondary,
                                            ),
                                            label: const Text('Dodaj grupę'),
                                            icon: const Icon(Symbols.add),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  gap,
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: MyCheckboxListTileField(
                                                title: const Text(
                                                    'Sortuj listę startową przed grupą'),
                                                value: _sortStartlistBeforeGroup,
                                                onChange: (value) {
                                                  setState(() {
                                                    _sortStartlistBeforeGroup = value!;
                                                    _onChange();
                                                  });
                                                },
                                                onHelpButtonTap: () {
                                                  showSimpleHelpDialog(
                                                      context: context,
                                                      title:
                                                          'Grupa w konkursie drużynowym',
                                                      content:
                                                          'Jest to część rundy, w której skacze jeden zawodnik z każdej drużyny. Grup jest tyle, ile zawodników w drużynie.');
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          gap,
                        ],
                      ),
                    ),
                  ),
                ),
                gap,
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

  void _ensureCorrectNumberInGroup() {
    final numberInGroup = int.parse(_groupSizeController.text);
    final nAdvancesFromGroup = int.parse(_groupAdvancementCountController.text);
    if (numberInGroup < nAdvancesFromGroup) {
      _groupSizeController.text = nAdvancesFromGroup.toString();
    }
  }

  void _ensureCorrectGroupAdvancementCount() {
    final numberInGroup = int.parse(_groupSizeController.text);
    final nAdvancesFromGroup = int.parse(_groupAdvancementCountController.text);
    if (nAdvancesFromGroup > numberInGroup) {
      _groupAdvancementCountController.text = numberInGroup.toString();
    }
  }

  void _addRoundAt(int index) {
    final DefaultCompetitionRoundRules defaultItem = _competitionType ==
            CompetitionTypeByEntity.individual
        ? context.read<DefaultItemsRepo>().get<DefaultIndividualCompetitionRoundRules>()
        : context.read<DefaultItemsRepo>().get<DefaultTeamCompetitionRoundRules>();
    _roundsCount++;
    _cachedRules!.rounds.insert(index, defaultItem);
    _fillRoundFields(_cachedRules!);
  }

  void _removeRoundAt(int index) {
    if (_roundsCount > 1) {
      setState(() {
        if (_selectedRoundIndex + 1 == _roundsCount) {
          _selectedRoundIndex--;
        }
        _roundsCount--;
        _cachedRules!.rounds.removeAt(index);
        _fillRoundFields(_cachedRules!);
      });
    }
  }

  void _selectRound({required int roundIndex}) {
    setState(() {
      _selectedRoundIndex = roundIndex;
      _fillRoundFields(_cachedRules!);
    });
  }

  void _addGroupAt(int index) {
    final defaultItem = context.read<DefaultItemsRepo>().get<TeamCompetitionGroupRules>();
    final roundRules = _cachedRules!.rounds[_selectedRoundIndex];
    if (roundRules is DefaultTeamCompetitionRoundRules == false) {
      throw StateError('Cannot add a group for the individual competition');
    }
    _groupsCount++;
    (roundRules as DefaultTeamCompetitionRoundRules).groups.insert(index, defaultItem);
    _fillGroupFields(_selectedGroupIndex);
  }

  void _removeGroupAt(int index) {
    final roundRules = _cachedRules!.rounds[_selectedRoundIndex];
    if (roundRules is DefaultTeamCompetitionRoundRules == false) {
      throw StateError('Cannot remove a group from the individual competition');
    }
    if (_groupsCount > 1) {
      setState(() {
        if (_selectedGroupIndex + 1 == _groupsCount) {
          _selectedGroupIndex--;
        }
        _groupsCount--;
        final newRounds = _cachedRules!.rounds.mapIndexed(
          (index, roundRulesRaw) {
            final roundRules = roundRulesRaw as DefaultTeamCompetitionRoundRules;
            if (index == _selectedRoundIndex) {
              final newGroups = List.of(roundRules.groups);
              newGroups.removeAt(index);
              return roundRules.copyWith(groups: newGroups);
            }
            return roundRules;
          },
        ).toList();
        _cachedRules = _cachedRules!.copyWith(rounds: newRounds);
        _fillGroupFields(_selectedGroupIndex);
      });
    }
  }

  void _selectGroup({required int groupIndex}) {
    setState(() {
      _selectedGroupIndex = groupIndex;
      _fillGroupFields(_selectedGroupIndex);
    });
  }

  void _onChange() {
    if (!_validateFormFields()) return;
    widget.onChange(_constructAndCache());
  }

  void setUp(DefaultCompetitionRules rules) {
    setState(() {
      _cachedRules = rules;
      _selectedRoundIndex = 0;
      _selectedGroupIndex = 0;
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
        ? CompetitionTypeByEntity.individual
        : CompetitionTypeByEntity.team;
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

    _groupSizeController.text = (rules.koRules?.groupSize ?? 0).toString();
    _groupAdvancementCountController.text =
        (rules.koRules?.advancementCount ?? 0).toString();

    DbEditingAvailableObjectsRepo repo =
        context.read<DbEditingAvailableObjectsRepo<KoGroupsCreator>>();
    _koGroupsCreatorController.text = rules.koRules != null
        ? repo.getDisplayName(repo.getKeyByObject(rules.koRules!.koGroupsCreator))
        : '';
    _koGroupsCreator = rules.koRules?.koGroupsCreator ?? DefaultClassicKoGroupsCreator();

    repo = context.read<DbEditingAvailableObjectsRepo<KoRoundAdvancementDeterminator>>();
    _koAdvancementDeterminatorController.text = rules.koRules != null
        ? repo.getDisplayName(repo.getKeyByObject(rules.koRules!.advancementDeterminator))
        : '';

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
    _competitionScoreCreator = rules.competitionScoreCreator;

    if (rules is DefaultTeamCompetitionRoundRules) {
      _groupsCount = rules.groupsCount;
      _selectedGroupIndex = 0;
      _fillGroupFields(_selectedGroupIndex);
    }
    _bibsAreReassigned = rules.bibsAreReassigned;
    _gateCanChange = rules.gateCanChange;
    _inrunLightsEnabled = rules.inrunLightsEnabled;
    _dsqEnabled = rules.dsqEnabled;
    _ruleOf95HsEnabled = rules.ruleOf95HsFallEnabled;
    _koEnabled = rules.koRules != null;
  }

  void _fillGroupFields(int groupIndex) {
    final groupRules =
        (_cachedRules!.rounds[_selectedRoundIndex] as DefaultTeamCompetitionRoundRules)
            .groups[_selectedGroupIndex];
    _sortStartlistBeforeGroup = groupRules.sortStartList;
  }

  DefaultCompetitionRules _constructAndCache() {
    final rounds = List.of(_cachedRules!.rounds);
    rounds[_selectedRoundIndex] = _constructCurrentRound();
    final rules = _competitionType == CompetitionTypeByEntity.individual
        ? DefaultCompetitionRules<Jumper>(
            rounds: _ensureCorrectRoundTypes(rounds),
          )
        : DefaultCompetitionRules<CompetitionTeam>(
            rounds: _ensureCorrectRoundTypes(rounds),
          );
    _cachedRules = rules;
    setState(() {
      if (rules is DefaultCompetitionRules<CompetitionTeam>) {
        _groupsCount = (_cachedRules!.rounds[_selectedRoundIndex]
                as DefaultTeamCompetitionRoundRules)
            .groupsCount;
      }
    });
    return rules;
  }

  DefaultCompetitionRoundRules _constructCurrentRound() {
    final limit = _entitiesLimitType != null
        ? EntitiesLimit(
            count: int.parse(_entitiesLimitCountController.text),
            type: _entitiesLimitType!,
          )
        : null;

    switch (_competitionType) {
      case CompetitionTypeByEntity.individual:
        return DefaultIndividualCompetitionRoundRules(
          limit: limit,
          startlistIsSorted: _startlistIsSorted,
          bibsAreReassigned: _bibsAreReassigned,
          gateCanChange: _gateCanChange,
          gateCompensationsEnabled: _gateCompensationsEnabled,
          windCompensationsEnabled: _windCompensationsEnabled,
          windAverager: _windAverager,
          inrunLightsEnabled: _inrunLightsEnabled,
          dsqEnabled: _dsqEnabled,
          positionsCreator: _positionsCreator,
          ruleOf95HsFallEnabled: _ruleOf95HsEnabled,
          judgesCount: int.parse(_judgesCountController.text),
          significantJudgesCount: int.parse(_significantJudgesCountController.text),
          competitionScoreCreator: _competitionScoreCreator
              as CompetitionScoreCreator<CompetitionScore<Jumper>>,
          jumpScoreCreator: _jumpScoreCreator,
          judgesCreator: _judgesCreator,
          koRules: _koEnabled ? _constructKoRulesForCurrentRound() : null,
        );
      case CompetitionTypeByEntity.team:
        List<TeamCompetitionGroupRules> newGroups;
        final currentRound = _cachedRules!.rounds[_selectedRoundIndex];
        if (currentRound is DefaultTeamCompetitionRoundRules) {
          newGroups = List.of(currentRound.groups);
        } else {
          newGroups = List.of(
            context
                .read<DefaultItemsRepo>()
                .get<DefaultTeamCompetitionRoundRules>()
                .groups,
          );
        }
        newGroups[_selectedGroupIndex] = _constructRulesForCurrentGroup();
        return DefaultTeamCompetitionRoundRules(
          limit: limit,
          startlistIsSorted: _startlistIsSorted,
          bibsAreReassigned: _bibsAreReassigned,
          gateCanChange: _gateCanChange,
          gateCompensationsEnabled: _gateCompensationsEnabled,
          windCompensationsEnabled: _windCompensationsEnabled,
          windAverager: _windAverager,
          inrunLightsEnabled: _inrunLightsEnabled,
          dsqEnabled: _dsqEnabled,
          positionsCreator: _positionsCreator,
          ruleOf95HsFallEnabled: _ruleOf95HsEnabled,
          judgesCount: int.parse(_judgesCountController.text),
          significantJudgesCount: int.parse(_significantJudgesCountController.text),
          competitionScoreCreator: _competitionScoreCreator
              as CompetitionScoreCreator<CompetitionScore<CompetitionTeam>>,
          jumpScoreCreator: _jumpScoreCreator,
          judgesCreator: _judgesCreator,
          koRules: _koEnabled ? _constructKoRulesForCurrentRound() : null,
          groups: newGroups,
        );
    }
  }

  List<T> _ensureCorrectRoundTypes<T>(List<DefaultCompetitionRoundRules> rounds) {
    final defaultTeamRoundRules =
        context.read<DefaultItemsRepo>().get<DefaultTeamCompetitionRoundRules>();
    final defaultIndividualRoundRules =
        context.read<DefaultItemsRepo>().get<DefaultIndividualCompetitionRoundRules>();

    if (T == DefaultCompetitionRoundRules<CompetitionTeam>) {
      return rounds
          .map((roundRules) {
            if (roundRules is DefaultIndividualCompetitionRoundRules) {
              return roundRules.toTeam(
                competitionScoreCreator: defaultTeamRoundRules.competitionScoreCreator
                    as CompetitionScoreCreator<CompetitionTeamScore>,
                groups: defaultTeamRoundRules.groups,
              );
            } else {
              return roundRules;
            }
          })
          .toList()
          .cast();
    } else if (T == DefaultCompetitionRoundRules<Jumper>) {
      return rounds
          .map((roundRules) {
            if (roundRules is DefaultTeamCompetitionRoundRules) {
              return roundRules.toIndividual(
                competitionScoreCreator:
                    defaultIndividualRoundRules.competitionScoreCreator
                        as CompetitionScoreCreator<CompetitionJumperScore>,
              );
            } else {
              return roundRules;
            }
          })
          .toList()
          .cast();
    } else {
      throw UnsupportedError(
        'An unsupported type of competition round rules (${T.toString()})',
      );
    }
  }

  KoRoundRules _constructKoRulesForCurrentRound() {
    return KoRoundRules(
      advancementDeterminator: _koAdvancementDeterminator
          as KoRoundAdvancementDeterminator<dynamic,
              KoRoundAdvancementDeterminingContext>,
      advancementCount: int.parse(_groupAdvancementCountController.text),
      koGroupsCreator: _koGroupsCreator,
      groupSize: int.parse(_groupSizeController.text),
    );
  }

  TeamCompetitionGroupRules _constructRulesForCurrentGroup() {
    return TeamCompetitionGroupRules(
      sortStartList: _sortStartlistBeforeGroup,
    );
  }

  List<DropdownMenuEntry<String>> _constructEntries<T extends Object>({
    bool Function(DbEditingAvaiableObjectConfig<T> config)? condition,
  }) {
    var objects = context.read<DbEditingAvailableObjectsRepo<T>>().objects;
    if (condition != null) {
      objects = objects.where(condition).toList();
    }
    final entries = objects.map((windAveragerObject) {
      return DropdownMenuEntry<String>(
        value: windAveragerObject.key,
        label: windAveragerObject.displayName,
      );
    });
    return entries.toList();
  }

  void _ensureCorrectCompetitionScoreCreator() {
    final repo = context.read<DbEditingAvailableObjectsRepo<CompetitionScoreCreator>>();
    final whereType = switch (_competitionType) {
      CompetitionTypeByEntity.individual => repo.objects.whereType<
          DbEditingAvaiableObjectConfig<
              CompetitionScoreCreator<CompetitionJumperScore>>>(),
      CompetitionTypeByEntity.team => repo.objects.whereType<
          DbEditingAvaiableObjectConfig<CompetitionScoreCreator<CompetitionTeamScore>>>(),
    };
    final firstDefault = whereType.first.object as CompetitionScoreCreator;
    _competitionScoreCreator = firstDefault;
    _competitionScoreCreatorController.text = repo.getKeyByObject(firstDefault);
  }

  bool _validateFormFields() {
    final ok = _koGroupsCreatorFormFieldKey.currentState!.validate() &&
        _koRoundAdvancementDeterminatorFormFieldKey.currentState!.validate() &&
        _entitiesLimitCountFormFieldKey.currentState!.validate();
    return ok;
  }

  bool get judgesEnabled => (int.tryParse(_judgesCountController.text) ?? 0) > 0;
}

enum CompetitionTypeByEntity {
  individual,
  team;

  Type toEntityType() {
    return this == CompetitionTypeByEntity.individual ? Jumper : Team;
  }
}
