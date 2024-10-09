import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/simulation/event_series/event_series_calendar_preset.dart';

class EventSeriesCalendarPresetInfoListTile extends StatelessWidget {
  const EventSeriesCalendarPresetInfoListTile({
    super.key,
    required this.reorderable,
    this.onTapWithCtrl,
    this.indexInList,
    required this.eventSeriesCalendarPreset,
    required this.onTap,
    required this.selected,
  }) : assert(reorderable == false || (reorderable == true && indexInList != null));

  final bool reorderable;
  final int? indexInList;
  final VoidCallback? onTapWithCtrl;
  final VoidCallback? onTap;
  final EventSeriesCalendarPreset eventSeriesCalendarPreset;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      leading: const Icon(Symbols.calendar_month),
      title: Text(eventSeriesCalendarPreset.name),
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
