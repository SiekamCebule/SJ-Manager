import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/domain/entities/simulation/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/default_competition_rules_preset_editor/default_competition_rules_editor.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/countries/country_flag.dart';

class SimpleCalendarEditorCompetitionRecordTile extends StatelessWidget {
  const SimpleCalendarEditorCompetitionRecordTile({
    super.key,
    required this.competitionRecord,
    required this.indexInList,
    required this.onItemTap,
    required this.selected,
    required this.reorderable,
  });

  final CalendarMainCompetitionRecord competitionRecord;
  final int indexInList;
  final VoidCallback onItemTap;
  final bool selected;
  final bool reorderable;

  @override
  Widget build(BuildContext context) {
    final competitionIsTeam =
        competitionRecord.setup.typeByEntity == CompetitionTypeByEntity.team;
    final tile = ListTile(
      title: SizedBox(width: 100, child: Text(competitionRecord.hill.toString())),
      leading: CountryFlag(
        country: competitionRecord.hill.country,
        width: 28,
      ),
      onTap: onItemTap,
      selected: selected,
      trailing: Padding(
        padding: const EdgeInsets.only(right: 35),
        child: SizedBox(
          width: 160,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              competitionIsTeam ? const Icon(Symbols.group) : const Icon(Symbols.person),
              Visibility(
                visible: competitionRecord.setup.qualificationsRules != null,
                child: Text(
                  '+Q',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Visibility(
                visible: competitionRecord.setup.mainCompRules.competitionRules.rounds
                    .any((roundRules) => roundRules.koRules != null),
                child: Text(
                  'KO',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return reorderable
        ? ReorderableDragStartListener(
            index: indexInList,
            child: tile,
          )
        : tile;
  }
}
