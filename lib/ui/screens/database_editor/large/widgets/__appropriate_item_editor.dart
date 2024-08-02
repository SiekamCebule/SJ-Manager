part of '../../database_editor_screen.dart';

class _AppropriateItemEditor extends StatefulWidget {
  const _AppropriateItemEditor({
    super.key,
    required this.itemType,
    required this.onChange,
  });

  final DbEditableItemType itemType;
  final Function(Object?) onChange;

  @override
  State<_AppropriateItemEditor> createState() => _AppropriateItemEditorState();
}

class _AppropriateItemEditorState extends State<_AppropriateItemEditor> {
  final _jumperEditorKey = GlobalKey<JumperEditorState>();
  final _hillEditorKey = GlobalKey<HillEditorState>();
  final _eventSeriesEditorKey = GlobalKey<EventSeriesSetupEditorState>();

  @override
  Widget build(BuildContext context) {
    final filtersRepo = context.watch<DbFiltersRepo>();
    context.watch<ValueRepo<_SelectedTabIndex>>();

    return StreamBuilder(
        stream: filtersRepo.byType(context.watch<DatabaseItemsTypeCubit>().state),
        builder: (context, filters) {
          switch (widget.itemType) {
            case DbEditableItemType.maleJumper:
              {
                final searchActive = filtersRepo.maleJumpersFilters.value
                        .maybeSingleWhereType<JumpersFilterBySearch>()
                        ?.isValid ??
                    false;

                final countryFilterActive = filtersRepo.maleJumpersFilters.value
                        .maybeSingleWhereType<JumpersFilterByCountry>()
                        ?.isValid ??
                    false;

                return JumperEditor(
                  key: _jumperEditorKey,
                  onChange: widget.onChange,
                  enableEditingName: !searchActive,
                  enableEditingSurname: !searchActive,
                  enableEditingCountry: !countryFilterActive,
                  countriesRepo: context.read(),
                );
              }
            case DbEditableItemType.femaleJumper:
              {
                final searchActive = filtersRepo.femaleJumpersFilters.value
                        .maybeSingleWhereType<JumpersFilterBySearch>()
                        ?.isValid ??
                    false;
                final countryFilterActive = filtersRepo.femaleJumpersFilters.value
                        .maybeSingleWhereType<JumpersFilterByCountry>()
                        ?.isValid ??
                    false;

                return JumperEditor(
                  key: _jumperEditorKey,
                  onChange: widget.onChange,
                  enableEditingName: !searchActive,
                  enableEditingSurname: !searchActive,
                  enableEditingCountry: !countryFilterActive,
                  countriesRepo: context.read(),
                );
              }
            case DbEditableItemType.hill:
              {
                final searchActive = filtersRepo.hillsFilters.value
                        .maybeSingleWhereType<HillsFilterBySearch>()
                        ?.isValid ??
                    false;
                final sizeFilterActive = filtersRepo.hillsFilters.value
                        .maybeSingleWhereType<HillsFilterByTypeBySie>()
                        ?.isValid ??
                    false;
                final countryFilterActive = filtersRepo.hillsFilters.value
                        .maybeSingleWhereType<HillsFilterByCountry>()
                        ?.isValid ??
                    false;

                return HillEditor(
                  key: _hillEditorKey,
                  onChange: widget.onChange,
                  enableEditingName: !searchActive,
                  enableEditingLocality: !searchActive,
                  enableEditingDimensions: !sizeFilterActive,
                  enableEditingCountry: !countryFilterActive,
                  countriesRepo: context.read(),
                );
              }
            case DbEditableItemType.eventSeriesSetup:
              return EventSeriesSetupEditor(
                key: _eventSeriesEditorKey,
                onChange: widget.onChange,
              );
            case DbEditableItemType.eventSeriesCalendarPreset:
              throw UnimplementedError();
            case DbEditableItemType.competitionRulesPreset:
              throw UnimplementedError();
          }
        });
  }

  void fill(dynamic item) {
    // TODO: fill the fill()
    switch (widget.itemType) {
      case DbEditableItemType.maleJumper:
      case DbEditableItemType.femaleJumper:
        _jumperEditorKey.currentState?.setUp(item);
      case DbEditableItemType.hill:
        _hillEditorKey.currentState?.setUp(item);
      case DbEditableItemType.eventSeriesSetup:
        _eventSeriesEditorKey.currentState?.setUp(item);
      case DbEditableItemType.eventSeriesCalendarPreset:
        throw UnimplementedError();
      case DbEditableItemType.competitionRulesPreset:
        throw UnimplementedError();
    }
  }
}
