import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_field.dart';
import 'package:sj_manager/ui/dialogs/feature_not_available_dialog.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/utils/platform.dart';
import 'package:sj_manager/utils/show_dialog.dart';
import 'package:provider/provider.dart';

class EventSeriesCalendarPresetThumbnail extends StatefulWidget {
  const EventSeriesCalendarPresetThumbnail({
    super.key,
    required this.onChange,
  });

  final Function(EventSeriesCalendarPreset current) onChange;

  @override
  State<EventSeriesCalendarPresetThumbnail> createState() =>
      _EventSeriesCalendarPresetThumbnailState();
}

class _EventSeriesCalendarPresetThumbnailState
    extends State<EventSeriesCalendarPresetThumbnail> {
  late final TextEditingController _nameController;
  late final ScrollController _scrollController;

  Type get _calendarPresetType => _cachedPreset.runtimeType;
  EventSeriesCalendarPreset? _cachedPreset;

  @override
  void initState() {
    _nameController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);
    return LayoutBuilder(builder: (context, constraints) {
      return Scrollbar(
        thumbVisibility: platformIsDesktop,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              gap,
              MyTextField(
                key: const Key('name'),
                controller: _nameController,
                onChange: _onChange,
                labelText: translate(context).name,
              ),
              gap,
              SegmentedButton(
                segments: const [
                  ButtonSegment(
                    value: SimpleEventSeriesCalendarPreset,
                    label: Text('Prosty'),
                    icon: Icon(Symbols.bolt),
                  ),
                  ButtonSegment(
                    value: LowLevelEventSeriesCalendarPreset,
                    label: Text('Zaawansowany'),
                    icon: Icon(Symbols.tune),
                  ),
                ],
                onSelectionChanged: (selected) {
                  // TODO: if preset is not empty, show warning
                  setState(() {
                    if (_cachedPreset!.calendar.isEmpty) {
                      if (selected.single == SimpleEventSeriesCalendarPreset) {
                        _cachedPreset = context
                            .read<DefaultItemsRepo>()
                            .get<SimpleEventSeriesCalendarPreset>();
                      } else if (selected.single == LowLevelEventSeriesCalendarPreset) {
                        _cachedPreset = context
                            .read<DefaultItemsRepo>()
                            .get<LowLevelEventSeriesCalendarPreset>();
                      }
                      _onChange();
                    }
                  });
                },
                selected: {_calendarPresetType},
              ),
              gap,
              SizedBox(
                width: double.infinity,
                child: SizedBox(
                  height: UiItemEditorsConstants.wideMainActionButtonHeight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_calendarPresetType == SimpleEventSeriesCalendarPreset) {
                        final presets = context
                            .read<ItemsReposRegistry>()
                            .get<EventSeriesCalendarPreset>()
                            .last
                            .toList();

                        final presetIndexInList = presets.indexOf(_cachedPreset!);
                        final preset = await router.navigateTo(
                          context,
                          '/databaseEditor/simpleCalendarEditor/$presetIndexInList',
                        ) as EventSeriesCalendarPreset;
                        if (!context.mounted) return;
                        context
                            .read<ItemsReposRegistry>()
                            .getEditable(EventSeriesCalendarPreset)
                            .replace(oldIndex: presetIndexInList, newItem: preset);
                        await Future.delayed(Duration.zero);
                        if (!context.mounted) return;
                        final selectedIndexesRepo = context.read<SelectedIndexesRepo>();
                        selectedIndexesRepo.setSelection(presetIndexInList, false);
                        selectedIndexesRepo.setSelection(presetIndexInList, true);
                      } else if (_calendarPresetType ==
                          LowLevelEventSeriesCalendarPreset) {
                        showSjmDialog(
                          context: context,
                          child: const FeatureNotAvailableDialog(),
                        );
                      }
                    },
                    child: Text(
                      _calendarPresetType == SimpleEventSeriesCalendarPreset
                          ? 'Edytuj kalendarz w trybie prostym'
                          : 'Edytuj kalendarz w trybie zaawansowanym',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _onChange() {
    widget.onChange(_constructAndCache());
  }

  EventSeriesCalendarPreset _constructAndCache() {
    if (_calendarPresetType == SimpleEventSeriesCalendarPreset) {
      _cachedPreset = SimpleEventSeriesCalendarPreset(
        name: _nameController.text,
        highLevelCalendar:
            (_cachedPreset as SimpleEventSeriesCalendarPreset).highLevelCalendar,
      );
    } else if (_calendarPresetType == LowLevelEventSeriesCalendarPreset) {
      _cachedPreset = LowLevelEventSeriesCalendarPreset(
        name: _nameController.text,
        calendar: (_cachedPreset as LowLevelEventSeriesCalendarPreset).calendar,
      );
    }
    return _cachedPreset!;
  }

  void setUp(EventSeriesCalendarPreset preset) {
    setState(() {
      _cachedPreset = preset;
    });
    _fillFields(preset);
    FocusScope.of(context).unfocus();
  }

  void _fillFields(EventSeriesCalendarPreset preset) {
    _nameController.text =
        preset.name.isNotEmpty ? preset.name : translate(context).unnamed;
  }
}
