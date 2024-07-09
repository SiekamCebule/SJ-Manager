import 'package:flutter/material.dart';
import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/jumper_info_list_tile.dart';

class AppropiateDbItemListTile extends StatelessWidget {
  const AppropiateDbItemListTile({
    super.key,
    required this.itemType,
    required this.item,
    required this.indexInList,
    required this.onItemTap,
    required this.selected,
    required this.reorderable,
  });

  final DatabaseItemType itemType;
  final int indexInList;
  final dynamic item;
  final Function() onItemTap;
  final bool selected;
  final bool reorderable;

  @override
  Widget build(BuildContext context) {
    return switch (itemType) {
      DatabaseItemType.maleJumper || DatabaseItemType.femaleJumper => JumperInfoListTile(
          reorderable: reorderable,
          indexInList: indexInList,
          jumper: item,
          onTap: onItemTap,
          selected: selected,
        ),
    };
  }
}
