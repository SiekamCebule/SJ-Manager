import 'package:flutter/material.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';

class JumperInfoListTile extends StatelessWidget {
  const JumperInfoListTile({
    super.key,
    required this.reorderable,
    this.onTapWithCtrl,
    this.indexInList,
    required this.jumper,
    required this.onTap,
    required this.selected,
  }) : assert(reorderable == false || (reorderable == true && indexInList != null));

  final bool reorderable;
  final int? indexInList;
  final VoidCallback? onTapWithCtrl;
  final VoidCallback? onTap;
  final Jumper jumper;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      leading: CountryFlag(
        country: jumper.country,
        width: UiGlobalConstants.smallCountryFlagWidth,
      ),
      title: Text('${jumper.name} ${jumper.surname}'),
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
