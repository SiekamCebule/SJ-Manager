part of '../../database_editor_screen.dart';

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: BlocBuilder<DatabaseItemsTypeCubit, DatabaseItemType>(
        builder: (context, itemsType) {
          return switch (itemsType) {
            DatabaseItemType.maleJumper => const _ForJumpers(),
            DatabaseItemType.femaleJumper => const _ForJumpers(),
            DatabaseItemType.hill => const _ForHills(),
          };
        },
      ),
    );
  }
}
