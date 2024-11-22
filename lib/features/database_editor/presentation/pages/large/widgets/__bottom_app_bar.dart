part of '../../database_editor_page.dart';

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar();

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseEditorItemsType>();

    late final Widget body;
    if (itemsType == DatabaseEditorItemsType.maleJumper) {
      body = const _ForJumpers(
        key: Key('femaleJumpersFilters'),
        type: DatabaseEditorItemsType.maleJumper,
      );
    } else if (itemsType == DatabaseEditorItemsType.femaleJumper) {
      body = const _ForJumpers(
        key: Key('femaleJumpersFilters'),
        type: DatabaseEditorItemsType.femaleJumper,
      );
    } else {
      throw StateError(
        'A db editor bottom app bar for items of type $itemsType does not exist',
      );
    }

    return BottomAppBar(
      color: Theme.of(context).colorScheme.surfaceContainer,
      clipBehavior: Clip.none,
      child: body,
    );
  }
}
