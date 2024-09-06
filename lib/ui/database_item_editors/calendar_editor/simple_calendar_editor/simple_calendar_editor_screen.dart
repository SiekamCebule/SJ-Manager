import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/bloc/calendar_editing/simple_calendar_editing_cubit.dart';
import 'package:sj_manager/bloc/database_editing/change_status_cubit.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/ui/database_item_editors/calendar_editor/simple_calendar_editor/competition_main_record_editor.dart';

import 'package:sj_manager/ui/database_item_editors/calendar_editor/simple_calendar_editor/simple_calendar_editor_competitions_list.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/animations/animated_visibility.dart';
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
  late SelectedIndexesRepo _selectedIndexesRepo;
  late ChangeStatusCubit _changeStatusCubit;

  @override
  void initState() {
    super.initState();
    _editingCubit = SimpleCalendarEditingCubit(preset: widget.preset);
    _selectedIndexesRepo = SelectedIndexesRepo();
    _changeStatusCubit = ChangeStatusCubit();
  }

  @override
  void dispose() {
    _editingCubit.close();
    _selectedIndexesRepo.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fabsGap = Gap(UiDatabaseEditorConstants.verticalSpaceBetweenFabs);
    final shouldShowList = _editingCubit.state.competitionRecords.isNotEmpty;
    return RepositoryProvider.value(
      value: _selectedIndexesRepo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _changeStatusCubit),
          BlocProvider.value(value: _editingCubit),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.preset.name),
          ),
          body: Row(
            children: [
              fabsGap,
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  fabsGap,
                  _AddFab(),
                  fabsGap,
                  _RemoveFab(),
                ],
              ),
              fabsGap,
              Expanded(
                flex: 10,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    AnimatedVisibility(
                      duration: Durations.medium1,
                      curve: Curves.easeIn,
                      visible: !shouldShowList,
                      child: DbEditorItemsListEmptyStateBody(
                        contentType:
                            DbEditorItemsListEmptyStateContentType.addFirstElement,
                        removeFilters: () {
                          throw UnsupportedError(
                              'Cannot remove filters when editing simple calendar preset, because filters are not supported here');
                        },
                      ),
                    ),
                    AnimatedVisibility(
                      duration: Durations.medium1,
                      curve: Curves.easeIn,
                      visible: shouldShowList,
                      child: SimpleCalendarEditorCompetitionsList(
                        competitionRecords: _editingCubit.state.competitionRecords,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 15,
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
        ),
      ),
    );
  }
}
