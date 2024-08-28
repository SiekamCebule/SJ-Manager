part of '../../database_editor_screen.dart';

class _ItemsList extends StatefulWidget {
  const _ItemsList();

  @override
  State<_ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<_ItemsList> {
  @override
  Widget build(BuildContext context) {
    final itemsState = context.watch<DatabaseItemsCubit>().state;
    final shouldShowList = itemsState is DatabaseItemsNonEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedVisibility(
          duration: Durations.medium1,
          curve: Curves.easeIn,
          visible: shouldShowList,
          child: const _ItemsListNonEmptyStateBody(),
        ),
        AnimatedVisibility(
          duration: Durations.medium1,
          curve: Curves.easeIn,
          visible: !shouldShowList,
          child: const _ItemsListEmptyStateBody(),
        ),
      ],
    );
  }
}
