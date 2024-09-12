part of '../../database_editor_screen.dart';

class _RemoveFab extends StatelessWidget {
  const _RemoveFab();

  @override
  Widget build(BuildContext context) {
    final itemsCubit = context.watch<DatabaseItemsCubit>();
    final selectedIndexesRepo = context.watch<SelectedIndexesRepo>();
    final dbChangeStatusCubit = context.watch<ChangeStatusCubit>();

    return StreamBuilder(
      stream: MergeStream([selectedIndexesRepo.stream]),
      builder: (context, snapshot) {
        return FloatingActionButton(
          key: const ValueKey('removeFab'),
          heroTag: 'removeFab',
          backgroundColor: Theme.of(context)
              .colorScheme
              .tertiaryContainer
              .blendWithBg(Theme.of(context).brightness, 0.2),
          onPressed: () async {
            itemsCubit.remove();
            dbChangeStatusCubit.markAsChanged();
          },
          tooltip: translate(context).remove,
          child: const Icon(Symbols.remove),
        );
      },
    );
  }
}
