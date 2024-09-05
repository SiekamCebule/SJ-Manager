import 'package:flutter/material.dart';
import 'package:sj_manager/bloc/calendar_editing/simple_calendar_editing_cubit.dart';
import 'package:sj_manager/bloc/database_editing/change_status_cubit.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/ui/database_item_editors/calendar_editor/simple_calendar_editor/competition_main_record_editor.dart';

import 'package:sj_manager/ui/database_item_editors/calendar_editor/simple_calendar_editor/simple_calendar_editor_competitions_list.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/ui/screens/database_editor/database_editor_screen.dart';
import 'package:sj_manager/utils/colors.dart';

part '__add_fab.dart';
part '__remove_fab.dart';

class SimpleCalendarEditorScreen extends StatefulWidget {
  const SimpleCalendarEditorScreen({
    super.key,
    required this.preset,
  });

  final SimpleEventSeriesCalendarPreset preset;

  @override
  State<SimpleCalendarEditorScreen> createState() => _SimpleCalendarEditorScreenState();
}

class _SimpleCalendarEditorScreenState extends State<SimpleCalendarEditorScreen> {
  late SimpleCalendarEditingCubit _editingCubit;

  @override
  void initState() {
    _editingCubit = SimpleCalendarEditingCubit(preset: widget.preset);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.preset.name),
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
              competitionRecords: _editingCubit.state.competitionRecords,
            ),
          ),
          Expanded(
            flex: 30,
            child: DbEditorAnimatedEditor(
              nonEmptyStateWidget: CompetitionMainRecordEditor(
                onChange: (record) {
                  print('new record: $record');
                },
              ),
              emptyStateWidget: const ItemEditorEmptyStateBody(),
            ),
          ),
        ],
      ),
    );
  }
}
