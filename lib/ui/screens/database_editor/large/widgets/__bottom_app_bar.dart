part of '../../database_editor_screen.dart';

class _BottomAppBar extends StatefulWidget {
  const _BottomAppBar();

  @override
  State<_BottomAppBar> createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<_BottomAppBar> {
  final _bottomAppBarKey = GlobalKey();

  @override
  void initState() {
    scheduleMicrotask(() async {
      context
          .read<_TutorialRunner>()
          .addWidgetKey(step: _TutorialStep.filters, key: _bottomAppBarKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsCubit>().state.itemsType;
    late final Widget body;
    if (itemsType == MaleJumper) {
      body = const _ForJumpersTyped<MaleJumper>();
    } else if (itemsType == FemaleJumper) {
      body = const _ForJumpersTyped<FemaleJumper>(
        key: Key('femaleJumpersFilters'),
      );
    } else if (itemsType == Hill) {
      body = const _ForHills();
    } else {
      throw StateError(
        'A db editor bottom app bar for items of type $itemsType does not exist',
      );
    }

    return BottomAppBar(
      key: _bottomAppBarKey,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: body,
    );
  }
}
