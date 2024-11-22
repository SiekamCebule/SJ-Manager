part of '../../database_editor_page.dart';

class _ItemsList extends StatelessWidget {
  const _ItemsList();

  @override
  Widget build(BuildContext context) {
    final itemsState = context.watch<DatabaseEditorItemsCubit>().state;
    final filtersState = context.watch<DatabaseEditorFiltersCubit>().state;
    if (itemsState is! DatabaseEditorItemsInitialized) {
      return const SizedBox();
    }
    final shouldShowList = itemsState.items.isNotEmpty;

    late final DbEditorItemsListEmptyStateContentType contentType;
    if (itemsState.items.isEmpty && filtersState.validFilterExists) {
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
            showNothing: itemsState.items.isNotEmpty,
            contentType: contentType,
            removeFilters: () async {
              await context.read<DatabaseEditorFiltersCubit>().clearFilters();
            },
          ),
        ),
      ],
    );
  }
}
