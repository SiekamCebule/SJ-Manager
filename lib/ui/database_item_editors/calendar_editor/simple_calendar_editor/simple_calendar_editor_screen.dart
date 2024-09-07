import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/bloc/calendar_editing/simple_calendar_editing_cubit.dart';
import 'package:sj_manager/bloc/database_editing/change_status_cubit.dart';
import 'package:sj_manager/json/simulation_db_loading/main_competition_record_parser.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
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
    required this.onChange,
  });

  final SimpleEventSeriesCalendarPreset preset;
  final Function(SimpleEventSeriesCalendarPreset preset) onChange;

  @override
  State<SimpleCalendarEditorScreen> createState() => _SimpleCalendarEditorScreenState();
}

class _SimpleCalendarEditorScreenState extends State<SimpleCalendarEditorScreen> {
  late SimpleCalendarEditingCubit _editingCubit;
  late SelectedIndexesRepo _selectedIndexesRepo;
  late ChangeStatusCubit _changeStatusCubit;
  late SimpleEventSeriesCalendarPreset _cached;

  @override
  void initState() {
    super.initState();
    _editingCubit = SimpleCalendarEditingCubit(preset: widget.preset);
    _selectedIndexesRepo = SelectedIndexesRepo();
    _changeStatusCubit = ChangeStatusCubit();
    _cached = widget.preset;
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

    return RepositoryProvider.value(
      value: _selectedIndexesRepo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _changeStatusCubit),
          BlocProvider.value(value: _editingCubit),
        ],
        child: StreamBuilder(
            stream: _editingCubit.stream,
            builder: (context, snapshot) {
              final shouldShowList = _editingCubit.state.competitionRecords.isNotEmpty;
              return Scaffold(
                appBar: AppBar(
                  title: Text(widget.preset.name),
                  leading: IconButton(
                    icon: const Icon(Symbols.arrow_back),
                    onPressed: () {
                      router.pop(context, _cached);
                    },
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Row(
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
                                    contentType: DbEditorItemsListEmptyStateContentType
                                        .addFirstElement,
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
                                    competitionRecords:
                                        _editingCubit.state.competitionRecords,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                            width: 30,
                          ),
                          const Gap(5),
                          Expanded(
                            flex: 15,
                            child: DbEditorAnimatedEditor(
                              nonEmptyStateWidget: CompetitionMainRecordEditor(
                                onChange: (competitionRecord) async {
                                  final selectedIndex = _selectedIndexesRepo.last.single;
                                  context
                                      .read<SimpleCalendarEditingCubit>()
                                      .replaceCompetition(
                                        index: selectedIndex,
                                        record: competitionRecord,
                                      );
                                  _cached = _cached.copyWith(
                                    highLevelCalendar: _cached.highLevelCalendar.copyWith(
                                      highLevelCompetitions:
                                          _editingCubit.state.competitionRecords,
                                    ),
                                  );
                                },
                              ),
                              emptyStateWidget: const ItemEditorEmptyStateBody(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
