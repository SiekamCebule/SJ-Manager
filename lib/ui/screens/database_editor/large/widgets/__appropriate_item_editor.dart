part of '../../database_editor_screen.dart';

class _AppropriateItemEditor extends StatefulWidget {
  const _AppropriateItemEditor({
    super.key,
    required this.itemType,
    required this.onChange,
  });

  final Type itemType;
  final Function(dynamic) onChange;

  @override
  State<_AppropriateItemEditor> createState() => _AppropriateItemEditorState();
}

class _AppropriateItemEditorState extends State<_AppropriateItemEditor> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final filtersRepo = context.watch<DbFiltersRepo>();
    final type = context.watch<DatabaseItemsTypeCubit>().state;
    context.watch<ValueRepo<_SelectedTabIndex>>();
    final initialItem = context.watch<DefaultItemsRepo>().getByTypeArgument(type);

    return DbItemEditorFactory.create(
      key: _key,
      initial: initialItem,
      context: context,
      type: type,
      onChange: widget.onChange,
      dynamicFilters: filtersRepo.streamByTypeArgument(type).value,
    );
  }

  void fill(dynamic item) {
    (_key.currentState as dynamic)?.setUp(item);
  }
}

abstract class DbItemEditorFactory {
  static Widget create({
    required Key key,
    required dynamic initial,
    required BuildContext context,
    required Type type,
    required dynamic Function(dynamic value) onChange,
    required List<Filter> dynamicFilters,
  }) {
    if (type == MaleJumper) {
      final filters = dynamicFilters.cast<Filter<MaleJumper>>();
      final searchActive = filters
              .maybeSingleWhereType<
                  ConcreteJumpersFilterWrapper<MaleJumper, JumpersFilterBySearch>>()
              ?.isValid ??
          false;
      final countryFilterActive = filters
              .maybeSingleWhereType<
                  ConcreteJumpersFilterWrapper<MaleJumper, JumpersFilterByCountry>>()
              ?.isValid ??
          false;
      return JumperEditor(
        key: key,
        onChange: onChange,
        enableEditingName: !searchActive,
        enableEditingSurname: !searchActive,
        enableEditingCountry: !countryFilterActive,
        countriesRepo: context.read(),
      );
    } else if (type == FemaleJumper) {
      final filters = dynamicFilters.cast<Filter<FemaleJumper>>();
      final searchActive = filters
              .maybeSingleWhereType<
                  ConcreteJumpersFilterWrapper<FemaleJumper, JumpersFilterBySearch>>()
              ?.isValid ??
          false;
      final countryFilterActive = filters
              .maybeSingleWhereType<
                  ConcreteJumpersFilterWrapper<FemaleJumper, JumpersFilterByCountry>>()
              ?.isValid ??
          false;
      return JumperEditor(
        key: key,
        onChange: onChange,
        enableEditingName: !searchActive,
        enableEditingSurname: !searchActive,
        enableEditingCountry: !countryFilterActive,
        countriesRepo: context.read(),
      );
    } else if (type == Hill) {
      final filters = dynamicFilters.cast<Filter<Hill>>();
      final searchActive =
          filters.maybeSingleWhereType<HillsFilterBySearch>()?.isValid ?? false;
      final sizeFilterActive =
          filters.maybeSingleWhereType<HillsFilterByTypeBySie>()?.isValid ?? false;
      final countryFilterActive =
          filters.maybeSingleWhereType<HillsFilterByCountry>()?.isValid ?? false;
      return HillEditor(
        key: key,
        onChange: onChange,
        enableEditingName: !searchActive,
        enableEditingLocality: !searchActive,
        enableEditingDimensions: !sizeFilterActive,
        enableEditingCountry: !countryFilterActive,
        countriesRepo: context.read(),
      );
    } else if (type == EventSeriesSetup) {
      return EventSeriesSetupEditor(
        key: key,
        onChange: onChange,
      );
    } else if (type == EventSeriesCalendarPreset) {
      return EventSeriesCalendarPresetThumbnail(
        key: key,
        onChange: onChange,
      );
    } else if (type == DefaultCompetitionRulesPreset) {
      return DefaultCompetitionRulesPresetEditor(
        key: key,
        initial: initial,
        onChange: onChange,
        onAdvancedEditorChosen: () {
          throw UnimplementedError();
        },
      );
    } else {
      throw TypeError();
    }
  }
}
