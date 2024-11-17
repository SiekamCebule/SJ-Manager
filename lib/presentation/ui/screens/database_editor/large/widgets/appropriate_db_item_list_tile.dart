import 'package:flutter/material.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_setup.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/hill.dart';
import 'package:sj_manager/features/game_variants/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_tiles/competition_rules_preset_info_list_tile.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_tiles/event_series_calendar_preset_info_list_tile.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_tiles/event_series_setup_info_list_tile.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_tiles/hill_info_list_tile.dart';
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

  final Type itemType;
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
    required Type itemType,
    required dynamic item,
    required int indexInList,
    required Function() onItemTap,
    required bool selected,
    required bool reorderable,
  }) {
    if (itemType == MaleJumperDbRecord || itemType == FemaleJumperDbRecord) {
      return JumperInfoListTile(
        reorderable: reorderable,
        indexInList: indexInList,
        jumper: item,
        onTap: onItemTap,
        selected: selected,
      );
    } else if (itemType == Hill) {
      return HillInfoListTile(
        reorderable: reorderable,
        indexInList: indexInList,
        hill: item,
        onTap: onItemTap,
        selected: selected,
      );
    } else if (itemType == EventSeriesSetup) {
      return EventSeriesSetupInfoListTile(
        reorderable: reorderable,
        indexInList: indexInList,
        eventSeriesSetup: item,
        onTap: onItemTap,
        selected: selected,
      );
    } else if (itemType == EventSeriesCalendarPreset) {
      return EventSeriesCalendarPresetInfoListTile(
        reorderable: reorderable,
        indexInList: indexInList,
        eventSeriesCalendarPreset: item,
        onTap: onItemTap,
        selected: selected,
      );
    } else if (itemType == DefaultCompetitionRulesPreset) {
      return CompetitionRulesPresetInfoListTile(
        reorderable: reorderable,
        indexInList: indexInList,
        competitionRulesPreset: item,
        onTap: onItemTap,
        selected: selected,
      );
    } else {
      throw TypeError();
    }
  }
}
