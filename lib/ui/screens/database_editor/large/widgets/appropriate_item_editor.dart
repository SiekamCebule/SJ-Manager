part of '../../database_editor_screen.dart';

class AppropriateItemEditor extends StatefulWidget {
  const AppropriateItemEditor({
    super.key,
    required this.itemType,
    required this.onChange,
  });

  final Type itemType;
  final Function(dynamic) onChange;

  @override
  State<AppropriateItemEditor> createState() => AppropriateItemEditorState();
}

class AppropriateItemEditorState extends State<AppropriateItemEditor> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final filtersRepo = context.watch<DbFiltersRepo>();
    final type = context.watch<DatabaseItemsCubit>().state.itemsType;
    context.watch<ValueRepo<_SelectedTabIndex>>();
    final initialItem = type == EventSeriesCalendarPreset
        ? context.watch<DefaultItemsRepo>().get<SimpleEventSeriesCalendarPreset>()
        : context.watch<DefaultItemsRepo>().getByTypeArgument(type);

    return _DbItemEditorFactory.create(
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

abstract class _DbItemEditorFactory {
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
              .singleWhereTypeOrNull<
                  ConcreteJumpersFilterWrapper<MaleJumper, JumpersFilterBySearch>>()
              ?.isValid ??
          false;
      final countryFilterActive = filters
              .singleWhereTypeOrNull<
                  ConcreteJumpersFilterWrapper<MaleJumper, JumpersFilterByCountry>>()
              ?.isValid ??
          false;
      final countriesRepo = (context.read<DatabaseEditorCountriesCubit>().state
              as DatabaseEditorCountriesReady)
          .maleJumpersCountries;
      return JumperEditor(
        key: key,
        onChange: onChange,
        enableEditingName: !searchActive,
        enableEditingSurname: !searchActive,
        enableEditingCountry: !countryFilterActive,
        countriesRepo: countriesRepo,
      );
    } else if (type == FemaleJumper) {
      final filters = dynamicFilters.cast<Filter<FemaleJumper>>();
      final searchActive = filters
              .singleWhereTypeOrNull<
                  ConcreteJumpersFilterWrapper<FemaleJumper, JumpersFilterBySearch>>()
              ?.isValid ??
          false;
      final countryFilterActive = filters
              .singleWhereTypeOrNull<
                  ConcreteJumpersFilterWrapper<FemaleJumper, JumpersFilterByCountry>>()
              ?.isValid ??
          false;
      final countriesRepo = (context.read<DatabaseEditorCountriesCubit>().state
              as DatabaseEditorCountriesReady)
          .femaleJumpersCountries;
      return JumperEditor(
        key: key,
        onChange: onChange,
        enableEditingName: !searchActive,
        enableEditingSurname: !searchActive,
        enableEditingCountry: !countryFilterActive,
        countriesRepo: countriesRepo,
      );
    } else if (type == Hill) {
      final filters = dynamicFilters.cast<Filter<Hill>>();
      final searchActive =
          filters.singleWhereTypeOrNull<HillsFilterBySearch>()?.isValid ?? false;
      final sizeFilterActive =
          filters.singleWhereTypeOrNull<HillsFilterByTypeBySie>()?.isValid ?? false;
      final countryFilterActive =
          filters.singleWhereTypeOrNull<HillsFilterByCountry>()?.isValid ?? false;
      final countriesRepo = (context.read<DatabaseEditorCountriesCubit>().state
              as DatabaseEditorCountriesReady)
          .universalCountries;
      return HillEditor(
        key: key,
        onChange: onChange,
        enableEditingName: !searchActive,
        enableEditingLocality: !searchActive,
        enableEditingDimensions: !sizeFilterActive,
        enableEditingCountry: !countryFilterActive,
        countriesRepo: countriesRepo,
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
