import 'package:flutter/material.dart';
import 'package:sj_manager/enums/db_editable_item_type.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_tiles/hill_info_list_tile.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_tiles/jumper_info_list_tile.dart';

class AppropriateDbItemListTile extends StatelessWidget {
  const AppropriateDbItemListTile({
    super.key,
    required this.itemType,
    required this.item,
    required this.indexInList,
    required this.onItemTap,
    required this.selected,
    required this.reorderable,
  });

  final DbEditableItemType itemType;
  final int indexInList;
  final dynamic item;
  final Function() onItemTap;
  final bool selected;
  final bool reorderable;

  @override
  Widget build(BuildContext context) {
    return switch (itemType) {
      DbEditableItemType.maleJumper ||
      DbEditableItemType.femaleJumper =>
        JumperInfoListTile(
          reorderable: reorderable,
          indexInList: indexInList,
          jumper: item,
          onTap: onItemTap,
          selected: selected,
        ),
      DbEditableItemType.hill => HillInfoListTile(
          reorderable: reorderable,
          indexInList: indexInList,
          hill: item,
          onTap: onItemTap,
          selected: selected,
        ),
    };
  }
}
