import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_field.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/utils/platform.dart';

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
              SizedBox(
                width: double.infinity,
                child: SizedBox(
                  height: UiItemEditorsConstants.wideMainActionButtonHeight,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Edytuj kalendarz'),
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
    return _cachedPreset!.copyWith(name: _nameController.text);
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
