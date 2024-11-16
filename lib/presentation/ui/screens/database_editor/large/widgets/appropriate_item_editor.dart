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
    final itemsState = context.watch<DatabaseItemsCubit>().state;
    final type = itemsState.itemsType;
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
      enableEditing: !itemsState.hasValidFilters,
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
    required bool enableEditing,
  }) {
    if (type == MaleJumperDbRecord) {
      final countriesRepo = (context.read<DatabaseEditorCountriesCubit>().state
              as DatabaseEditorCountriesReady)
          .maleJumpersCountries;
      return JumperEditor(
        key: key,
        onChange: onChange,
        enableEditingName: enableEditing,
        enableEditingSurname: enableEditing,
        enableEditingCountry: enableEditing,
        countriesRepo: countriesRepo,
      );
    } else if (type == FemaleJumperDbRecord) {
      final countriesRepo = (context.read<DatabaseEditorCountriesCubit>().state
              as DatabaseEditorCountriesReady)
          .femaleJumpersCountries;
      return JumperEditor(
        key: key,
        onChange: onChange,
        enableEditingName: enableEditing,
        enableEditingSurname: enableEditing,
        enableEditingCountry: enableEditing,
        countriesRepo: countriesRepo,
      );
    } /*else if (type == Hill) {
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
    }*/
    else {
      throw TypeError();
    }
  }
}
