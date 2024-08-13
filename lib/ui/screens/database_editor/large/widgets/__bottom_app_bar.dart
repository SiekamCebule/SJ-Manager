part of '../../database_editor_screen.dart';

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: BlocBuilder<DatabaseItemsTypeCubit, Type>(
        builder: (context, itemsType) {
          if (itemsType == MaleJumper || itemsType == FemaleJumper) {
            return const _ForJumpers();
          } else if (itemsType == Hill) {
            return const _ForHills();
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
