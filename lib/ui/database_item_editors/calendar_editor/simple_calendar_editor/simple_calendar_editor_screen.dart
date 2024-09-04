import 'package:flutter/material.dart';
import 'package:sj_manager/bloc/calendar_editing/simple_calendar_editing_cubit.dart';
import 'package:sj_manager/bloc/database_editing/change_status_cubit.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';

import 'package:sj_manager/ui/database_item_editors/calendar_editor/simple_calendar_editor/simple_calendar_editor_competitions_list.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/ui/database_item_editors/calendar_editor/simple_calendar_editor/simple_calendar_item_editor.dart';
import 'package:sj_manager/ui/screens/database_editor/database_editor_screen.dart';
import 'package:sj_manager/utils/colors.dart';

part '__add_fab.dart';
part '__remove_fab.dart';

class SimpleCalendarEditor extends StatefulWidget {
  const SimpleCalendarEditor({super.key});

  @override
  State<SimpleCalendarEditor> createState() => _SimpleCalendarEditorState();
}

class _SimpleCalendarEditorState extends State<SimpleCalendarEditor> {
  @override
  Widget build(BuildContext context) {
    final simpleCalendarEditingCubit = context.watch<SimpleCalendarEditingCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puchar Świata 1997/98'),
      ),
      body: Row(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _AddFab(),
              _RemoveFab(),
            ],
          ),
          Expanded(
            flex: 10,
            child: SimpleCalendarEditorCompetitionsList(
              competitionRecords: simpleCalendarEditingCubit.state.competitionRecords,
            ),
          ),
          const Expanded(
            flex: 30,
            child: DbEditorAnimatedEditor(
              nonEmptyStateWidget: SimpleCalendarItemEditor(),
              emptyStateWidget: ItemEditorEmptyStateBody(),
            ),
          ),
        ],
      ),
    );
  }
}
