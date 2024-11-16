part of '../../database_editor_screen.dart';

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar();

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsCubit>().state.itemsType;
    late final Widget body;
    if (itemsType == MaleJumperDbRecord) {
      body = const _ForJumpers<MaleJumperDbRecord>();
    } else if (itemsType == FemaleJumperDbRecord) {
      body = const _ForJumpers<FemaleJumperDbRecord>(
        key: Key('femaleJumpersFilters'),
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
