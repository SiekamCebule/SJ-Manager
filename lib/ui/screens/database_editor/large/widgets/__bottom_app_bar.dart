part of '../../database_editor_screen.dart';

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar();

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsCubit>().state.itemsType;
    late final Widget body;
    if (itemsType == MaleJumper) {
      body = const _ForJumpersTyped<MaleJumper>();
    } else if (itemsType == FemaleJumper) {
      body = const _ForJumpersTyped<FemaleJumper>();
    } else if (itemsType == Hill) {
      body = const _ForHills();
    } else {
      throw StateError(
        'A db editor bottom app bar for items of type $itemsType does not exist',
      );
    }

    return BottomAppBar(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: body,
    );
  }
}
