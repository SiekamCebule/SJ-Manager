part of '../../database_editor_page.dart';

class AppropriateItemEditor extends StatefulWidget {
  const AppropriateItemEditor({
    super.key,
    required this.itemType,
    required this.onChange,
  });

  final DatabaseEditorItemsType itemType;
  final Function(dynamic) onChange;

  @override
  State<AppropriateItemEditor> createState() => AppropriateItemEditorState();
}

class AppropriateItemEditorState extends State<AppropriateItemEditor> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final filtersState = context.watch<DatabaseEditorFiltersCubit>().state;
    final itemsType = context.watch<DatabaseEditorItemsTypeCubit>().state;
    context.watch<ValueRepo<_SelectedTabIndex>>();

    return _DbItemEditorFactory.create(
      key: _key,
      context: context,
      type: itemsType.type,
      onChange: widget.onChange,
      enableEditing: !filtersState.validFilterExists,
    );
  }

  void fill(dynamic item) {
    (_key.currentState as dynamic)?.setUp(item);
  }
}

abstract class _DbItemEditorFactory {
  static Widget create({
    required Key key,
    required BuildContext context,
    required DatabaseEditorItemsType type,
    required dynamic Function(dynamic value) onChange,
    required bool enableEditing,
  }) {
    if (type == DatabaseEditorItemsType.maleJumper) {
      final countriesRepo = (context.read<DatabaseEditorCountriesCubit>().state
              as DatabaseEditorCountriesInitialized)
          .maleJumperCountries;
      return JumperEditor(
        key: key,
        onChange: onChange,
        enableEditingName: enableEditing,
        enableEditingSurname: enableEditing,
        enableEditingCountry: enableEditing,
        countriesRepo: countriesRepo,
      );
    } else if (type == DatabaseEditorItemsType.femaleJumper) {
      final countriesRepo = (context.read<DatabaseEditorCountriesCubit>().state
              as DatabaseEditorCountriesInitialized)
          .femaleJumperCountries;
      return JumperEditor(
        key: key,
        onChange: onChange,
        enableEditingName: enableEditing,
        enableEditingSurname: enableEditing,
        enableEditingCountry: enableEditing,
        countriesRepo: countriesRepo,
      );
    } else {
      throw TypeError();
    }
  }
}
