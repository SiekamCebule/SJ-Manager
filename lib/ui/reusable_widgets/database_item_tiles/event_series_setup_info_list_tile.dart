import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_image_asset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/ui/providers/locale_notifier.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image.dart';

class EventSeriesSetupInfoListTile extends StatelessWidget {
  const EventSeriesSetupInfoListTile({
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
      leading: DbItemImage<EventSeriesTrophyImageWrapper>(
        width: 40,
        height: 40,
        item: EventSeriesTrophyImageWrapper(eventSeriesSetup: eventSeriesSetup),
        setup: context.read(),
        errorBuilder: (ctx, error, stackTrace) => const Icon(
          Symbols.trophy,
          size: 40,
        ),
      ),
      title: Text(eventSeriesSetup.name.translate(languageCode)),
      onTap: onTap,
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.surfaceContainer,
      splashColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
