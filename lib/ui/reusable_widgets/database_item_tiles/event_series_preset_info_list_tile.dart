import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/ui/providers/locale_notifier.dart';

class EventSeriesPresetInfoListTile extends StatelessWidget {
  const EventSeriesPresetInfoListTile({
    super.key,
    required this.reorderable,
    this.onTapWithCtrl,
    this.indexInList,
    required this.eventSeriesSetup,
    required this.onTap,
    required this.selected,
  }) : assert(reorderable == false || (reorderable == true && indexInList != null));

  final bool reorderable;
  final int? indexInList;
  final VoidCallback? onTapWithCtrl;
  final VoidCallback? onTap;
  final EventSeriesSetup eventSeriesSetup;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<LocaleCubit>().languageCode;
    return ListTile(
      leading: const Text('IMG'), // TODO: Logo
      title: Text(eventSeriesSetup.name.translate(languageCode)),
      onTap: onTap,
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.surfaceContainer,
      splashColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
