import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_preset.dart';

class CompetitionRulesPresetInfoListTile extends StatelessWidget {
  const CompetitionRulesPresetInfoListTile({
    super.key,
    required this.reorderable,
    this.onTapWithCtrl,
    this.indexInList,
    required this.competitionRulesPreset,
    required this.onTap,
    required this.selected,
  }) : assert(reorderable == false || (reorderable == true && indexInList != null));

  final bool reorderable;
  final int? indexInList;
  final VoidCallback? onTapWithCtrl;
  final VoidCallback? onTap;
  final DefaultCompetitionRulesPreset competitionRulesPreset;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      leading: Icon(
        competitionRulesPreset.competitionRules
                is DefaultCompetitionRules<SimulationJumper>
            ? Symbols.person
            : Symbols.group,
      ),
      title: Text(competitionRulesPreset.name),
      onTap: onTap,
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.surfaceContainer,
      splashColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
    return reorderable
        ? ReorderableDragStartListener(
            index: indexInList!,
            child: tile,
          )
        : tile;
  }
}
