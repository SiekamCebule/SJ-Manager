import 'package:flutter/material.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_tiles/jumper_info_list_tile.dart';

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

  final DatabaseEditorItemsType itemType;
  final int indexInList;
  final dynamic item;
  final Function() onItemTap;
  final bool selected;
  final bool reorderable;

  @override
  Widget build(BuildContext context) {
    return DbItemInfoTileFactory.create(
      itemType: itemType,
      item: item,
      indexInList: indexInList,
      onItemTap: onItemTap,
      selected: selected,
      reorderable: reorderable,
    );
  }
}

abstract class DbItemInfoTileFactory {
  static Widget create({
    required DatabaseEditorItemsType itemType,
    required dynamic item,
    required int indexInList,
    required Function() onItemTap,
    required bool selected,
    required bool reorderable,
  }) {
    if (itemType == DatabaseEditorItemsType.maleJumper ||
        itemType == DatabaseEditorItemsType.femaleJumper) {
      return JumperInfoListTile(
        reorderable: reorderable,
        indexInList: indexInList,
        jumper: item,
        onTap: onItemTap,
        selected: selected,
      );
    } else {
      throw TypeError();
    }
  }
}
