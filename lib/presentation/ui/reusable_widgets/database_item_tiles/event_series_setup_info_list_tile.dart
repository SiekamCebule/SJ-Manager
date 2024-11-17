import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/data/models/errors/translation_not_found.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_image_asset.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_setup.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_images/db_item_image.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/utilities/utils/context_maybe_read.dart';

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
    late final String translatedName;
    try {
      translatedName = eventSeriesSetup.name(context);
    } on TranslationNotFoundError {
      translatedName = translate(context).unnamed;
    }
    final imageGeneratingSetup =
        context.maybeRead<DbItemImageGeneratingSetup<EventSeriesTrophyImageWrapper>>();
    final tile = ListTile(
      leading: DbItemImage<EventSeriesTrophyImageWrapper>(
        width: 40,
        height: 40,
        item: EventSeriesTrophyImageWrapper(eventSeriesSetup: eventSeriesSetup),
        setup: imageGeneratingSetup,
        errorBuilder: (ctx, error, stackTrace) => const Icon(
          Symbols.trophy,
          size: 40,
        ),
      ),
      title: Text(translatedName),
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
