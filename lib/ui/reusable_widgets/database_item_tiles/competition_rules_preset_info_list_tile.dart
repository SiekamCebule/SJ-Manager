import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';

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
  final CompetitionRulesPreset competitionRulesPreset;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
          Symbols.rule), // TODO: Logo of assigned event series, or calendar icon
      title: Text(competitionRulesPreset.name),
      onTap: onTap,
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.surfaceContainer,
      splashColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
