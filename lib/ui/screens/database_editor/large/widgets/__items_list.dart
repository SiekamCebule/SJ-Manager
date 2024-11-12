part of '../../database_editor_screen.dart';

class _ItemsList extends StatelessWidget {
  const _ItemsList();

  @override
  Widget build(BuildContext context) {
    final itemsState = context.watch<DatabaseItemsCubit>().state;
    final shouldShowList = itemsState is DatabaseItemsNonEmpty;
    late final DbEditorItemsListEmptyStateContentType contentType;
    if (itemsState is DatabaseItemsEmpty && itemsState.hasValidFilters) {
      contentType = DbEditorItemsListEmptyStateContentType.noSearchResults;
    } else {
      contentType = DbEditorItemsListEmptyStateContentType.addFirstElement;
    }

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
          child: DbEditorItemsListEmptyStateBody(
            showNothing: itemsState is DatabaseItemsNonEmpty,
            contentType: contentType,
            removeFilters: () {
              context.read<DbFiltersRepo>().clear();
            },
          ),
        ),
      ],
    );
  }
}
