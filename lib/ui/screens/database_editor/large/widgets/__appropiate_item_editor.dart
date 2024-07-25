part of '../../database_editor_screen.dart';

class _AppropiateItemEditor extends StatefulWidget {
  const _AppropiateItemEditor({
    super.key,
    required this.itemType,
    required this.onChange,
  });

  final DbEditableItemType itemType;
  final Function(Object?) onChange;

  @override
  State<_AppropiateItemEditor> createState() => _AppropiateItemEditorState();
}

class _AppropiateItemEditorState extends State<_AppropiateItemEditor> {
  final _jumperEditorKey = GlobalKey<JumperEditorState>();
  final _hillEditorKey = GlobalKey<HillEditorState>();

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
          }
        });
  }

  void fill(dynamic item) {
    switch (widget.itemType) {
      case DbEditableItemType.maleJumper:
      case DbEditableItemType.femaleJumper:
        _jumperEditorKey.currentState?.setUp(item);
      case DbEditableItemType.hill:
        _hillEditorKey.currentState?.setUp(item);
    }
  }
}
